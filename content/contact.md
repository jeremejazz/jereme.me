---
title: "Contact"
subtitle: "Leave a Message"
draft: false
description: "Contact form"
summary: "Leave your message"

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

showHero: false
showZenMode: false
showDate: false
showEdit: false
showAuthor: false
showReadingTime: false
showRelatedContent: false
sharingLinks: false
showPagination: false
---




<div class="contact-form ">
  <form
    name="contact"
    method="POST"
    netlify-honeypot="honey-field"
    data-netlify="true"
  >
    <p class="hidden">
      <label> Field for non-humans: <input name="honey-field" placeholder="info" /> </label>
    </p>
    <input name="name" type="text" class="feedback-input" placeholder="Name" required />
    <input
      name="email"
      type="email"
      class="feedback-input"
      placeholder="Email"
      required
    />
    <textarea
      name="message"
      class="feedback-input"
      placeholder="Message"
      required
    ></textarea>
    <input type="submit" value="SUBMIT" />
  </form>
</div>

<!-- 
<iframe style="display:block; margin: 0 auto;" src="https://docs.google.com/forms/d/e/1FAIpQLScxcwXEmiiYZukVZ7tCAwsH-EJ280dKhHbLSdG8JI__UM5G6A/viewform?embedded=true" width="100%" height="1000" frameborder="0" marginheight="0" marginwidth="0">Loading…</iframe> 
-->
