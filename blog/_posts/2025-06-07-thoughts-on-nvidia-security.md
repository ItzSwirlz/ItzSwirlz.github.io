---
layout: post
title: "I watched NVIDIA's security keynote - here are my thoughts on what it means for the Switch 2"
date: 2025-06-07 08:18:32 -0400
categories: switch2 homebrew
---

# For non-technical readers/TLDR:
I'll just say: if you bought two Switch 2's, one with the idea of "I'll open it when a software exploit is found and play games with the other!", you might as well return it to wherever you purchased it from or give it to a friend.

# The story
I never bought a Switch. For a while I had, and sort of still do, a grudge on the Switch because of it's rapid release after the Pokémon Alola games, and seemingly after lots of online services for the 3DS shut down. I was young, and it does not take much thought to realize that the Switch was Nintendo's rapid solution to their failure with the Wii U.

Knowing that Nintendo's security has been... bad, they stepped up. I am not an expert on the Switch's operating system, Horizon OS, but I will say with practically 100% confidence that Nintendo has patched basically everything when it comes to the Switch.

# Original Switch defense
I will not go into details, as again, I am not an expert on the Switch, but what is important to note is that **every application is sandboxed**. If you manage to hack one game, you won't get access to the rest of the system. For this reason, practically no software exploits exist. I think there is one for a really old, specific version, but it got patched. Nintendo absolutely is running security scanners and fuzzers all across the board and if a CVE in an open source library or some other small exploit is found, it is discovered by them before anyone else knows about it and is patched out.

The only reason modded systems exist is because prior to some time around 2018-2019, NVIDIA (which designed the GPU used in the Switch) messed up on the systems recovery mode that lets it run unsigned code, basically giving free boot loader and total control over the system. This was then realized and patched, and later Switch models will require a modchip. But even those are hard, as NVIDIA has made protections for modchips.

# Switch 2
Nintendo is still using Horizon OS. So software exploits are pretty much out of the way. (Yes, there is a [ROP found in the Switch compatibility library](https://bsky.app/profile/retr0.id/post/3lqtwrndzf22w) but it is useless, remember that everything is sandboxed). There is a new SoC, and NVIDIA made a [keynote](https://www.youtube.com/watch?v=7Lx3692cbAg) on how they secured it. 

Now, the most knowledgable people on the Switch have been saying the Switch 2 is unhackable. And it is naturally for others, myself included, to accept that. But I don't think that anything is perfectly secure. It took a long time but after almost two decades, an [exploit for the Xbox 360 was found](https://github.com/grimdoomer/Xbox360BadUpdate). Modchips exist, and the nature of this exploit does not give full system access, but regardless, an exploit was found.

Will the Switch 2 be hacked? Eventually, probably. Technology is improving, somewhere something will be found and then everyone can do what they want. But anytime soon? Realistically, probably not unless someone finds something truly incredible.

## NVIDIA Keynote
I recommend watching the full keynote, it's only 15 minutes, but some takeaways:
- Glitch protection
- Memory protection
- "Separation kernel" for ensuring code gets executed where it should be in the right order
- Monitors in case anything goes wrong, which will then halt the system on errors
- Encryption/decryption + intermediate calculations done with "scratchpad memory"
- Keys being stored in fuses
- Memory pointer masking

Basically, if you want to compromise the processor, you can't just compromise one area. You will need to control all the things around it and end up taking over the whole processor, each unit at a time. Most likely, a modchip would be manipulating the chip at near transistor level.

I am not amazing when it comes to modchips, I know very little about how the average one works. But realistically, hacking this is probably not going to happen for a SUPER long time.

# The good thing
Developments are still being made in the security field. Of course, for gaming consoles, that can be annoying, but lots of seriously important devices, like ATMs, need to be secured. A compromise in a high priority system would have devastating consequences.

Additionally, it shows how technology has continued to improve. I think we are approaching "perfection" when it comes to hardware security, and for devices, as someone else said on a GBATemp post, the of security measures like this is knowing that eventually, the device will be hacked, just not for another 30 years or more, in which case by then a different, more secure device exists and the older device is not as important anymore.

This has helped me just appreciate the power of the Switch 2: it is incredible for gaming (Mario Kart World is amazing), and it is doing all these calculations in the background so smoothly. All the things that happen under the hood; it's impressive.

I have to give it to NVIDIA, I think they did a great job with their new security processor.

# My take on what this means for Switch 2 hacking
Don't focus on hacking the console. It will take so long, and basically you will need to be an electrical engineer and spend so much time to actually find a glitch that would work.

If you want to "hack a Switch 2", just recreate the console with your own hardware or emulation method that doesn't have security protections, somehow flash the firmware and everything on it, and have fun. The Switch 2 hacking scene, in my opinion, should look towards understanding how the OS and new functionalities work and making progress in emulation.

Other reasons people like to hack their consoles is for things Nintendo will not offer, like home menu themes or modpacks. Modpacks can be done with emulation, but as for things like themes: This isn't like the Switch where the console probably doesn't have enough power to handle complex system themes or home menu music. There is definitely the ability to do so now. I propose we become lobbyists, and encourage Nintendo to finally do things we want, so in the end of the day, we won't want to hack our consoles. We will be happy anyways.

Take the idea of smart home integration for example: Xbox consoles have Google Home integration. The PS5 has MQTT, and people have found solutions for PS4 and PS3 (on a hacked system). Where is the media pressure on Nintendo to get up with the game? Surely Nintendo wouldn't want to lose to **competition, would they?** They don't want to seem **outdated**. Things like this is where I think we could actually leverage Nintendo into doing what we ask for, within reason. (No, they are not going to hand out free games or just let you run Linux, but if the request is reasonable, it's worth a shot).

And if you really are upset about the Switch 2 scene, even in other consoles there is much more to do. There are probably more 3DS software exploits - likely another CVE in WebKit that can be used in the browser. The Wii U modding scene is on *FIRE* right now. The Wii modding scene still has areas that can be looked at or improved upon. There are games that could be ported over - the LEGO Island decompilation team has almost fully abstracted the game *away from it's Windows and DirectX library family* towards SDL, and you can literally [play the game in a browser thanks to Emscripten (credit to foxtacles)](https://isle.pizza). Go look for some other platform to run DOOM on. I don't think anyone has ran DOOM on the Wii at the IOS (the ARM processor) level yet. Try that!

Watching the keynote made me feel better about myself and accepting that the Switch 2 will not be hacked. It will let me turn my attention to the games, which is all what we are here for anyways. There are lots of original Switch games, especially Pokémon that I cannot wait to play, and many more to come (because Nintendo knows many people can't afford the Switch 2, so they can't just discontinue the Switch 1 tomorrow. It's nearly their best selling console, after all).