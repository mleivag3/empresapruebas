# Git & GitHub quick commands

Initialize repo locally and push to GitHub:

```bash
git init
git branch -m main
git add .
git commit -m "Initial infra terraform"
# create repo on GitHub web UI or use gh CLI:
# gh repo create my-org/infra-terraform --public --source=. --remote=origin
git remote add origin git@github.com:<your-org>/<your-repo>.git
git push -u origin main
```

If you prefer to keep secrets out of the repo, add a `.gitignore` and do not commit `terraform.tfvars`.
