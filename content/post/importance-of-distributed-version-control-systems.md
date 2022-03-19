---
title: The Importance of Distributed Version Control Systems
date: 2015-11-21 00:00:00
tags:
  - version control
  - git
lastmod: 2022-01-30
 
 
cover: 
  image: /images/version-control/branching-git.png
 
tags:
  - best practices
  - development
 
---

These days, the use of Distributed Version Control Systems (DVCS) has become a standard in most large products. It is an automated to save a lot of tasks, and resources such as disk space.

<!--more-->

`*Update: (1/30/2022): Update resources for git*`

**What is DVCS?**

For those who don’t know what distributed version control is, it is an automated way of storing changes on your code while collaborating with other programmers under that shared project. Think of it as creating backup copies of your project on your drive (and probably adding dates on your compressed folders) and merging your latest code with your teammate. Without this, the task would be very tedious and also use a lot of resources especially if you have a very large project.

Even though such system exists, a lot of developers still prefer the old fashioned way of collaboration. Either they are unfamiliar with this kind of workflow or they find it confusing and complicated especially when creating and pushing commits which creates an additional task. Or another reason would probably be the fact that the team is too small to implement this kind of workflow. But even when working alone, it is still recommended to use DVCS especially the fact that you can view your history, and back it up as well on free repository servers such as Github or Bitbucket.

## Reasons to Use DVCS

Here are a few common reasons why every programmer or teams should be using distributed version control systems.

### Backup
 
 
{{< figure src="/images/version-control/file-copies-300x188.png" align="center"  >}}
  Most DVCS has this feature called commit. When the developer commits his/her code, it creates a snapshot of the changes made to that project and is stored on the local workstation. Like a time machine, you can view your past revisions, or get some code you have erased in the past. Not only that, you can push your changes on a centralized server like Github, and whenever someone pulls those changes, they too can have a copy of the revisions you did alone with your latest code.

### Collaboration and Merging 

 
{{< figure src="/images/version-control/centralized-collaboration-300x152.png" align="center"  >}}
  This is also an important tool especially when working with others. Softwares like Git/Mercurial allow you to merge the changes you have made. In fact, they have a smart way of merging code automatically especially when changes are not made on the same lines. But if the smart merge can’t figure out how to merge it since you’ve edited the same lines which can’t be avoided, a mark is added which can be easilly found that there is a conflict on those files. In fact, there are also free visual tools that make manual merging more easier.
  As I mentioned in #1, all commits are distributed to everyone who pulls the changes (Yes, that’s why it’s called Distributed Version Control). Everyone can see what changes were made by the other developer, you can even check how long was he able to make the change or when was the change made

### Branching

 
{{< figure src="/images/version-control/branching-concept-300x125.png" align="center"  >}}
  This is a bit more advanced workflow in collaboration but can also applicable even to those who are working alone. When you don’t want your change to affect what others are doing, like probably you are working on an enhancement and it might interrupt on the work of your teammate or you just want to do some changes to be thrown away later, you can simply use branching. If you’re into sci-fi (like me), branching is somehow like creating alternate timelines. Well basically, you are just making a new path for your revisions which if it turns out right you can merge it to your main branch. In fact everything you work on in either Git or Mercurial is a branch which just happens to be a default branch at start. Merge conflicts even create temporary branches that are merged after they are resolved. Branching is a very powerful feature of DVCS

### It’s Free!

{{< figure  src="/images/misc/free-300x206.gif" align="center"  >}}
Well yeah probably one of the best perks in life come in free. You don’t even need to spend a dime on popular programs like Git or Mercurial. In fact, the creator of Git, Linus Torvalds (the same guy who created Linux), worked on this because the current free closed-source version control system he was using was no longer free. Git and Mercurial will always be free to use as it uses a free and open source license. Although there are also some paid softwares, you&#8217;ll do fine with the free ones.

### Contributing to Open Source

 
{{< figure  src="/images/misc/bart_os-300x209.gif" align="center"  >}}

If you would like to contribute to open source projects especially those hosted in Github or Bitbucket, you would need DVCS like Git in order to make pull requests. They have a workflow when it comes to contributing such as forking the project (creating a copy) and you can make a pull request to apply the changes to the original project.

## Conclusion

The use of DVCS is a very important practice for developers either working solo or with a team. You can either use Git, Mercurial, or even Bazaar(although I’m not sure if it is still being supported) for your projects if you want to implement this kind of version control.

There are may work flow and strategies on implement this which I haven’t covered but I suggest you check it out first especially before implementing it to your team. Here is a good place to start and find out what is the best work flow that would suit you well.

Here is a list of free resources to start with:
  * [Atlassian Git Tutorials and Training](https://www.atlassian.com/git/tutorials)
  * <a href="https://git-scm.com/book/en/v2" target="_blank" rel="nofollow">Pro Git</a> &#8211; Free ebook by written by Scott Chacon and Ben Straub published under Creative Commons Attribution. You can also purchase a hard copy from Amazon.
  * ~~<a href="#" target="_blank" rel="nofollow">try.github.io</a> &#8211; An interactive introduction provided by codeschool for basic commands and concepts in git.~~
  * ~~<a href="#" target="_blank" rel="nofollow">hginit.com</a> &#8211; A good intruduction for mercurial. Provides illustrations and some basic concepts.~~
  * ~~<a href="#" target="_blank" rel="nofollow">Mercurial: The Definitive Guide</a> &#8211; Although as far as I know, when you install Mercurial especially on windows, an ebook already included. But you can also purchase a hard copy at Amazon or O&#8217;Reilly Media.~~
