# Git workflow

Git keeps local change history; GitHub hosts your remote portfolio. Neither backs up your VMs.

## First setup

Install Git for Windows if needed, reopen PowerShell, and verify `git --version`.

From this project directory, run one command at a time:

```powershell
git init -b main
git config user.name "YOUR NAME"
git config user.email "YOUR GITHUB NOREPLY EMAIL"
git status
git add README.md .gitignore docs templates investigations detections scripts evidence
git diff --cached
git commit -m "docs: add SOC lab plan and portfolio structure"
```

- `init -b main`: create a repository with the main branch.
- `config`: set this repository's commit author. Use the private email supplied by GitHub if preferred.
- `status`: inspect changed and staged files.
- `add`: stage the specified files for your next commit.
- `diff --cached`: review the exact staged changes for accuracy and sensitive data.
- `commit -m`: record a local checkpoint with an explanation.

Create an empty GitHub repository named `shahidtech-soc-lab` without generating extra files. Substitute your real username below:

```powershell
git remote add origin https://github.com/YOUR-USERNAME/shahidtech-soc-lab.git
git push -u origin main
```

`remote add` records your destination; `push -u` uploads history and sets branch tracking. Use supported interactive authentication; never embed tokens in files or URLs.

## Each lesson

1. Define one small outcome. Create a branch, for example `git switch -c docs/phase-0-host-planning`.
2. Complete and verify the exercise. Update the lesson and progress tracker with sanitized evidence.
3. Check `git status`, stage exact files, and review `git diff --cached`.
4. Commit one meaningful result, for example `docs: verify workstation domain join`.
5. Push the branch using `git push -u origin docs/phase-0-host-planning` and open a pull request describing the change and verification.
6. After reviewing and merging, use `git switch main` and `git pull --ff-only`.

Keep commits truthful and focused. Gitignore does not remove previously tracked files or erase secrets from history.
