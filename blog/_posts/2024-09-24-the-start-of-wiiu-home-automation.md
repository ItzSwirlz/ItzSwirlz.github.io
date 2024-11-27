---
layout: post
title: "Ristretto: The Start of Wii U Home Automation"
date: 2024-09-24 17:19:21 -0400
categories: wiiu ristretto iot homekit
---
This past month, I have been working on something sort of crazy, but something incredibly meaningful. This project is a testament to:
- Understanding the Wii U, both hardware and software
- Showing a usage of Custom Firmware (CFW)
- Pointing me towards the field of technology I want to be in
- **The Homebrew Community's efforts to make the Wii U the console it should have been.**

Now given how much of an... "accident" critics call the Wii U, you may not have heard of it. You also may not have heard of the term "home automation". Even if you know what these are, I'm going to be using terms that require a fair amount of understanding So here is a quick explanation:

# Background - The Wii U, if you're unfamiliar
After the success of the Wii, Nintendo made the Wii U. By all means, this should have been the **best console ever to hit the gaming console market**. Full backwards compatibility with the Wii, it built on top of the pre-existing control system, and added so much more.

You know how the switch feels very.. boring? No menu music or anything? Just, plain and.. *existing*? If the Switch was your first Nintendo console and you have not seen the Wii U, you will be surprised at how much beauty Nintendo put into it. Before the failure of the Wii U and Nintendo (at least I think they did so,) quickly pump out the Switch to make up for their list revenue due to the [horrible marketing campaign](https://www.youtube.com/watch?v=q7_QP8Uzmls). Same for the 3DS. The eighth generation of video game consoles for Nintendo was by all means, excluding the Switch, the best of Nintendo. If you don't believe me, ask literally anybody who has had a Wii U or a 3DS. I won't keep praising the consoles for how it was life-changing and allowed for people of a newer generation to play games from an older generation.

But if you want to know what *really* convinced me to get a Wii U, aside from being able to contribute to [Pretendo](https://pretendo.network), and the amount of games that were released on the Wii U that I personally am interested in playing, and the overall experience of having a console instead of an emulator, see the Wii U Menu - *Wara Wara Plaza*. [Here](https://www.youtube.com/watch?v=szhJ6n6ToT4) is a video of it in 2022 (with Pretendo). Unfortunately a lot of what makes it great relied on Miiverse, which Nintendo killed, but Pretendo revives it with Juxtaposition. If you're interested in how Pretendo is reviving the network services for the Wii U, check out their website and community.

Wii U Homebrew History is irrelevant to the rest of this blog, which I've already written 480 words talking background. There were a lot of issues with the Wii U from the user end too - personally I got used to them, but for some people it was frustrating. A few years ago, developer of the "Aroma" CFW [Maschell](https://github.com/Maschell) discovered an exploit called [FailST](https://maschell.github.io/homebrew/2020/12/02/failst.html) and ever since, tons of plugins and patches and tools alike have helped tie up the lose ends of the Wii U, making it the great console it was born to be.

Since Aroma allows for custom code to run in the background of the console as usual, by function hooking, patching, and kernel modules (it's complicated, not even I fully understand it), there is a lot that is possible.

# Home Automation
TL;DR: [Here's the Wikipedia article](https://en.wikipedia.org/wiki/Home_automation)

If you have:
- A Smart TV (Google, Samsung, Roku, Fire TV, etc.)
- An Apple TV or Apple HomePod
- A Google Home or Nest device
- An Amazon Alexa device
- An electronic appliance in your house that does not really need WiFi connectivity but does anyways and it was made in the last 10-15 years.
Then **congratulations**! You are able to use an emerging technology that it feels like absolutely nobody cares about.

Home Automation is the idea of.. well, automating devices and electronics in your house. For example, being able to say with your voice in the living room, *"Hey Google, turn on the TV"*, or *"Hey Google, turn on the lights"*, or even making it so whenever you come home the lights in your room turn on for you automatically. Without having to do anything. That is home automation - making it easier to use and control devices through the [Internet of Things](https://en.wikipedia.org/wiki/Internet_of_things).

Now, not all devices cooperate together nicely. Most smart home devices support Alexa, followed by Google, and only like, less than 1000 devices are made with Apple HomeKit support. This is where you can use something like [Home Assistant](https://www.home-assistant.io) to basically setup a way to view and monitor and control all your devices, or use [Homebridge](https://homebridge.io) which makes it possible to control non-HomeKit devices in the 'Home' app on Apple devices.

# So what?
Well, I realized that since the PlayStation 4 and Xbox have integrations on Home Assistant, (the Xbox actually can work with Google Home) I thought the Wii U should have one too.
The Wii U is incredibly valuable because of its possibilities on a modded console and its crazy backwards compatibility - you can play almost every single Nintendo game prior to the Switch. Since I had gone through the effort of setting up a local Homebridge server and hooking up everything, I knew that with Aroma something like this is possible, allowing for devices to communicate across the network. And that was when I got myself into what I dedicated the next month (and counting) of my free time to.

# Introducing: Ristretto
<center><img src="/assets/ristretto.png"></center>

Ristretto is an Aroma plugin which is meant to enable home automation on your console. It basically runs an HTTP server (if you don't know what that is, just think of it as a way that lets devices over the same network send requests to the Wii U). Whenever requested, at any point in time where the console is running, the custom firmware and plugin server are active, you can, from your computer or electronic device you are reading this on (unless you printed this page out or downloaded it):
- Get the console's hardware information
- Power off the console (don't worry about power on for now)
- **Launch an application!**
- And so much more.

Now that the console has a way of communicating to the rest of the network, by establishing a common base, all that is needed is to add the support for the console in whatever home automation platform. For the purpose of this blog, I will be talking about what I worked on most: making it work with Apple's HomeKit (which is basically the Home app) through Homebridge.

# Technical Explanation
If you don't want to read the technical explanation, or you just aren't get with technology, this is the time where I dismiss you from the class. However if you are curious and would like to hear how Ristretto works, I encourage you to stay with me. I promise it will be worth it.

## The Server and the Home
I chose HTTP because it's nice and simple. My main concern about this project was being able to even get an HTTP server running, because I do not know networking. However, thanks to [tinyhttp](https://github.com/kissbeni/tinyhttp) I was able to reuse a tiny C++ implementation of an HTTP server and get it running as part of the plugin.

The entire thing works by basically asking the console for something or to do something, and then waiting for its response.
<img src="/assets/ristrettoreq.png">

Now, this is how the server works - but how does HomeKit communicate to the device directly? It looks something like this: (source: linkdhome.com)
<img src="https://images.squarespace-cdn.com/content/v1/58fb28d7e3df282054f72a55/1620709696664-8X41ZMUM8L3FS2QQBO2X/HomeKit-comms.jpg">

When you tell a device to turn off, you don't directly speak to the device. You tell the cloud (which is basically Apple's servers in this case), which then identifies your Home Hub (your Apple TV or HomePod). It then asks your Home Hub to communicate to the device, and in the case of the Wii U with Homebridge, it asks Homebridge to communicate with the Wii U.

Once I got the server running, it was a matter of getting device information. With the help of some amazing people (I will give credits to everyone at the end of the post), device information was done, along with server endpoints for rebooting the console, powering it off, and getting the current running application.

Then it was a matter of the Homebridge plugin. There was a bit of a learning curve, getting it to work, not only understanding the [Homebridge API](https://developers.homebridge.io/#/) but also needing to understand how HomeKit works along with the characteristics and services and accessory and all these other terms and definitions that deserve a blog post in itself to explain. To HomeKit, the Wii U is just a [Television](https://developers.homebridge.io/#/service/Television). This is what resembles the Wii U most accurately.

## Game Switching!
I think this also could use another blog post - I want to go into further detail about everything, but here is the gist: The homebridge-wiiu plugin will ask the console for a list of applications and games in JSON format. Then, homebridge-wiiu handles this JSON and creates "Inputs" for each of these titles, along with an ID. **Believe me, I'm making this sound a lot more easier than it actually is.** But with this done, when Apple lets Siri switch the current input on Television devices *(like other assistants do... grumble grumble)*, *"Hey Siri, open Super Mario 64 on my Wii U"* becomes a thing. Through the home app, you can now switch the current game or application on your console.

## Powering On - Still a WIP..
This is currently the largest issue I have faced with this project, and by most the worst. While we can turn the console off (with Ristretto), we can't turn the console on because the power is.. well, off. Ristretto isn't running. There is no server to communicate to. Modern devices solve this issue with [Wake on LAN](https://en.wikipedia.org/wiki/Wake-on-LAN) and the Wii U does something similar for when the power button is pressed on the GamePad, waking up the console (or vice versa). However, it's obfuscated. There are lots of options, ranging from "don't power off your console" to "replace the operations of standby mode" to "just use a smart plug" to "do a hardware mod" - there are at least seven different approaches to this issue, and currently I have not found one that works... *yet.* So until then, power on won't be available. This will definitely also get its own dedicated blog post.
# Future Plans
I'm going to continue adding more to Ristretto. There are so many different enhancements that can be made, but I'm also considering adding endpoints that just grab data even if it won't even be used for a home automation. There are also so many other technologies (such as the Remote functionality) which I still have yet to talk about, but I'm cutting it here at the features released in [Ristretto v1.0](https://github.com/ItzSwirlz/Ristretto/releases/tag/1.0),which I had to release despite wanting to add more, otherwise I would never release this project. The Homebridge plugin, [homebridge-wiiu](https://github.com/ItzSwirlz/homebridge-wiiu) is also available on NPM. You can now use Ristretto - just install the Aroma plugin, setup the Homebridge plugin, and enjoy. If you don't use Apple's home ecosystem, don't worry - I am working on Google Smart Home stuff and in the future, Alexa (hopefully).

# Personal Experiences
I have not been this dedicated to a project in a **long time**. But this is something that has taught me a lot about the Wii U, both hardware and software wise. There is so much to do, and this is the type of project that can only get better and better. What I'm doing is what Nintendo couldn't - I'm sure they must have considered setting up some sort of IoT or cross-network communication. The device feels like it was made for the modern era, and there are actually function symbols suggesting it would use [HDMI-CEC](https://en.wikipedia.org/wiki/Consumer_Electronics_Control), but based on testing, the Homebrew community has concluded it never made it out of development. It doesn't work.

I have learned that I am also someone who likes to put things together. Instead of working on just one application for one platform, I enjoy being able to put everything together across a wide variety of platforms. I like piecing everything together, and it makes sense when I think about it. Minecraft modding, where I started, is just like that. Putting everything together and building on top of it.

# Conclusion
Ristretto is the start of Wii U home automation for all, and possibly an inspiration for Nintendo Switch home automation when the time comes (if possible, given how Nintendo is really securing the Switch's operating system it will most certainly be a while).

I want to thank:
- [Maschell](https://github.com/Maschell), for being what I consider, the father of Wii U homebrew. He is amazing and he has helped me in so many places along this journey.
- [Daniel K.O](https://github.com/dkosmari) for helping with the HTTP server, sockets, threading, and other technical stuff on that end.
- [TraceEntertains](https://github.com/TraceEntertains) for the "enable server" configuration option in Ristretto, helping with the HTTP server and helping research title and application information
- [Wish](https://github.com/wish13yt) - The Ristretto logo
- You - for reading all of this.

*Excelsior!*
