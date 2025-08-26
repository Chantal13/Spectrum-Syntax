import subprocess as sp

def run(cmd, check=True):
    print(">", " ".join(cmd))
    return sp.run(cmd, check=check)

def changed():
    r = sp.run(["git", "status", "--porcelain"], capture_output=True, text=True)
    return bool(r.stdout.strip())

def main():
    # Show what changed
    run(["git", "status"], check=False)

    if not changed():
        print("No changes detected. Nothing to commit.")
        return

    msg = input("Enter commit message: ").strip()
    if not msg:
        msg = "Update"

    run(["git", "add", "-A"])
    # IMPORTANT: pass the message as a separate arg, not in a single string
    run(["git", "commit", "-m", msg])
    run(["git", "push", "origin", "main"])

if __name__ == "__main__":
    try:
        main()
    except sp.CalledProcessError as e:
        print("Command failed:", e)
        print("Output:", (e.stdout or b"").decode(errors="ignore"))
        print("Error:", (e.stderr or b"").decode(errors="ignore"))