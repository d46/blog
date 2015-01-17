#!/usr/bin/env sh
set -eo pipefail

echo "Building site with hugo"
hugo --buildDrafts

if [ ! -d public ]; then
	echo "Something went wrong we should have a public folder."
fi

cd public
git add .
git commit --amend --no-edit
git push origin gh-pages -f

