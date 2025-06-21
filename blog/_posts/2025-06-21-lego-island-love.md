---
layout: post
title: LEGO Island Love - Decompiling and porting a 1997 video game with the best people ever
date: 2025-06-21 11:03:23 -0400
categories: legoisland decompilation porting reverse-engineering
---
For almost two years now, as a side project, I've taken on contributing to the LEGO Island decompilation and now, the porting project.

I want to of course, share my experiences, but also show how this game that came out a decade before I was born taught my reverse engineering and opened the door to lots of fun opportunities.

<img src="/blog/assets/legoisland3dsyay.png">

# What the brick is LEGO Island?
LEGO Island (1997) is a PC video game made for Windows 9x. It is one of the earliest games to feature a 3D world, and was *very* ambitious for the time period.

For people who grew up with the game, it is the nostalgia that gets to them. The game is not super challenging (except the final Brickster battle, which is surprisingly difficult), and by today's standards can be considered a lame game. But at the time, for young children, this game let you experience being in a virtual island that you could control and explore.

So although I did not grow up playing it, when I found about the game and saw how interesting it was from a technical perspective, I grew a sweet spot for it.

# MattKC, briefly
[MattKC](https://www.youtube.com/c/MattKC) is a YouTube content creator on a variety of topics; hardware, software, hacking, gaming, etc. He was actually the first person that I heard about the game.

Over the years, he has done cool stuff, like [replace the music](https://youtu.be/uP328LYl8eo?si=hc5BZuPJv65g53lo) in the game and patch the [turn speed](https://youtu.be/2CmqbccCqI0?si=02qbG4ERuoL9wc-9) issues on newer hardware. He even tracked down the [Japanese version](https://youtu.be/3Bv19Aub3sA?si=bqscdQCjT4GWmPFf) of the game.

He is the one who started the decompilation project, and I will get to it, but he is basically the one who inspired everyone in the decompilation and porting project to get going. He put out the "call for help" and had people respond.

I did visit, in the interest of "wow! I can work with a YouTuber!" but eventually I actually became devoted to getting this game to be decompiled and work on other platforms.

# Why was LEGO Island decompiled?
1) The game faced major challenges as a result of the hardware. For example, video, animation and sound assets were all [streamed in a proprietary format](https://www.legoisland.org/wiki/Interleaf_File) that would allow the game to run without long loading times from the old CDs of the day.
2) This game has issues on modern versions of Windows. Aside from the game trying to run at 640x480, there are various bugs, aside from the turn speed not being tied to the frame delta (video and explanation linked above), crashing when Alt-Tab'ing, crashing on exit, etc. Although [LEGO Island Rebuilder](https://github.com/isledecomp/LEGOIslandRebuilder) exists and can patch these issues, there's still a lot of interesting things to look at.
3) LEGO Island was not a game that was quickly hacked together. The game had lots of love put into it, and you can tell; from the voice acting, to the goofy animations, and the dialogue used, and from the stories the developers and artists have told in MattKC's recent [documentary](https://youtu.be/bG55COe_f8I?si=dldYgiwJ97ca7-lO) show how special it is.

June 2023, Matt announced he had started [decompiling LEGO Island](https://youtu.be/MToTEqoVv3I?si=t2YvD9jOUuM9J_7K). Not his first attempt, but he managed to start making progress.

And from there, things went super rapidly. This is where the technical explanation begins, so if you are not a technical person, thank you for reading.

# What made the decompilation a success
Again, Matt's videos can tell you a lot (see the "[So we FINISHED decompiling LEGO Island](https://youtu.be/gthm-0Av93Q?si=e0xiLOMtdOj3GQea)" video) but:
1) The game had a frontend and a backend. The window was all done through `ISLE.EXE`, and the game code lied in `LEGO1.DLL`. This meant some function names were exported to have  `ISLE.EXE` start the game.
2) The class names and code organization. Every single class has a "ClassName" and "IsA" function, which do what they say. This made it easy to identify which function belonged to which class and we could track inheritance through [vtables](https://en.wikipedia.org/wiki/Virtual_method_table).
3) A group of dedicated people. Aside from MattKC and his other modding partner in crime, Ramen2X, we got various people to help with all kinds of aspects. `foxtacles` was able to work pretty much all the time to make progress. `disinvite` helped improve [reccmp](https://github.com/isledecomp/reccmp), our method of comparing the byte accuracy of the code. There are many other people, which I'll list in the end.
4) The resources and dedication. Matt setup a Ghidra server for us to work on. He and foxtacles had write access, but even having read-only access was. enough to get going locally.
5) This was actually super fun, and the progress was RAPID.

Matt did not expect the decompilation to really go super far, given how big LEGO1 is. But six months later, we got the window to open, and the `NOCD` animation (the famous "Whoops, you have to put the CD in your computer!") to show.

One month later, `MishaProductions` had figured out how the Information Center code worked. And since the code base is beautiful and abstract, thats basically how a lot of the other worlds worked.

