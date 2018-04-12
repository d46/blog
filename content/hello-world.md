---
title: "How i managed my github page with submodules and hugo ?"
date: 2018-01-17T19:33:58+03:00
draft: false
---


At the beginning of the beginning, It's my first blog post

In my attempt, i will explain how did i refactor beauty and super simple theme from [@jessfraz](https://twitter.com/jessfraz) and how i managed my github pages with submodules


First of all thank you for your theme [@jessfraz](https://twitter.com/jessfraz).

It's a broad cast to the emptiness. To emptiness of my mind..

![emptiness](/img/giphy.gif)

I decided to handle my github pages with much more handy way.
Before making my personal website on github pages, i have been noticed to holding multiple projects in a single repository impeling the code base to unmaintainable. Then i figured out to adding my projects as a sub module into the master branch could fix that complication. 

HERE WE GO!

Lets fork and pull [https://github.com/jessfraz/blog](https://github.com/jessfraz/blog)

```sh
git clone https://github.com/d46/blog
```

Jess has been storing her blog in AWS but we are not going to use AWS in accordance with you could erase Dockerfile or you can compile your blog with containerized hugo. Also we are not use Makefile. 

Now open your personal github page repo in accordance with this documentation
[https://pages.github.com/](https://pages.github.com/)


#### Ok.. 
Now our goal will be publish the generated files by hugo into the blog/gh-pages branch and move as a submodule into your github pages repo xx.github.io/master

Final structure going to look like this.

- master
    - blog/gh-pages   -> xxx.github.io/blog
    - resume/gh-pages -> xxx.github.io/resume


The point of doing this is Github pages are only show master branch!

#### Now lets start with blog. 

Create gh-pages using with orphan branch from master.

Oprhan branch creates a tree from some commit point and it is being the root of a new history totally disconnected from all the other branches and commits.
 
[git-checkout---orphan](https://git-scm.com/docs/git-checkout/1.7.3.1#git-checkout---orphan)

```sh
git checkout --orphan gh-pages
git reset --hard
git commit --allow-empty -m "Wow"
git push origin gh-pages
git checkout master
```
Now we had gh-pages witouth history commits. In our approach we need to add our public directory in master branch to gh-pages repo with worktree.

#### Adding working tree

Worktree is allowing us to manage a multiple working trees in same repo.

```sh
# Add public directory  as a worktree in to gh-pages branch
git worktree add -B gh-pages public origin/gh-pages
``` 

Compiling hugo and publishing static files
```sh
hugo
cd public
git add --all
git commit --amend --no-edit
git push origin gh-pages -f
```

When you switch the master branch to the gh-pages you will see there is just a static files.

Throught the final steps we are going to add gh-pages branch as a submodule in to the github pages repo xx.github.io/master


#### Adding as a submodule
Go to your github page's repo directory and make submodule.

Submodules is allowing us to mount one repository inside another
```sh
git submodule add -b gh-pages https://github.com/xxx/blog.git blog
git add .
git commit -m "Wow"
git push origin master
```
Now that makes xxx.github.io repo like this
- master
    - blog/gh-pages   -> xxx.github.io/blog

Check your web page. xxx.github.io/blog. It is trigger the blog/gh-pages/index.html file.

Also here are some automation scripts to publish your changes

release.sh for your blog/master
```sh
#!/usr/bin/env sh
set -eo pipefail

echo "Building site with hugo"
hugo

if [ ! -d public ]; then
    echo "Something went wrong we should have a public folder."
fi

cd public
git add .
git commit --amend --no-edit
git push origin gh-pages -f
```

release.sh to github page repo
```sh
#!/usr/bin/env sh
set -eo pipefail

# Update Blog module
cd blog
git checkout gh-pages
git pull origin master
cd ..

# Commit changes
git add .
git commit --amend --no-edit
git push origin master -f
```

Running sh files will do whole taks for you. Don't forget. First run on blog repo's release.sh and after xxx.github.io repo's release.sh



