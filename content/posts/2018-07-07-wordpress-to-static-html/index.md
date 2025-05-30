---
title: "From Wordpress to Static HTML"
date: 2018-07-07T16:06:42+08:00
slug: wordpress-to-static-html
draft: false
categories:
  - blog
tags:
  - development
  - blogging
  - cms
author:
  name: Jereme
  link:
  email:
  avatar:
resources:
  - name: featured-image
    src: images/wordpress-sea.jpg
  - name: featured-image-preview
    src: images/featured-preview.jpg
related:
  enable: false
toc:
  enable: true
---

For years, Wordpress has become the best choice in publishing a self-hosted blog. From its user friendly content management to the available plugins and themes where most of even come for free. Perhaps Wordpress has also become the defacto application for blogging especially to whose who prefer simple yet powerful features. One of the main reasons of using Wordpress and other content management is to make editing dynamic.

<!--more-->

For years, I have been using wordpress for my personal website and the application just gets better on every update. Since it is written in PHP, it is not that expensive to find a good hosting website that cost less on websites like Hostinger and Hostgator. Hosting your own website allows you to maximize the customization and even gives more extensibility.

## Enter Static Generators

After some time though I have noticed the emergence of static websites. Thanks to some available developer tools, it is easier to automate building webpages even through static html pages. This is not even a new technology. As the emergence of programming languages, they have also incuded documentation generators, programs that allows to extract comment descriptions from the source code libraries to generate documentations in html. As the world wide web improved in terms of design and availability, new tools have followed as well.

Static generators, as the name suggests, are programs that automates the building of static websites based on the configurations given. The workflow of these types of statically created websites are different than traditional content management systems yet the still provides a lot of advantages.

{{< figure src="images/traditional.png" alt="Backend Management" >}}

As for the traditional content management systems like Wordpress or Joomla the user accesses a part of the website that allows the user to log in to an administrator dashboard where content and other site settings is managed. Whereas for static pages, content is done through files usually without databases. After configuration and content has been made, the generator is executed to automate the process of making the website.

{{< figure src="images/staticgenerator.png" alt="Static Generator" >}}

Some static site generators offer simple configurtion that allows the user to change the title and theme to creating blogs contents though file organization. There are lots of applications that provides this [staticgen.com](https://staticgen.com) provides a good list and summary of these.

## Advantages and Disadvantages of Static Generators

### Advantages

- **Very cheap**. This is one of the main reason why static generators are chosen, they are very cheap to make. For an instance, Github allows [free hosting of static pages](https://pages.github.com/). Simply uploading HTML files to your main makes it automatically published. There are also cheap file storage like Amazon S3 which makes websites like these work.
- **Performance**. Since no database and server side rendering is involved, loading page is faster. This is similar to using a cache plugin on existing content management systems that create HTML cache for webpages
- **Live reloading**. Part of the automation, is being able to be automatcally reloaded in the browser for every changes made in the files. This is very useful in development as you can see what it would look like as it previewed.
- **Security**. There is also a good security on your website due to the fact that you don't have an administrator URL route like `/administrator` or `/wp-admin` that exposes your administrator back-end especially to brute force attacks. In Wordpress I had to install captcha and anti-bruteforce plugins and even get reports of brutefoce attempts. There are even times when I accidentally get locked out due to wrong attempts.

### Disadvantages

- **Steep Learning curve**. This is like driving in manual mode. And it would require a bit of programming knowledge to work with static generators. Though most of the time you would not work from scratch since it is automatically generated, you would still make use of configuration files, find your own scripts, and spend a lot of time with the documentation.
- **No user management**. Though some static generators allow multiple authors for articles, there is still a lacking user administration unlike content management systems. In Wordpress you can assign roles to all users. Here the privileges are controlled.
- **Configuration can be a nightmare**. Joomla and Wordpress are made to be user friendly where most of the options just needs to be selected. There are even sometimes hints available on first run. This is not the case of using static generators and you would be depending on the documentation. It also becomes a problem when a static generator is poorly documented.
- **Difficult File management**. As your website grows, especially after publishing a lot of articles or pages, it tends to become difficult to manage these. Softwares like Wordpress allow easier filtering and batch processing to articles. To get around with this, you might have to organize files into directories and make use of batch processing scripts.
- **Limited Publishing Access**. Since the back-end administration can be accessed via browser, this allows authors to publish anywhere, even on a mobile phone. This is not the case of static generators since you will need a machine and tools installed to generate and deploy static files. Perhaps a workaround for this though is to make use of _continuous deployment_ and allowing direct access to the remote repository. Still it is more inconvenient especially when working outside your work environment.

## Conclusion

Static Site generator is a good alternative to web content management systems. Though when deciding whether to use them or not there some advantages and disadvantages that needs to be carefully considered. I chose static site generator specifically for my blog simply to cut down costs and since cloud computing is becoming available and cheaper I would also like to utilize these available tools since a lot of things are changing now. I'm not saying using content management systems are bad, they are still good in many ways and there are a lot of things static site generators alone cannot do. Since they are self-hosted, they both give you full customization of your website compared to online blogging services.

---

> Cover image by https://pixabay.com under CC0 Creative Commons license
