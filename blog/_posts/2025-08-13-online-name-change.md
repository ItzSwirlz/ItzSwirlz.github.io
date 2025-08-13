---
layout: post
title: Online name change + thinking about things
date: 2025-08-13 13:36:04 -0400
categories: misc yapping honey honey-extension
---

So for summer English homework, I get the joy of reading parts of Phillip Lopate's *The Art of the Personal Essay*, which I have some mixed feelings on, but just going through it made me want to write myself. I'll just cover some basic things and briefly mention what I'm thinking about.

# Name change
The name "ItzSwirlz" came from my Geometry Dash phase. There are various reasons why I do not play the game much anymore, but as time went on I knew I would have to change the name.

Many players in Geometry Dash, as of the time (around maybe, 2016-2021?) chose names that began with S, including Sunix, Serponge, Sea, (I think also I was inspired by Skullo) and I remember there being more influences on it. I eventually chose "Swirlz", and the name "ItzSwirlz" was born.

There are probably other names I could have kept, like the name I used when I played Club Penguin (though it wouldn't work because "Pengi" gets mistaken for "Pingu"), but I am sticking with JPeisach.

I acknowledge there will likely be another future person with the last name Peisach, first name starting with a J. In which, I am sorry. But since technology is always rapidly changing, I think I should claim the early name, despite being late to the party. Having the username of "john" gives you immense power, so I will take that opportunity.

# Ristretto blog posts
I said I would come back to these, and I should. I just never actually do it. I could write an entire blog dedicated to my struggle with ProcUI, or some of the technical details. Since it will soon be one year since I started the project, I think I will do some before school starts up again in September.

# Honey scam
I am no longer pursuing the reverse engineering and investigation of Honey. I think most of the actual "scam" code happened behind the scenes, probably some JavaScript that was executed from the request of PayPal's CDN. I spent hours looking at various pieces of network traffic, and JavaScript, and ultimately it's hard to follow the chain for so long without moving onto something else.

MegaLag has not appeared to upload about the incident since. PayPal basically played the "stall for time and let it slip over" game, which they won, but Honey's days of being the YouTube sponsor are over.

Honestly, I think the entire idea of sponsorships and advertisements have turned upside down. I never used Honey to purchase anything, because I did not have a credit card when I was 12. I grew up with ads already existing, and being a "barrier" to accessing the content you wish. Since this happened, more people have realized this, and I'm surprised that this wasn't what everyone else was thinking? You should not feel "commanded" to watch a YouTube advertisement. But I have been working on my social and personal life more, so I have not been watching YouTube channels that need to rely on sponsored segments to keep them afloat. I could be out of the ring, but I personally am not affected by this anymore.

The suspicion for digital products - or really all kinds of products - have risen. Honey played a part in that, and as the EU initiative for Stop Killing Games gets discussed in Parliament (great job everyone), we will see what happens. There needs to be a fix in the disconnect between corporations trying to actually appeal to customers while being morally correct. Currently, that is impossible, and it probably always will be, but everyone is just more aware of it now more than ever.

Of course - and hear me out for this - if companies did things people actually liked, people would buy their products. If Nintendo made their hardware less bland and started selling colored skins of Joy-Con 2s, people would buy that.

Anyways, point is, I won't be investigating it further.

# LEGO Island
I again will eventually, as I see fit, talk about this more. The 3DS port is complete, but there are some crashes and weird things that happen. The game is actually not as lightweight as it could ideally be; in terms of hardware requirements, the game is more resource hungry than Diablo. It doesn't help that while the game is small in size, the scripts make it enormous, and all that data has to be loaded.

There is one thing in particular I looked at that is worth mentioning. I was thinking of the idea, since LEGO Island can basically run in any frontend (thanks to the ISLE vs. LEGO1 split), that with Java bindings, could basically be running inside of Minecraft. Not playing it in game, or a recreation of the world with a data pack and server plugin; running the game inside of a dialog box.

This is actually harder than it sounds, as I would find out. Minecraft uses LWJGL, which only in recent Snapshots has support for bindings to SDL. But technically it is more ideal for the game to use GLFW instead. Then the game has to be drawn to the dialog box. Although I know a decent amount of knowledge on how Minecraft works under the hood, I am not great when it comes to client-sided GUI, and graphics, and window application libraries.

In the meantime, I made a WIP `ISLE` replacement in Java. It is incomplete, and I'm currently leaving it there, since my method of working with JNI may not have been the best, but the game creates a window and loads. No mouse input works though, so the game is unplayable.

# Other tech stuff
There are a few ideas I have... but they will have to wait, since I don't want anyone stealing my thunder on something I can do but have been putting off :)