Around late 2024, the game was fully decompiled (with a bunch of exceptions, see Matt's video on finishing the decompilation for more details because Microsoft Visual C++ 4.20 is one of the worst compilers ever made by man kind) and attention moved to porting it.

# What I did
All the background is necessary, believe me.

Although I did not do as much as others, I still contributed a decent amount to the decompilation. You can see all the commits [here](https://github.com/isledecomp/isle/commits?author=ItzSwirlz).

So I'll run through them:

- Small function match in the game engine's Timer class. This was the first time I had ever contributed to a decompilation! It made me learn how to use Ghidra, and soon enough I was renaming, retyping, and off to further work.
- The game engine's Bitmap and Palette classes
- The game engine's abstraction class for Entity
- Constructors and class fields for some streaming classes, actors
- Various other easy functions to start with, such as the internal game engine's various Presenters, Managers, and Controllers, which all had similar layouts: initialize fields in constructor, register to the Tickle or Notification manager, when destructing, unregister, etc. These were the easy parts, but they were very fun. (Yay for code abstraction!)
- Across a lot of classes, just filling out the vtables, figuring out which are overrides and which aren't, implementing the quick `IsA` and `ClassName` functions
- Eventually, more advanced things: Game states in the Hospital and Police Station, click handling notification functions, history book

Overall, if I had to sum it up: Primarily in the areas of actors, managers, controllers, basically the very high level stuff. I didn't do the real nitty gritty, chunky things, but the code abstraction made each function relatively easy to work with (for the most part). One by one, everything came together and that progress bar shot up. This really helped motivate more decompilation.

The low level stuff... believe me when I say foxtacles is amazing. Read his [blog](https://blaubart.com/blog/the-decompilation-of-lego-island). He did SO MUCH. Lots of the challenging code. He is just incredible. He not only did so much for the project, but he also helped me with any lose hanging fruit that I couldn't match. While I made 7,485 new lines, he made 200,245.

The last function I decompiled was one of the final [display surface functions](https://github.com/isledecomp/isle/commit/48c327ca5a0f06cdd3182b24938195f60e4a8f9c). A nice thing about decompiling is that you do not necessarily need to always know what the code does (though if you do, it helps), as long as you can take Ghidra's pseudocode and turn it into actual code you will get somewhere.

Going through the messages in the Matrix chat, the collaboration was beautiful. I know I am posting things from the chat room, and they are old, but looking back makes me smile. This nearly 30 year old game brought us all together, people from different backgrounds and areas of expertise.
<img src="/blog/assets/legoislandcollaboration1.png">

Here is some debugging that lead to a function match when we got the game window to open:
<img src="/blog/assets/legoislandcollaboration2.png">



# Honorable function mentions
## PoliceState constructor
Here is Ghidra's pseudocode:
```

PoliceState * __thiscall PoliceState::PoliceState(PoliceState *this)

{
  uint uVar1;
  uint uVar2;
  void *local_10;
  undefined *puStack_c;
  undefined4 local_8;
  
  local_8 = 0xffffffff;
  puStack_c = &LAB_1005e840;
  local_10 = ExceptionList;
  ExceptionList = &local_10;
  MxCore::MxCore((MxCore *)this);
  local_8 = 1;
  (this->base).base.vtable = &LegoState::VTABLE;
  this->field5_0xc = 0;
  (this->base).base.vtable = &VTABLE_PoliceState;
  uVar1 = _rand();
  uVar2 = (int)uVar1 >> 0x1f;
  ExceptionList = local_10;
  *(uint *)&this->field_0x8 = (((uVar1 ^ uVar2) - uVar2 & 1 ^ uVar2) == uVar2) + 500;
  return this;
}
```

What is going on with `field_0x8`? Me and various other people spent time dancing around this. 
<img src="/blog/assets/legoislandcollaboration3.png">

This field was randomly defined. He figured out that it was just a ternary statement. I copied the code and locally ran a test to see what values spat out. Essentially, if the number randomly generated is even, it picks 500, otherwise it picks 501.

This is what actually came out of this function:
```cpp
// FUNCTION: LEGO1 0x1005e7c0
PoliceState::PoliceState()
{
	m_state = PoliceState::e_noAnimation;
	m_policeScript = (rand() % 2 == 0) ? PoliceScript::c_nps002la_RunAnim : PoliceScript::c_nps001ni_RunAnim;
}
```

## Bitmap code
This was the first time I got myself into graphics code. I don't know how much it relates to today, it was good for me to get a basic overview of how things work.

The nice thing about the Bitmap and Palette functions is that a lot of them were just setting fields, or iterating over arrays of palette entries or color values. The [MxBitmap file](https://github.com/isledecomp/isle/blob/master/LEGO1/omni/src/video/mxbitmap.cpp) is nice, I recommend looking at it.

You will see code that looks like this quite often:
`MxLong size = AlignToFourByte(p_width) * p_height;`

I can't remember why, but often this procedure was done with some variables:
```cpp
	// Bit mask trick to round up to the nearest multiple of four.
	// Pixel data may be stored with padding.
	// https://learn.microsoft.com/en-us/windows/win32/medfound/image-stride
	// FUNCTION: BETA10 0x1002c510
	MxLong AlignToFourByte(MxLong p_value) const { return (p_value + 3) & -4; }

```

(I guess if you want to find out why, check the link.)

There are lots of commonly used procedures, and we could tell roughly (in this case, it was backed up by the leaked Beta 1.0 build) where inlining was occurring. The team took great use of inlining to make functions humanly readable. It makes the LEGO Island codebase great for dealing with.

## Palette code
Similarly to Bitmap code, the Palette code was relatively straight forward. I suggest for anyone learning reverse engineering or decompilation to look at these kinds of functions, as it gives you practice with looking at Ghidra pseudocode, figuring out which stuff is garbage and what is actually happening. This also gives you practice with reverse engineering the data structures, and turning the `do-while` loops into `for` loops.

[https://github.com/isledecomp/isle/blob/master/LEGO1/omni/src/video/mxpalette.cpp](Here is mxpalette.cpp). Looking back on it, after it's been smoothed out by others, it is a joy to read.

# Porting time
Today, Matt made a video on how [LEGO Island is officially portable.](https://youtu.be/JUNdWnI5BTk?si=mxf4Skpf7cG9Y3Yq). Watch that for the details. But that is sort of what inspired me to write this today.

I did not do any of the transitions away from Windows to SDL3 and other abstractions. The rest of the team did a great job with that.

But, I was able to help test. As [Anders Jembo](https://github.com/ajenbo), the GOAT of graphics, continued making progress, I tested the game on my M1 Mac. As progress came along, it was incredible to see things come to life. Here is the 3D world rendering on a native ARM Mac:
<img src="/blog/assets/legoisland3dtest.png">

And here is how broken it was when Anders was working on full screen:
<img src="/blog/assets/legoislandfullscreentest.png">
I also tested it on my father's M4 MacBook Pro. Sure enough, things worked!

As Matt mentioned in the video, foxtacles made the game [run in a web browser](https://isle.pizza). Very early into the decompilation, he had expressed this idea:

<img src="/blog/assets/foxtaclesquote.png">
Just check out `isle.pizza`. Let the glory speak for itself.

## 3DS Porting Begins
A few days ago, since SDL3 has been [known to work on the 3DS](https://wiki.libsdl.org/SDL3/SupportedPlatforms), I gave a go at it myself.

There were some hiccups, and currently the port is *far* from done. But even just a few hours into it, I was able to get results:

<img src="/blog/assets/legoisland3dsfirsttime.png">

The most annoying part is probably dealing with putting the game assets on the SD card..

I will probably save all my yapping for the 3DS port when it is actually finished. Anders said he might help with a [citro3d](https://github.com/devkitPro/citro3d) backend which would make the game progress quickly. Current struggles are screen resolution, and surprisingly, some lag when streaming some of the data. The Infomaniac's speech is quite a bit glitched out at some points, possibly due to the logging calls I put in. Additionally, dealing with the FLC's cause the console to crash, so as of writing, it is disabled.

The port is still a massive work in progress ([PR #315](https://github.com/isledecomp/isle-portable/pull/315)), but I can't wait to see where it goes. The PR may look a bit small, but that's because the changes I made were put into the main branch, so I just rebased.

There is still lots to do, but I PROMISE when the port is finished I will make a blog post detailing its journey. (And I promise I will make those Ristretto blogs.)

# Thank you
There are so many people this entire thing would not have been possible without.

- [MattKC](https://github.com/itsmattkc) - his content, showing me LEGO Island, inspiring me to decompile
- [Ramen2X](https://github.com/ramen2x) - his work on LEGO Island Rebuilder, decompilation and porting on ARM Mac platforms
- [Christian Semmler (foxtacles)](https://github.com/foxtacles) - literally everything. His dedication to the project, fixing of my incomplete matches, the lessons he has taught me, and for his work on the Emscripten port (isle.pizza)
- [Mikhail Tyukin (MishaProductions)](https://github.com/mishaproductions) - Helping with the decompilation a lot, especially in the debugging and Information Center
- [Nathan M Gilbert (Tahg)](https://github.com/tahg) - For cracking that PoliceState constructor, and also helping with the decompilation
- [disinvite](https://github.com/disinvite) - his work on the byte comparison tool and the decomp
- [madebr](https://github.com/madebr) - his work on the decomp and porting
- [Anders Jenbo (AJenbo)](https://github.com/AJenbo) - from saving the porting project from nearly falling apart due to D3DRM, for making the graphics backends, bringing his experience from Diablo ([DevilutionX](https://github.com/diasurgical/DevilutionX)) to incredible use
- Anyone else who has been in the LEGO Island Decompilation chat room, or has reviewed my PR's or been there at any point in this journey. You are all amazing.