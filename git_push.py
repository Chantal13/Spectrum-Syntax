#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import subprocess as sp
from typing import Optional, Tuple

# Prefer IPv4 for SSH to avoid iCloud Private Relay/IPv6 quirks.
# Only set if not already defined by the user.
if os.environ.get("GIT_SSH_COMMAND") is None:
    os.environ["GIT_SSH_COMMAND"] = "ssh -4"

def run(args, check=True, capture=False):
    print(">", " ".join(args))
    if capture:
        return sp.run(args, check=check, text=True, capture_output=True)
    return sp.run(args, check=check)

def out(args):
    return run(args, capture=True).stdout.strip()

def in_repo_root():
    try:
        root = out(["git", "rev-parse", "--show-toplevel"])
    except sp.CalledProcessError:
        print("Not inside a git repository. Abort.")
        sys.exit(1)
    os.chdir(root)
    print(f"# repo: {root}")

def staged_names():
    return out(["git", "diff", "--cached", "--name-only"])

def working_tree_dirty():
    return bool(out(["git", "status", "--porcelain"]))

def current_branch():
    return out(["git", "rev-parse", "--abbrev-ref", "HEAD"])

def upstream_branch():
    try:
        return out(["git", "rev-parse", "--abbrev-ref", "--symbolic-full-name", "@{u}"])
    except sp.CalledProcessError:
        return None

def ahead_behind(upstream, branch):
    """
    Returns (behind, ahead) counts vs upstream.
    upstream...branch with --left-right --count prints: "<behind>\t<ahead>"
    """
    try:
        s = out(["git", "rev-list", "--left-right", "--count", f"{upstream}...{branch}"])
        left, right = s.split()
        return int(left), int(right)
    except sp.CalledProcessError:
        return (0, 0)


def remote_url(remote: str = "origin") -> Optional[str]:
    try:
        return out(["git", "remote", "get-url", remote])
    except sp.CalledProcessError:
        return None


def parse_github_repo(url: str) -> Optional[Tuple[str, str]]:
    """Return (owner, repo) if URL is a GitHub URL, else None."""
    if not url:
        return None
    url = url.strip()
    if url.startswith("git@github.com:"):
        try:
            path = url.split(":", 1)[1]
            owner, repo = path.rsplit("/", 1)
            if repo.endswith(".git"):
                repo = repo[:-4]
            return owner, repo
        except Exception:
            return None
    if url.startswith("https://github.com/"):
        try:
            path = url[len("https://github.com/") :]
            owner, repo = path.split("/", 1)
            if repo.endswith(".git"):
                repo = repo[:-4]
            return owner, repo
        except Exception:
            return None
    return None


def maybe_print_private_relay_hint(remote: str = "origin") -> None:
    url = remote_url(remote) or ""
    gh = parse_github_repo(url)
    if gh is None:
        return
    owner, repo = gh
    # If already using SSH, just remind about ssh over 443.
    if url.startswith("git@github.com:"):
        print("\nHint: Using SSH with GitHub. If you see intermittent issues on macOS with iCloud Private Relay, ensure your ~/.ssh/config contains:")
        print("  Host github.com")
        print("    HostName ssh.github.com")
        print("    Port 443")
        print("    AddressFamily inet  # Prefer IPv4")
        return
    # If using HTTPS, suggest switching to SSH over 443.
    ssh_url = f"git@github.com:{owner}/{repo}.git"
    print("\nHint: For GitHub + iCloud Private Relay, SSH over 443 is more reliable.")
    print(f"  Switch remote: git remote set-url {remote} {ssh_url}")
    print("  And ensure ~/.ssh/config has:")
    print("    Host github.com")
    print("      HostName ssh.github.com")
    print("      Port 443")
    print("      AddressFamily inet  # Prefer IPv4")

