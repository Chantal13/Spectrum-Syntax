import subprocess

def run_command(command):
    """Run a shell command and print its output."""
    try:
        result = subprocess.run(command, check=True, text=True, capture_output=True)
        print(result.stdout)
        if result.stderr:
            print(result.stderr)
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {' '.join(command)}")
        print(e.stderr)

def main():
    # Step 1: Add all changes
    print("Adding all changes...")
    run_command(["git", "add", "--all"])
    
    # Step 2: Prompt for commit message
    commit_message = input("Enter commit message: ").strip()
    if not commit_message:
        print("Commit message cannot be empty.")
        return
    
    # Step 3: Commit
    print(f"Committing with message: {commit_message}")
    run_command(["git", "commit", "-m", commit_message])
    
    # Step 4: Push
    print("Pushing to origin main...")
    run_command(["git", "push", "origin", "main"])

if __name__ == "__main__":
    main()