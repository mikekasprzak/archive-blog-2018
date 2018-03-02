---
id: 9300
title: 'Notes: Rogers Wireless E-mail to Text'
date: 2016-09-20T23:26:38+00:00
author: Mike K
layout: post
guid: http://blog.toonormal.com/?p=9300
permalink: /2016/09/20/notes-rogers-wireless-e-mail-to-text/
categories:
  - Uncategorized
---
Rogers has 2 ways (that I know of) for sending short e-mails to people as text messages.

<!--more-->

## sms.rogers.com

Send an e-mail to **TENDIGITPHONENUMBER@sms.rogers.com** where TENDIGITPHONENUMBER is your ten digit phone number (i.e. 555-555-5555, but without the dashes). You&#8217;ll receive a message looking like this:

<pre class="lang:default decode:true " >Fr:you@domain.com
Su:The Subject
Msg:Whatever the message was</pre>

Each messages seems to come from a **unique** 11 digit address, even if the incoming e-mail address is the same. This is a limitation of the rogers system (or specifically &#8220;by design&#8221;). Bell apparently does not have this limit.

The first was 222220000, the 2nd 222220001, and so on. 

**NOTE:** These incoming number is longer than a phone number (typically 10 digits).

I can&#8217;t find any documentation for this, but I did find a [rogers technician](http://communityforums.rogers.com/t5/forums/forumtopicpage/board-id/Other_mobile_device/message-id/4428#M4428) **recommending it**.

No idea what the limits are, or how to avoid being blacklisted (if that&#8217;s even a thing).

I found a thread talking about a spammer that was sending explicit (ala &#8220;hey sexy boy&#8221;) messages to people using this method. Of note, the incoming 11 digit numbers were either in 22222xxxx format, or 3333333xxx form. This happened this year actually. It was eventually resolved, I think anyway (the replies in the thread stopped).

## pcs.rogers.com

The legacy mail-to-text service. This exists so older non-smartphones can get e-mail. It&#8217;s beholden to some limitations, but has some additional features like custom e-mail addresses (you@pcs.rogers.com). 

**THIS IS NOT WORTH USING. YOU MAY BE CHARGED $5 A MONTH!** 

IF YOU TEST THIS, MAKE SURE YOU DON&#8217;T ACCIDENTALLY SUBSCRIBE.

[http://www.rogers.com/cms/html/addons/en/email\_to\_text.html](http://www.rogers.com/cms/html/addons/en/email_to_text.html)

> Send and receive email via text messaging
> 
> 1. Your phone&#8217;s e-mail address is your 10digitphonenumber@pcs.rogers.com
  
> 2. You will receive a &#8216;Message Alert&#8217; when an e-mail is sent to your phone.
  
> 3. Simply reply &#8220;**read**&#8221; to the Message alert if you want to receive the message, or reply &#8220;**block**&#8221; to the Message alert to block the sender from sending you future messages
> 
> Features & Benefits
> 
> * Receive the first 160 characters of each message automatically. If the message is over 160 characters, you must reply **MORE** to be sent more of the message.
  
> * Create your own e-mail address (eg. youralias@pcs.rogers.com). Availability is on a first come, first serve basis
  
> * Spam control blocks unwanted e-mail messages

Reply Commands:

> <table>
>   <tr>
>     <td>
>       <strong>Command</strong>
>     </td>
>     
>     <td>
>       <strong>Short Forms</strong>
>     </td>
>     
>     <td>
>       <strong>Description</strong>
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       Read
>     </td>
>     
>     <td class="shrtform_col">
>       R
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Reads or gets the next part of the message
>     </td>
>   </tr>
>   
>   <tr>
>     <td class="command_col">
>       Block
>     </td>
>     
>     <td class="shrtform_col">
>       B
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Adds the sender to your &#8220;deny&#8221; list (spam control*)
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       Forward <i>email@addr.com</i>
>     </td>
>     
>     <td class="shrtform_col">
>       F
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Forward the entire e-mail message (including attachments) to another e-mail address
>     </td>
>   </tr>
>   
>   <tr>
>     <td class="command_col">
>       Forward <i>addr1; addr2; addr&#8230;</i>
>     </td>
>     
>     <td class="shrtform_col">
>       F
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Forward the entire e-mail message to a list of e-mail addresses (separate addresses with semicolons)
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       Get cc
>     </td>
>     
>     <td class="shrtform_col">
>       Gcc,<br />G cc
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Retrieves the cc list on a received message
>     </td>
>   </tr>
>   
>   <tr>
>     <td class="command_col">
>       <i>Any other text</i>
>     </td>
>     
>     <td class="shrtform_col">
>
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Replying with any other text will send that text back to the original sender as a reply to the sender&#8217;s email
>     </td>
>   </tr>
> </table>

To configure the service itself, you send texts to 0000000000 (10 zeros).

> <table>
>   <tr>
>     <td>
>       Command
>     </td>
>     
>     <td>
>       Description
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       Subscribe
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Turns the E-Mail to Text service on
>     </td>
>   </tr>
>   
>   <tr>
>     <td class="command_col">
>       unSubscribe
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Turns the E-Mail to Text service off
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       Alias <i>name</i>
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Defines your alias (e.g. <i>name</i>@pcs.rogers.com)
>     </td>
>   </tr>
>   
>   <tr>
>     <td class="command_col">
>       Name <i>your name</i>
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Defines a familiar name (e.g. &#8220;John Smith&#8221;), in addition to the e-mail alias, for outbound e-mails from your phone
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       number off
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Turns alerts off for e-mail sent to <i><b>number</b>@pcs.rogers.com</i>. <b>Note</b>: You must define an alias in order to use this command!
>     </td>
>   </tr>
>   
>   <tr>
>     <td class="command_col">
>       number on
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Turns alerts for <i><b>number</b>@pcs.rogers.com</i>back on
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       cc on
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       All replies will be sent to all addresses in the &#8216;To&#8217; and &#8216;cc&#8217; fields of the original received e-mail
>     </td>
>   </tr>
>   
>   <tr>
>     <td class="command_col">
>       cc off
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Turns carbon copy reply off
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       Allow <i>email@addr.com</i>
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Add a sender to the &#8220;allow&#8221; list, removing that sender from the &#8220;deny&#8221; list if necessary. (spam control*)
>     </td>
>   </tr>
>   
>   <tr>
>     <td class="command_col">
>       Allow <i>domain.com</i>
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Add any address from a domain to the &#8220;allow&#8221; list (<i>any user</i>@domain.com)
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       Block<br /><i>email@addr.com</i>
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Add a sender to the &#8220;deny&#8221; list, removing that sender from the &#8220;allow&#8221; list if necessary. (spam control*)
>     </td>
>   </tr>
>   
>   <tr>
>     <td class="command_col">
>       Block <i>domain.com</i>
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Add any address from a domain to the &#8220;deny&#8221; list (<i>any user</i>@domain.com)
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       Francais
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Request service in French
>     </td>
>   </tr>
>   
>   <tr>
>     <td class="command_col">
>       Help
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Returns a list of help topics
>     </td>
>   </tr>
>   
>   <tr class="type1">
>     <td class="command_col">
>       Help command
>     </td>
>     
>     <td colspan="2" class="desp_col">
>       Returns help for using a specific command
>     </td>
>   </tr>
> </table>

## Online Tool

There are also online tools you can access, once logged in to your rogers account, for doing this.

[http://www.rogers.com/web/Rogers.portal?\_nfpb=true&\_pageLabel=GCT&template=wireless-text&sub\_template=send\_message](http://www.rogers.com/web/Rogers.portal?_nfpb=true&_pageLabel=GCT&template=wireless-text&sub_template=send_message)

## Other Fun Things

It seems if you accidentally text a regular phone line, Rogers will charge you 15 cents, and a robot will read the text.

[http://www.rogers.com/web/Rogers.portal?\_nfpb=true&\_pageLabel=GCT&template=wireless-text&sub\_template=txt\_2_landline](http://www.rogers.com/web/Rogers.portal?_nfpb=true&_pageLabel=GCT&template=wireless-text&sub_template=txt_2_landline)

## On Twitter and Text Messages

A text message typically has a limit of **160** characters. This rule should apply above.

Twitter is historically 140 characters because they allocated **140 characters** for the message, and **20** for the **name**.

In practice though, Twitter actually limits your **username** to **15 characters**. Your styled &#8220;Full Name&#8221; can be the whole **20 characters**. I don&#8217;t have confirmation of this, but technically 15 characters + &#8220;@t.co&#8221; is also 20 characters.

<http://mentalfloss.com/uk/technology/35957/why-is-twitter-limited-to-140-characters>

## On Other Services

Replace [num] with a 10 digit phone number (i.e. 5555555555).

  * [num]@sms.rogers.com
  * [num]@txt.bell.ca &#8211; also <http://txt.bell.ca>
  * [num]@msg.telus.com
  * [num]@fido.ca &#8211; but this appears to be the rogers legacy service. @sms.fido.ca may work
  * [num]@msg.koodomobile.com
  * [num]@mobiletxt.ca (PC Mobile) &#8211; no website, but bell runs the domain
  * [num]@vmobile.ca (Virgin Mobile)
  * [num]@txt.windmobile.ca &#8211; May require activation
  * [num]@sms.sasktel.com (Saskatchewan)
  * [num]@text.mts.net (Manitoba)

This isn&#8217;t trying to be a comprehensive list, but at least lists several of the Canadian ones. I can&#8217;t find one for Roam Mobility.