def ensure_on_branch(branch: str, *, auto_branch: bool = False) -> str:
    """
    If currently in detached HEAD (branch == 'HEAD' or empty), prompt to create
    a new branch at the current commit and switch to it. Returns the branch name.
    """
    if branch and branch != "HEAD":
        return branch

    short = out(["git", "rev-parse", "--short", "HEAD"]) or "unknown"
    default_name = f"wip-{short}"
    if auto_branch:
        name = default_name
        print(f"\nDetached HEAD detected. Auto-creating branch {name}.")
    else:
        name = input(
            f"\nYou are on a detached HEAD. Enter a new branch name to create [{default_name}]: "
        ).strip() or default_name
    # Try modern switch first, then fallback to checkout
    try:
        run(["git", "switch", "-c", name])
    except sp.CalledProcessError:
        run(["git", "checkout", "-b", name])
    print(f"\nCreated and switched to branch {name}")
    return name


def parse_cli(argv):
    """Very small CLI parser to support flags without external deps.

    Supported:
      -m, --message <msg>   Commit message
      --auto-branch         Auto-create branch when in detached HEAD
      --rebase-flow         Use pull --rebase workflow (origin/<branch>)
      --remote <name>       Remote name (default: origin)
      --branch <name>       Branch to pull/push (default: current)
      --autostash           Add --autostash to pull --rebase
      --fetch-tags          Run 'git fetch --tags'
      --push-tags           Run 'git push --tags' after push
      --set-pull-rebase     Run 'git config pull.rebase true' (add --global to make global)
      --global              Use with --set-pull-rebase to set globally
      --force-ipv4          Force SSH over IPv4 (sets GIT_SSH_COMMAND="ssh -4")
      --force-ipv6          Force SSH over IPv6 (sets GIT_SSH_COMMAND="ssh -6")
    Any lone argument (without -m/--message) is treated as commit message.
    """
    opts = {
        "message": None,
        "auto_branch": False,
        "rebase_flow": False,
        "remote": "origin",
        "branch": None,
        "autostash": False,
        "fetch_tags": False,
        "push_tags": False,
        "set_pull_rebase": False,
        "global": False,
        "force_ipv4": False,
        "force_ipv6": False,
    }
    i = 1
    while i < len(argv):
        a = argv[i]
        if a in ("--auto-branch", "--no-prompt"):
            opts["auto_branch"] = True
        elif a == "--rebase-flow":
            opts["rebase_flow"] = True
        elif a in ("--force-ipv4", "--ipv4"):
            opts["force_ipv4"] = True
        elif a in ("--force-ipv6", "--ipv6"):
            opts["force_ipv6"] = True
        elif a == "--remote":
            if i + 1 < len(argv):
                opts["remote"] = argv[i + 1]
                i += 1
        elif a == "--branch":
            if i + 1 < len(argv):
                opts["branch"] = argv[i + 1]
                i += 1
        elif a == "--autostash":
            opts["autostash"] = True
        elif a == "--fetch-tags":
            opts["fetch_tags"] = True
        elif a == "--push-tags":
            opts["push_tags"] = True
        elif a == "--set-pull-rebase":
            opts["set_pull_rebase"] = True
        elif a == "--global":
            opts["global"] = True
        elif a in ("-m", "--message"):
            if i + 1 < len(argv):
                opts["message"] = argv[i + 1]
                i += 1
        else:
            if opts["message"] is None:
                opts["message"] = a
        i += 1
    return opts

