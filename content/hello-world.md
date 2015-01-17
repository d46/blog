---
title: "How i managed my github page with submodules and hugo ?"
date: 2018-01-17T19:33:58+03:00
draft: true
---


At the beginning of the beginning, this is my first blog post i ever had and i am really happy to see this.
In my first post i will explain, how i refactor beauty and super simple theme from [@jessfraz](https://twitter.com/jessfraz).

First of all thank you for your theme [@jessfraz](https://twitter.com/jessfraz).

It's a broad cast to the emptiness. To the emptiness of my mind..

![emptiness](/img/giphy.gif)

Today i decided to handle my github page by effective and much more handy way.
Before making personal web site over github pages i noticed to holding multiple projects on the one repository made me confused. I didn't want to store my blog files and my resume or my own example html css projects only just one repo. Basically i figured out to adding projects as a sub module into to master branch.


The final structure will be look like this.

- master
    - blog/gh-pages   -> xxx.github.io/blog
    - resume/gh-pages -> xxx.github.io/resume

HERE WE GO!

Lets fork and pull [https://github.com/jessfraz/blog](https://github.com/jessfraz/blog)

```sh
  git clone https://github.com/d46/blog
```

Jess was storing her blog in AWS but we are not gonna do this. 
You can delete Dockerfile or if you would like to compile your blog in some containerized hugo, update your Dockerfile from my repo.

Also we really don't need Makefile. 

Now open your personal github page repo in this order

[https://pages.github.com/](https://pages.github.com/)

Ok.. Now goal is publishing to our generated hugo files to blog/gh-pages branch 
then add this branch as a submodule to your github page repo xx.github.io/master

We are doing this because github wants to personal pages in master repo.

Lets create gh-pages using with orphan branch

[git-checkout---orphan](https://git-scm.com/docs/git-checkout/1.7.3.1#git-checkout---orphan)

```sh
  git checkout --orphan gh-pages
  git reset --hard
  git commit --allow-empty -m "Wow"
  git push origin gh-pages
  git checkout master
```

Now lets add directory as a worktree to gh-pages branch

```sh
  git worktree add -B gh-pages public origin/gh-pages
``` 

We are ready to publish our static files. First compile hugo

```sh
  hugo
```

```sh
  cd public
  git add --all
  git commit --amend --no-edit
  git push origin gh-pages -f
```

When you switch your branch to gh-pages you can see there is only static files.

Final steps we are going to add gh-pages branch as a submodule

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

After that all you need is just running sh files. First on blog repo release.sh after github repo release.sh



<iframe width="100%" height="315" src="https://www.youtube.com/embed/fUuOkuZhtvY" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>







