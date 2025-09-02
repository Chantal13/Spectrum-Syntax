import os
import subprocess as sp
import sys

import pytest

sys.path.insert(0, os.path.dirname(os.path.dirname(__file__)))

import git_push


class DummyCompleted:
    def __init__(self, stdout="", returncode=0):
        self.stdout = stdout
        self.returncode = returncode


def test_out_returns_stripped_stdout(monkeypatch):
    def fake_run(args, check=True, text=True, capture_output=True):
        assert capture_output is True
        return DummyCompleted(stdout="  hello world  \n")

    monkeypatch.setattr(sp, "run", fake_run)
    assert git_push.out(["echo", "hello"]) == "hello world"


def test_run_without_capture_calls_subprocess(monkeypatch):
    called = {}

    def fake_run(args, check=True, text=False, capture_output=False):
        called["args"] = args
        called["check"] = check
        assert capture_output is False
        return DummyCompleted()

    monkeypatch.setattr(sp, "run", fake_run)
    res = git_push.run(["git", "status"], check=False, capture=False)
    assert called["args"] == ["git", "status"]
    assert called["check"] is False
    assert isinstance(res, DummyCompleted)


def test_in_repo_root_not_in_repo_exits(monkeypatch, capsys):
    def fake_run(args, check=True, text=True, capture_output=True):
        raise sp.CalledProcessError(returncode=128, cmd=args)

    monkeypatch.setattr(sp, "run", fake_run)

    with pytest.raises(SystemExit) as ex:
        git_push.in_repo_root()
    assert ex.value.code == 1

    captured = capsys.readouterr()
    assert "Not inside a git repository" in captured.out


def test_in_repo_root_changes_dir_and_prints(monkeypatch, capsys):
    changed_to = {}

    def fake_run(args, check=True, text=True, capture_output=True):
        assert args[:3] == ["git", "rev-parse", "--show-toplevel"]
        return DummyCompleted(stdout="/tmp/repo\n")

    def fake_chdir(path):
        changed_to["path"] = path

    monkeypatch.setattr(sp, "run", fake_run)
    monkeypatch.setattr(git_push.os, "chdir", fake_chdir)

    git_push.in_repo_root()
    assert changed_to["path"] == "/tmp/repo"
    assert "# repo: /tmp/repo" in capsys.readouterr().out


def test_staged_names(monkeypatch):
    def fake_run(args, check=True, text=True, capture_output=True):
        assert args[:3] == ["git", "diff", "--cached"]
        return DummyCompleted(stdout="a.txt\nb.txt\n")

    monkeypatch.setattr(sp, "run", fake_run)
    assert git_push.staged_names() == "a.txt\nb.txt"


def test_working_tree_dirty_true_false(monkeypatch):
    calls = {"n": 0}

    def fake_run(args, check=True, text=True, capture_output=True):
        calls["n"] += 1
        if calls["n"] == 1:
            return DummyCompleted(stdout=" M file.txt\n")
        return DummyCompleted(stdout="\n")

    monkeypatch.setattr(sp, "run", fake_run)
    assert git_push.working_tree_dirty() is True
    assert git_push.working_tree_dirty() is False


def test_current_branch(monkeypatch):
    def fake_run(args, check=True, text=True, capture_output=True):
        assert args[:3] == ["git", "rev-parse", "--abbrev-ref"]
        return DummyCompleted(stdout="main\n")

    monkeypatch.setattr(sp, "run", fake_run)
    assert git_push.current_branch() == "main"


def test_upstream_branch_value_and_none(monkeypatch):
    seq = iter([
        (False, "origin/main\n"),
        (True, None),
    ])

    def fake_run(args, check=True, text=True, capture_output=True):
        should_raise, out = next(seq)
        if should_raise:
            raise sp.CalledProcessError(returncode=2, cmd=args)
        return DummyCompleted(stdout=out)

    monkeypatch.setattr(sp, "run", fake_run)
    assert git_push.upstream_branch() == "origin/main"
    assert git_push.upstream_branch() is None


def test_ahead_behind_parses_counts(monkeypatch):
    def fake_run(args, check=True, text=True, capture_output=True):
        assert args[0:2] == ["git", "rev-list"]
        return DummyCompleted(stdout="2\t5\n")

    monkeypatch.setattr(sp, "run", fake_run)
    assert git_push.ahead_behind("origin/main", "main") == (2, 5)


def test_ahead_behind_on_exception_returns_zeros(monkeypatch):
    monkeypatch.setattr(
        git_push,
        "out",
        lambda *_: (_ for _ in ()).throw(RuntimeError("oops")),
    )
    assert git_push.ahead_behind("origin/main", "main") == (0, 0)


