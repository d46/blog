#!/usr/bin/env sh
set -eo pipefail

echo "Removing public directory"
rm -rf public
git worktree prune || 
echo "Removing gh-pages branch"
git branch -D gh-pages || 

echo "Add work tree for gh-pages of public directory"
git worktree add -f -b gh-pages public origin/gh-pages

echo "Building site with hugo"
hugo --buildDrafts

if [ ! -d public ]; then
	echo "Something went wrong we should have a public folder."
fi

cd public
git add .
git commit --amend --no-edit
git push origin gh-pages -f

