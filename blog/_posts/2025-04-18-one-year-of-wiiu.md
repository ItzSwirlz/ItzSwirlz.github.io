---
layout: post
title: "One year of having a Wii U: Reflections"
date: 2025-04-18 17:24:48 -0400
categories: wiiu
---

One year ago today, I picked up a Wii U from a used game store. I would say that it has benefitted me a lot.

This isn't really a technical explanation, I just wanted to reflect on what the experience was like and the things I've done since I've had this console. No images, I just want to talk. Unless I decide to put in images. So for now, just text.

# First impressions
It was in pretty good condition, certainly used, but probably someone who let it go because they didn't like the game library, or because of the time I had picked it up, online services had shut down.

Since the Wii U homebrew scene started thriving at this point, and with Pretendo Network coming around, I thought it would be worth it. I've always wanted a Wii U anyways.

It's a Wii U Deluxe Set, came with everything but the console dock holders (for vertical mounting), the HDMI cable, and the GamePad stand (not the charging dock). It had the GamePad which was the most important thing. That does mean it's a Hynix NAND chip, but I later installed ISFShax for when it dies.

So once I got it (it came with the system already formatted), my first order of operation was Wii to Wii U Transfer. Obviously, because I love the Pikmin animation.

# Wii to Wii U Transfer
Now, not many people (as far as I know) have done this, especially on a console where the **source console is modded and the destination is not**. I can gladly say I did it. I spent the week prior backing up *everything* - the NAND, game saves, channels, etc. Then I had to move all the Miis in the Mii Parade into the Mii Plaza because for some reason Nintendo didn't put that in the vWii? (Wii U/vWii nerds: This is probably an easy fix, maybe we just need to replace the Mii Channel WAD?). Once that was done, I got the files set up. I used the Wii Shop Channel to download the transfer tool, which is literally the few things you can actually "purchase" (it's free) now. The Wii Shop Channel won't let you purchase new things, but basically there are servers alive just for making it so you can download what you had before, and so people can do their Wii -> Wii U Transfers.

And the transfer went, amazingly. I have it recorded for my own satisfaction. It is truly beautiful, and unfortunately, for the Switch to Switch 2, Nintendo did not continue the tradition of system transfers having cute animations with Pikmin carrying them like in almost all the predecessors. This can be attributed to the fact that you can literally just move the SD card over, and now internet speeds and cloud services make it very easy to move data over. So it would be overkill technically for Nintendo to develop a whole animation.

I was going to do it the night I got it, but actually you need to be signed into Nintendo Network to actually download the transfer files on the Wii U (vWii) side. If you want to use the vWii Wii Shop Channel you need to be signed in, even for this. I don't know what files they were, honestly I should've stopped to check the SD card and see what was going on, hopefully someone else will do so (or I can find a way to redo the transfer).

This was a bit nerve wracking, even once I synced up my Nintendo account, about what could go wrong; the transfer could maybe abort if it realized the source console had non-Nintendo signed titles (the homebrew stuff didn't get transferred, so I guess Nintendo just ignored those and didn't care to do anything about it. Nowadays they wouldn't let you get away with this).

I did have a brief scare when for some reason I booted into the vWii to see that nothing appeared - which was horrifying until a quick reboot fixed that. Not sure what happened.

But once the transfer finished, the Pikmin started dancing, the bells rung and it was off to modding the Wii U.

# Modding time
This was a bit tricky because MacOS will format your SD card if its less than a certain size as FAT16 (I needed FAT32) but once I got it, things went off without a hitch.

The modding process, excluding backups, maybe took like, twenty minutes? It was the fastest console I ever modded and I enjoyed it. Thanks to the [Wii U Hacks Guide](https://wiiu.hacks.guide) team!

Then, it was off to Pretendo. I copied my Miis from the vWii to the Wii U (which you can do, I won't talk about the Mii situation, story for another time), and then I was playing Splatoon. Awesome.

# Dev projects
I think the main specialty of the Wii U is the things it inspired me to do.

## Pretendo self-hosting

To help contribute to Pretendo Network, I started [self-hosting](https://matthewl246.github.io/pretendo-docker/) and tinkered with things. I even tried making game servers for games that weren't supported yet, so the early reverse engineering and listing of "which network protocols do we need", could be a big help in the future.

This was my first time interacting with Go for the use of networking, and also the first time I used SQL. Specifically, Pretendo uses Postgres for it's game servers, and the account database and Juxtaposition (Miiverse) data is stored in MongoDB. In my first trimester coming back into school, I took the SQL elective - so now, because of Pretendo and a Wii U, I have learned about databases. Fun!

I was able to figure out why certain bugs were happening, test updating servers to new library versions, and even submit a full pull requests that got merged. I hope to continue doing this. Thanks again to the entire [Pretendo Network](https://github.com/PretendoNetwork) team!

## Thred List (typo intentional)
On the 3DS, the Luma3DS Custom Firmware has a way to view the current process list. I wanted to make something similar. Cafe OS technically has very few processes - so it became the "thread viewer plugin". With the help of Maschell, once you locate the main OS thread, it's just a linked list.

This provides very cool information - I even tested stopping threads while they were in the process of running and got some weird things to happen, like the Wii U Menu never loading to your Mii but instead just having the music continue while all you see is the top icons spinning, which was fun. In certain games, you can now see what threads are running, and some people have found cool discoveries, like, if I remember correctly, The Legend of Zelda: Wind Waker HD port still has threads running for handling physical memory cards (source: Imora).

The reason it is called "Thred List" is because there is one thread is actually called "EulaThred". I'm not making that up. The developers have a typo. My theory is that the devs were so focused on warning people against console modding they forgot to proofread their thread names.

Thred List is available on the Homebrew App Store as an Aroma plugin - [try it out for yourself!](https://hb-app.store/wiiu/ThredList)

## Ristretto
I know I said I would make more Ristretto blog posts (and I hope to), but I don't think I need to explain how it has benefitted me. I will say though, it has made me find my interest in IoT - and I have probably wasted hours of my life trying to get the console to turn off from a powered state. Even just doing that deserves an article in itself (I still have not found a solution other than using a Fingerbot to automatically press the power button on the console).

So, stay tuned for updates. [Home Assistant integration](https://github.com/ItzSwirlz/ha-wiiu) is coming along well, thanks to [pantherale0](pantherale0)!

## And probably more, but I've forgotten. If I remember, I'll put it in here.
There is another project I am helping organize, but it is still in the works.

# Conclusion
So yeah, the past year showed having a Wii U is great - specifically when its modded. But it has encouraged me to learn a lot, and I am deeply glad that I have one.