def test_main_first_push_with_commit(monkeypatch, capsys):
    calls = []

    def fake_run(args, check=True, capture=False):
        calls.append(args)
        if args[:2] == ["git", "rebase"]:
            pytest.fail("rebase should not be called when no upstream")
        return DummyCompleted()

    monkeypatch.setattr(git_push, "in_repo_root", lambda: None)
    monkeypatch.setattr(git_push, "run", fake_run)
    monkeypatch.setattr(git_push, "staged_names", lambda: "file.txt")
    monkeypatch.setattr(git_push, "working_tree_dirty", lambda: False)
    monkeypatch.setattr(git_push, "current_branch", lambda: "main")
    monkeypatch.setattr(git_push, "upstream_branch", lambda: None)

    saved_argv = sys.argv
    try:
        sys.argv = ["git_push.py", "Test message"]
        git_push.main()
    finally:
        sys.argv = saved_argv

    # Expected sequence includes status, add, commit, fetch, push -u
    assert [
        ["git", "status"],
        ["git", "add", "-A"],
        ["git", "commit", "-m", "Test message"],
        ["git", "fetch", "origin"],
        ["git", "push", "-u", "origin", "main"],
    ] == [c for c in calls if c[0] == "git"][-5:]

    out = capsys.readouterr().out
    assert "Pushed and set upstream to origin/main" in out


def test_main_first_push_nothing_staged(monkeypatch, capsys):
    calls = []

    def fake_run(args, check=True, capture=False):
        calls.append(args)
        return DummyCompleted()

    monkeypatch.setattr(git_push, "in_repo_root", lambda: None)
    monkeypatch.setattr(git_push, "run", fake_run)
    monkeypatch.setattr(git_push, "staged_names", lambda: "")
    monkeypatch.setattr(git_push, "working_tree_dirty", lambda: False)
    monkeypatch.setattr(git_push, "current_branch", lambda: "main")
    monkeypatch.setattr(git_push, "upstream_branch", lambda: None)

    git_push.main()

    assert ["git", "push", "-u", "origin", "main"] in calls
    out = capsys.readouterr().out
    assert "Nothing to commit." in out


def test_main_with_upstream_rebase_and_no_push_needed(monkeypatch, capsys):
    calls = []

    def fake_run(args, check=True, capture=False):
        calls.append(args)
        return DummyCompleted()

    monkeypatch.setattr(git_push, "in_repo_root", lambda: None)
    monkeypatch.setattr(git_push, "run", fake_run)
    monkeypatch.setattr(git_push, "staged_names", lambda: "")
    monkeypatch.setattr(git_push, "working_tree_dirty", lambda: False)
    monkeypatch.setattr(git_push, "current_branch", lambda: "main")
    monkeypatch.setattr(git_push, "upstream_branch", lambda: "origin/main")
    monkeypatch.setattr(git_push, "ahead_behind", lambda up, br: (0, 0))

    git_push.main()

    assert ["git", "rebase", "origin/main"] in calls
    assert not any(c[:3] == ["git", "push", "origin"] for c in calls)
    out = capsys.readouterr().out
    assert "Nothing to push" in out


def test_main_with_upstream_and_push_needed(monkeypatch):
    calls = []

    def fake_run(args, check=True, capture=False):
        calls.append(args)
        return DummyCompleted()

    monkeypatch.setattr(git_push, "in_repo_root", lambda: None)
    monkeypatch.setattr(git_push, "run", fake_run)
    monkeypatch.setattr(git_push, "staged_names", lambda: "")
    monkeypatch.setattr(git_push, "working_tree_dirty", lambda: False)
    monkeypatch.setattr(git_push, "current_branch", lambda: "main")
    monkeypatch.setattr(git_push, "upstream_branch", lambda: "origin/main")
    monkeypatch.setattr(git_push, "ahead_behind", lambda up, br: (1, 2))

    git_push.main()

    assert ["git", "push", "origin", "main"] in calls


def test_main_rebase_conflict_exits_with_instructions(monkeypatch, capsys):
    def fake_run(args, check=True, capture=False):
        if args[:2] == ["git", "rebase"]:
            raise sp.CalledProcessError(returncode=3, cmd=args)
        return DummyCompleted()

    monkeypatch.setattr(git_push, "in_repo_root", lambda: None)
    monkeypatch.setattr(git_push, "run", fake_run)
    monkeypatch.setattr(git_push, "staged_names", lambda: "")
    monkeypatch.setattr(git_push, "working_tree_dirty", lambda: False)
    monkeypatch.setattr(git_push, "current_branch", lambda: "main")
    monkeypatch.setattr(git_push, "upstream_branch", lambda: "origin/main")

    with pytest.raises(SystemExit) as ex:
        git_push.main()
    assert ex.value.code == 3

    out = capsys.readouterr().out
    assert "Rebase stopped due to conflicts" in out
    assert "git rebase --continue" in out


def test_main_push_failure_shows_hint_and_exits(monkeypatch, capsys):
    def fake_run(args, check=True, capture=False):
        if args[:3] == ["git", "push", "origin"]:
            raise sp.CalledProcessError(returncode=1, cmd=args)
        return DummyCompleted()

    monkeypatch.setattr(git_push, "in_repo_root", lambda: None)
    monkeypatch.setattr(git_push, "run", fake_run)
    monkeypatch.setattr(git_push, "staged_names", lambda: "")
    monkeypatch.setattr(git_push, "working_tree_dirty", lambda: False)
    monkeypatch.setattr(git_push, "current_branch", lambda: "main")
    monkeypatch.setattr(git_push, "upstream_branch", lambda: "origin/main")
    monkeypatch.setattr(git_push, "ahead_behind", lambda up, br: (0, 2))

    with pytest.raises(SystemExit) as ex:
        git_push.main()
    assert ex.value.code == 1

    out = capsys.readouterr().out
    assert "Push failed. Try resolving with:" in out
    assert "git rebase origin/main" in out
