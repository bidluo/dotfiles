# Working with David

## Git

**Never create a branch on your own initiative.** Commit to the branch that's
already checked out. Do not `git checkout -b` because a change feels large, or
because the current branch is `main`/`master` — if a branch genuinely seems
warranted, say why and ask first.

This overrides the general default of branching off the default branch. That
default assumes a remote and a review flow; assume neither unless you've checked
`git remote -v` and found one.

**Commit and push only when asked.** Not proactively, and not as a tidy-up step
at the end of a task.

**Stage precisely.** Prefer explicit paths over `git add -A` / `git add .` —
there is often unrelated work in progress in the tree, and sweeping it into a
commit is not recoverable by simply amending.
