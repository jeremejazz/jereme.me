---
title: "Contact"
subtitle: "Leave a Message"
date: 2025-01-31T13:06:58+08:00
lastmod: 2025-01-31T13:06:58+08:00
draft: false
authors: []
description: "Contact form"


hiddenFromHomePage: false
hiddenFromSearch: false

featuredImage: ""
featuredImagePreview: ""
unsafe: true
toc:
  enable: false
math:
  enable: false
lightgallery: false
license: ""
comment: false
style:
---

{{< raw >}}


<div class="contact-form">
  <form
    name="contact"
    method="POST"
    netlify-honeypot="honey-field"
    data-netlify="true"
  >
    <p class="hidden">
      <label> Field for non-humans: <input name="honey-field" placeholder="info" /> </label>
    </p>
    <input name="name" type="text" class="feedback-input" placeholder="Name" />
    <input
      name="email"
      type="email"
      class="feedback-input"
      placeholder="Email"
    />
    <textarea
      name="message"
      class="feedback-input"
      placeholder="Message"
    ></textarea>
    <input type="submit" value="SUBMIT" />
  </form>
</div>

<!-- 
<iframe style="display:block; margin: 0 auto;" src="https://docs.google.com/forms/d/e/1FAIpQLScxcwXEmiiYZukVZ7tCAwsH-EJ280dKhHbLSdG8JI__UM5G6A/viewform?embedded=true" width="100%" height="1000" frameborder="0" marginheight="0" marginwidth="0">Loading…</iframe> 
-->
{{< /raw >}}
