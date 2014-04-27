---
title: Yet Another Generic "Middleman Powers My Blog" Post
date: 2014-04-27 21:55 CEST
tags: blog
---

It's almost compulsory when someone starts a new static blog to post a "what powers this" article, and who am I to break tradition? So here goes.

**The Engine**

I've decided to use [Middleman](http://middlemanapp.com/) with the [blog extension](https://github.com/middleman/middleman-blog) rather than [Jekyll](http://jekyllrb.com/). After doing some research (ie googling [Middleman vs Jekyll](https://www.google.nl/search?q=middleman+vs+jekyll)) a lot of people seemed to prefer the former over the latter. 

As I had zero experience with static site generators I just decided to go with the flow (after all, when has that [ever gone wrong](http://en.wikipedia.org/wiki/Nazism)) and am quite pleased with my decision. Despite having no Ruby experience at all setting everything up was pretty straightforward and uneventful. 

**Design**

For the [first version](https://github.com/alrayyes/higherlearning.eu/tree/0.1) I decided to be a good developer and use [Bootstrap](http://getbootstrap.com/) as everyone else was using it. However in the mean time [Foundation](http://foundation.zurb.com/) became the new cool kid on the block, so naturally i switched and haven't look back since. 

Even though it's supposed to be minimal, even someone like me with the aesthetic skill of a colour blind accountant is able to build something presentable. Ripping off a the design of the [blog template](http://foundation.zurb.com/templates/blog.html#) and a couple [of](http://www.patricklenz.co/) [sites](http://zachholman.com/) slightly helped a lot too.

For the templating itself I switched from [haml](http://haml.info/) to [slim](http://slim-lang.com/) as I found it a little less convoluted.

**Hosting**

At first I contemplated hosting this on the [CloudVps Object Store](http://www.cloudvps.nl/openstack/object-store) as I already rent a vps from them and am quite happy with their customer support. Also they're significantly cheaper than Amazon S3. Then the cheap little dutch boy in me overpowered my reasoning and forced my hand to host on [Github Pages](https://pages.github.com/) as it's free. Setting up the github side of things is [pretty much idiot proof](http://24ways.org/2013/get-started-with-github-pages/).

**Deployment**

Middleman has a [plugin](https://github.com/neo/middleman-gh-pages) to deploy to Github Pages, but rather than using that I decided to give [Wercker](http://wercker.com/) a shot as I've heard good things and at the time of writing it's free. Setting up wercker to deploy your project to pages is [pretty straight forward as well](http://blog.wercker.com/2013/07/25/Using-wercker-to-publish-to-GitHub-pages.html). The [wercker.yml](https://github.com/alrayyes/higherlearning.eu/blob/master/wercker.yml) config the blog uses is pretty straightforward:

~~~ yaml
box: wercker/ruby
build:
    steps:
        # Execute the bundle install step, a step provided by wercker
        - bundle-install
        # Execute a custom script step.
        - script:
            name: middleman build
            code: bundle exec middleman build --verbose
deploy :
  steps :
    - lukevivier/gh-pages:
        token: $GIT_TOKEN
        basedir: build
        domain: higherlearning.eu
~~~ 

There isn't really much more to say. Hopefully in the future new articles will be a bit more technical and a little less explaining the painfully obvious and trivial.