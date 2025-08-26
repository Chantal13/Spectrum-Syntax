#!/usr/bin/env python3
import os
import subprocess as sp
import sys

def run(args, **kw):
    print(">", " ".join(args))
    return sp.run(args, **kw)

def out(args):
    r = run(args, capture_output=True, text=True, check=True)
    return r.stdout.strip()

def main():
    # Ensure we’re at the repo root
    try:
        root = out(["git", "rev-parse", "--show-toplevel"])
    except sp.CalledProcessError:
        print("Not inside a git repo. Abort.")
        sys.exit(1)
    os.chdir(root)
    print(f"# repo: {root}")

    # Show current status (working tree)
    run(["git", "status"], check=False)

    # ALWAYS stage everything first
    run(["git", "add", "-A"], check=True)

    # What’s staged?
    staged = out(["git", "diff", "--cached", "--name-status"])
    if not staged:
        # Nothing staged—print extra diagnostics and exit nicely
        wt = out(["git", "status", "--porcelain"])
        print("\nNo staged changes. (Nothing to commit.)")
        if wt:
            print("\nWorking tree has changes but they may be ignored or outside the repo root:")
            print(wt)
            print("\nCommon gotchas:")
            print(" • You edited files under _site/ (ignored). Edit source files instead.")
            print(" • File path case mismatch (macOS is case-insensitive).")
            print(" • You saved to a different folder than the repo.")
        else:
            print("\nWorking tree is clean.")
        return

    print("\nStaged changes:")
    print(staged)

    # Commit
    msg = input("\nCommit message: ").strip() or "Update"
    run(["git", "commit", "-m", msg], check=True)

    # Push to current branch
    branch = out(["git", "rev-parse", "--abbrev-ref", "HEAD"])
    run(["git", "push", "origin", branch], check=True)
    print(f"\nPushed to origin/{branch} ✓")

if __name__ == "__main__":
    try:
        main()
    except sp.CalledProcessError as e:
        print("\nCommand failed:")
        print(" ", " ".join(e.cmd if isinstance(e.cmd, list) else [str(e.cmd)]))
        if e.stdout:
            print("\nSTDOUT:\n", e.stdout.decode() if isinstance(e.stdout, bytes) else e.stdout)
        if e.stderr:
            print("\nSTDERR:\n", e.stderr.decode() if isinstance(e.stderr, bytes) else e.stderr)
        sys.exit(e.returncode)