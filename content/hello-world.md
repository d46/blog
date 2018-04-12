---
title: "How i managed my github page with submodules and hugo ?"
date: 2018-01-17T19:33:58+03:00
draft: true
---


At the beginning of the beginning, It's my first blog post

In my attempt, i will explain how did i refactor beauty and super simple theme from [@jessfraz](https://twitter.com/jessfraz) and how i managed my github pages with submodules


First of all thank you for your theme [@jessfraz](https://twitter.com/jessfraz).

It's a broad cast to the emptiness. To emptiness of my mind..

![emptiness](/img/giphy.gif)

I decided to handle my github pages with much more handy way.
Before making my personal website on github pages, i have been noticed to holding multiple projects in a single repository impeling the code base to unmaintainable. I have not wanted to store blog files, resume, projects in a single repo then basically i figured out to adding my projects as a sub module into the master branch. 


That i thougt, the final structure will be look like this.

- master
    - blog/gh-pages   -> xxx.github.io/blog
    - resume/gh-pages -> xxx.github.io/resume

HERE WE GO!

Lets fork and pull [https://github.com/jessfraz/blog](https://github.com/jessfraz/blog)

```sh
  git clone https://github.com/d46/blog
```

Jess storing her blog in AWS but we are not going to use AWS. 
You can delete Dockerfile or you like to compile your blog in some containerized hugo, update your Dockerfile from my repo.

Also we really don't need Makefile. 

Now open your personal github page repo in this order

[https://pages.github.com/](https://pages.github.com/)

Ok.. Now our goal will be publish the generated files by hugo into the blog/gh-pages branch and move as a submodule into your github pages repo xx.github.io/master

Github pages only show master branch!

Create gh-pages using with orphan branch in blog repo

[git-checkout---orphan](https://git-scm.com/docs/git-checkout/1.7.3.1#git-checkout---orphan)

```sh
  git checkout --orphan gh-pages
  git reset --hard
  git commit --allow-empty -m "Wow"
  git push origin gh-pages
  git checkout master
```

Add directory as a worktree to gh-pages branch

```sh
  git worktree add -B gh-pages public origin/gh-pages
``` 

Compile hugo and publish static files

```sh
  hugo
```

```sh
  cd public
  git add --all
  git commit --amend --no-edit
  git push origin gh-pages -f
```

When you going to switch your branch to the gh-pages you will see there is   just a static files from gh-pages.

Throught the final steps we will add the gh-pages branch as a submodule in to the github pages repo xx.github.io/master

Go to your github pages repo directory.

```sh
  git submodule add -b gh-pages https://github.com/xxx/blog.git blog
  git add .
  git commit -m "Wow"
  git push origin master
```

So now check your web page. xxx.github.io

Here is some automation script to publish your changes

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

Running sh files will do whole taks for you. Don't forget. First you have to run on blog repo release.sh and after that github repo release.sh



<iframe width="100%" height="315" src="https://www.youtube.com/embed/fUuOkuZhtvY" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>