def main():
    opts = parse_cli(sys.argv)
    # Apply SSH transport preference from CLI, overriding default if provided
    if opts.get("force_ipv4") and opts.get("force_ipv6"):
        # If both are requested, default to IPv4
        os.environ["GIT_SSH_COMMAND"] = "ssh -4"
    elif opts.get("force_ipv4"):
        os.environ["GIT_SSH_COMMAND"] = "ssh -4"
    elif opts.get("force_ipv6"):
        os.environ["GIT_SSH_COMMAND"] = "ssh -6"
    in_repo_root()
    run(["git", "status"], check=False)

    # Always stage everything first
    run(["git", "add", "-A"])

    # Commit if something is staged
    if staged_names():
        msg = (
            opts["message"]
            if opts["message"] is not None
            else input("Commit message: ").strip() or "Update"
        )
        run(["git", "commit", "-m", msg])
    else:
        if working_tree_dirty():
            print("\nWorking tree has changes but none are staged (maybe ignored paths like _site/).")
        else:
            print("\nNothing to commit.")

    # Ensure we are on a branch (not detached)
    curr_branch = ensure_on_branch(current_branch(), auto_branch=opts["auto_branch"])

    if opts["rebase_flow"]:
        branch = opts["branch"] or curr_branch
        remote = opts["remote"]
        if opts["fetch_tags"]:
            run(["git", "fetch", "--tags"]) 
        # Pull with rebase (and optional autostash)
        pull_cmd = ["git", "pull", "--rebase"]
        if opts["autostash"]:
            pull_cmd.append("--autostash")
        pull_cmd.extend([remote, branch])
        try:
            run(pull_cmd)
        except sp.CalledProcessError as e:
            print("\nRebase stopped due to conflicts.")
            print("Resolve conflicts, then:")
            print("  git add -A")
            print("  git rebase --continue")
            print("Or abort:")
            print("  git rebase --abort")
            sys.exit(e.returncode)

        # Push updated branch
        try:
            up = upstream_branch()
            if up is None:
                run(["git", "push", "-u", remote, branch])
                print(f"\nPushed and set upstream to {remote}/{branch} ✓")
            else:
                run(["git", "push", remote, branch])
                print(f"\nPushed to {remote}/{branch} ✓")
        except sp.CalledProcessError as e:
            print("\nPush failed. After resolving, try:")
            print(f"  git push {remote} {branch}")
            # Provide a Private Relay/SSH over 443 hint for GitHub remotes.
            maybe_print_private_relay_hint(remote)
            sys.exit(e.returncode)

        if opts["push_tags"]:
            run(["git", "push", "--tags"]) 

        if opts["set_pull_rebase"]:
            cfg = ["git", "config"]
            if opts["global"]:
                cfg.append("--global")
            cfg.extend(["pull.rebase", "true"])
            run(cfg)
        return

    # Default behavior (upstream-aware rebase & push)
    branch = curr_branch
    up = upstream_branch()
    run(["git", "fetch", "origin"])  # fetch remote state
    if up:
        try:
            run(["git", "rebase", up])
        except sp.CalledProcessError as e:
            print("\nRebase stopped due to conflicts.")
            print("Resolve conflicts in your editor, then:")
            print("  git add -A")
            print("  git rebase --continue")
            print("When done, run this script again to push.")
            sys.exit(e.returncode)
    else:
        print(f"\nNo upstream set for {branch}. Will set upstream to origin/{branch} on push.")

    need_push = True if not up else ahead_behind(up, branch)[1] > 0
    try:
        if up:
            if need_push:
                run(["git", "push", "origin", branch])
                print(f"\nPushed to origin/{branch} ✓")
            else:
                print("\nNothing to push (branch is up to date).")
        else:
            run(["git", "push", "-u", "origin", branch])
            print(f"\nPushed and set upstream to origin/{branch} ✓")
    except sp.CalledProcessError as e:
        print("\nPush failed. Try resolving with:")
        print("  git fetch origin")
        print(f"  git rebase origin/{branch}")
        print("  # resolve conflicts → git add -A → git rebase --continue")
        print(f"  git push origin {branch}")
        # Provide a Private Relay/SSH over 443 hint for GitHub remotes.
        maybe_print_private_relay_hint("origin")
        sys.exit(e.returncode)

if __name__ == "__main__":
    try:
        main()
    except sp.CalledProcessError as e:
        print("\nCommand failed:", e)
        if e.stdout:
            print("\nSTDOUT:\n", e.stdout)
        if e.stderr:
            print("\nSTDERR:\n", e.stderr)
        sys.exit(e.returncode)
