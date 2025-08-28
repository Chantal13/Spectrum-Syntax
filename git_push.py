#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import os
import sys
import subprocess as sp

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
    except Exception:
        return (0, 0)

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
    Any lone argument (without -m/--message) is treated as commit message.
    """
    opts = {"message": None, "auto_branch": False}
    i = 1
    while i < len(argv):
        a = argv[i]
        if a in ("--auto-branch", "--no-prompt"):
            opts["auto_branch"] = True
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

    # Ensure we are on a branch (not detached) and know upstream
    branch = ensure_on_branch(current_branch(), auto_branch=opts["auto_branch"])
    up = upstream_branch()

    # Fetch remote state
    run(["git", "fetch", "origin"])

    # If we have an upstream, rebase onto it to resolve divergence
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
        # No upstream yet (first push)
        print(f"\nNo upstream set for {branch}. Will set upstream to origin/{branch} on push.")

    # Decide whether a push is needed
    if up:
        behind, ahead = ahead_behind(up, branch)
        print(f"\nStatus vs {up}: behind {behind}, ahead {ahead}")
        need_push = ahead > 0
    else:
        need_push = True  # first push

    # Push
    try:
        if up:
            if need_push:
                run(["git", "push", "origin", branch])
                print(f"\nPushed to origin/{branch} ✓")
            else:
                print("\nNothing to push (branch is up to date).")
        else:
            # First push sets upstream
            run(["git", "push", "-u", "origin", branch])
            print(f"\nPushed and set upstream to origin/{branch} ✓")
    except sp.CalledProcessError as e:
        # Common hint for non-fast-forward
        print("\nPush failed. Try resolving with:")
        print("  git fetch origin")
        print(f"  git rebase origin/{branch}")
        print("  # resolve conflicts → git add -A → git rebase --continue")
        print(f"  git push origin {branch}")
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
