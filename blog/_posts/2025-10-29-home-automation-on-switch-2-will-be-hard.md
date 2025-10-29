---
layout: post
title: Without Custom Firmware, home automation for the Switch 2 will be hard (or at least, less satisfying)
date: 2025-10-29 09:26:18 -0400
categories: switch2 iot
---

*TL;DR: Home automation for the Switch 2, or any unmodded Switch, will be hard, and the solutions may not be as satisfying.*


The perfect home automation setup for the Switch 2 is near impossible.

Yes, I am saying this with confidence. Home Automation with your Switch 2, or any Switch that does not have custom firmware, will be difficult, complex, and frustrating.

Technically, having custom firmware should not even be a requirement. It is the ideal solution, but even the solutions around that have lots of caveats.

**It is possible**, but it is a question of how you want to make your setup work, and as with all smart home technology setups, how much time you want to put into it. There is no one-size-fits-all solution.

# Background
Last year, I opened the door to [smart home integration](https://jpeisach.github.io/blog/wiiu/ristretto/iot/homekit/2024/09/24/the-start-of-wiiu-home-automation.html) for the Wii U. This used custom firmware to run a HTTP server that would respond to requests given over the local network. There are limitations to this, that do have solutions (which I plan to discuss in other blog posts eventually), but for the most part, it works.

The next course of action was: What about other consoles? I do have an answer, actually, for the Wii, and some other 7th console generation devices. In good news, 8th console generation devices should all be capable of this. Again, this is a story for another time.

The newest console I bought, was a Switch 2. Now, I never bought a Switch. So this meant that I could experience Switch games now, and ideally, I was hoping hat eventually, there would be a day, where I could also seamlessly integrate the Switch 2 with my Home Assistant instance, and do all kinds of cool stuff with it.

That day does exist, but it will not be as easy. The Switch 2 is an entirely different story when it comes to being able to recreate what I did for the Wii U.

# The problem with the Switch 2 (and unmodded Switches)

Remember how i said custom firmware is the ideal solution?

After the security failures Wii U and 3DS, Nintendo learned their lesson.

No, really, they did. The Switch operating system, Horizon OS, is one of the most polished and secure systems that one will ever see. The developers have run all kinds of sanitization checks, applied practices, and the chance of an OS exploit is **extremely, extremely low**. We're talking odds of how long it took for the [Xbox 360 softmod](https://github.com/grimdoomer/Xbox360BadUpdate) to be found, and even worse.

So how come modded Switch's exist? It's not even Nintendo's fault. It's NVIDIA. Unless you have your Switch on an ancient OS version, where some kernel exploit has not been patched yet and you manage to use it, your choice is attacking the hardware. And that is exactly what Switch modding is.

I won't go into details, especially since I have little knowledge about how these work, but the original Switch model has a buffer overflow in the console's SoC boot ROM. Using this, you can use a device to upload code, and gain ACE that way.

This was patched, and in other Switch models, this is not doable. But modchips exist, using voltage glitching. These are still difficult to pull off, but it is possible.

The Switch 2 security, on the other hand, is [almost an unbreakable wall](https://jpeisach.github.io/blog/switch2/homebrew/2025/06/07/thoughts-on-nvidia-security.html). Currently, the Switch 2 is unhackable, and it will likely stay that way for at least 5-10 years. The Switch 2 board has protections against voltage glitching, and now has a separate security controller that (as far as we are to believe), make all kinds of CPU glitching impossible.

There is still room for some hope, in my opinion. Currently, I think that currently nobody is really trying anything? I have not seen proof of anybody doing this, and the people in charge are basically making fun of people who think that the Switch 2 is still hackable in some way. While I can believe that a software exploit is likely impossible, the belief that a hardware exploit cannot exist is something I personally find weird. Because currently, it looks like, *"Well, there is this new chip! And the CPU runs in [lockstep](https://en.wikipedia.org/wiki/Lockstep_(computing))! It's game over!"*. And yes, you do need to use that security chip to even get the console to boot, but there **has** to be some signal that is sent saying "Continue with boot!" that can be replicated.

This is the only place I can even safely debate this topic, because the server about Switch homebrew and development will ridicule you for talking about it. The consensus being pushed is "the console has perfect security", which is a very rare, if not impossible thing to happen, and I [am not the only person](https://www.reddit.com/r/switch2hacks/comments/1nvnb3q/comment/nh9vysr/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button) who has thought about this, who believes that the console is hackable, just not with current technology.

So, without CFW, how else do we control the console?

It turns out, there is, kind of, an answer.

# Pokemon Automation

The [Pokemon Automation](https://pokemonautomation.github.io) project has actually been able to control their consoles. They use something like an ESP32 to act as a controller, and a capture card for a PC to view the current game state. Then you can use scripts to shiny hunt, or do whatever the Pokemon Automation people do.

The exciting part is that, this technically works. In theory, using [nxapi](https://github.com/samuelthomas2774/nxapi), we can see what games are currently being played. Then, we can program a definition of what the home menu looks like, and using the ESP32, we tell it to launch another game.

Pokemon Automation was how I found out there was lots of work done with ESP32's and using them as Switch controllers.

# The ESP32 strategy
Let's first assume the console is on (now that the console has Bluetooth Wake on LAN this *hopefully* should not be a concern). To launch a game in the Horizon OS menu, you pick from the carousel-like view, and press A. Most games will have you select which user is playing, so if necessary, that can be adjusted. Some games, like Nintendo Switch Sports, do not rely on account-specific saves and will launch the game. If there is a suspended title, the software has to be closed (press A again).

Now, when you launch a game, that game actually goes **to the front of the game list**. That is why being able to know the gameplay history is important; it can help us infer the current menu layout and determine which button combination is needed to launch a game. If not, there is an "all games" menu if you scroll all the way to the right, which I think should also make it possible, from a list of games, to figure out the button sequence.

<center><image src="https://upload.wikimedia.org/wikipedia/en/3/34/Nintendo_Switch_Menu_screenshot.png"></image></center>


Yay! Of course, you can't directly switch to titles or applications, and there are **lots** of caveats and situations where an automation will not work.

Last night, I actually tried using the ESP32 to work as a controller. In 40 minutes, I was already making great results, thanks to an already existing Arduino library for making [Switch-compatible ESP32 devices](https://github.com/esp32beans/switch_ESP32) and a web server library called [ESPAsyncWebServer](https://github.com/ESP32Async/ESPAsyncWebServer).

```c
#include "switch_ESP32.h"

#include <ESPAsyncWebServer.h>
#include <WiFi.h>

static AsyncWebServer server(80);

static uint8_t button = -1;
NSGamepad Gamepad;

void setup() {
	Gamepad.begin();
	USB.begin();  

	WiFi.mode(WIFI_STA);
	WiFi.begin("my-wifi-network", "my-wifi-network-password");

	while(WiFi.status() != WL_CONNECTED){
		Serial.print(".");
		delay(100);
	}

	server.on("/a", HTTP_POST, [](AsyncWebServerRequest *request) {
		button = NSButton_A;
		request->send(200, "text/plain", "Done - A!");
		return request;
	});

	server.on("/b", HTTP_POST, [](AsyncWebServerRequest *request) {
		button = NSButton_B;
		request->send(200, "text/plain", "Done - B");
		return request;
	});

	server.on("/home", HTTP_POST, [](AsyncWebServerRequest *request) {
		button = NSButton_Home;
		request->send(200, "text/plain", "Done - Home");
		return request;
	});

	server.begin();
}

void loop() {
	if(button != -1) {
		Gamepad.releaseAll();
		Gamepad.press(button);

		button = -1;
	}

	Gamepad.loop();

	delay(100);
}
```

And we were off!

No we weren't.

# The Big Problem
The way I had this tested was by having my regular Joy-Cons connected as "Player One", and the ESP32 was connected as "Player Two".

Now, in the Horizon OS menu, all controller inputs are listened to. But in Pokemon Violet, Animal Crossing: New Horizons, Pokemon HOME, and probably **many** other games, the input did nothing.

As a matter of fact, I couldn't switch out of those games. The home button did nothing.

Sure enough, I confirmed with Splatoon 3 and Mario Kart World that, **each game chooses how to handle other controllers individually**. Pokemon Violet and AC:NH are **entirely singleplayer games**. Therefore...

<h3>THEY WILL ONLY LISTEN TO THE CONTROLLER CONNECTED TO PLAYER ONE!</h3>

This is the big takeaway of the entire blog post. If you have another controller connected, **you cannot switch out of these games** because **the game will ignore the controller**. In our case, this means that **the game will ignore the ESP32**. 

This is the main problem. As far as I know, you cannot magically disconnect another controller. You would have to ensure that the ESP32 is Player One. But, since the games only listen to input by Player One, this means **you have to play the game from the ESP32**, which in this purpose, is not what it is meant for. The ESP32 is meant for sending commands on request; not replicating an entire controller.

Splatoon 3 handles controller requests differently. It actually will prompt the controller selection menu, in which from there, you could tell the ESP32 to identify itself, confirm, and reach the home menu that way.

Mario Kart World, in my brief testing, on the screen that says "Press any button to start", seems to listen to the home button from either controller.

For Pokemon Automation, this is not an issue, because the ESP32 is the only controller active. A human does not need to interact with it, that is the point. So no other controllers have to be connected. This just impacts us.

Cool.

# The Options
Well, you can't just give up a controller. This means that you can only switch out of a certain number of applications.

## Option One: You get what you get and you don't get upset.
Only for the games that will listen to the other controllers, can you switch out. Special handling will need to be done for games like Splatoon 3 where extra input may be needed to switch out. But for the most part, you won't get anything.

## Option Two: Make the ESP32 your primary controller
I don't think I need to explain how this is problematic. You sit in front of your control panel, whether that is Home Assistant, or whatever, that will, on button press, send a HTTP request, from your computer, to your router, to your ESP32, to then execute the button you want to press, and hope that the *latency* will not be annoying. Also, you can't use games that rely on the joystick.

## Option Three: You manually switch out for the automation
Sure, I guess?

This in some ways, defeats the purpose of the automation. If a game is active, you would have to go to the home menu for the automation to work. So if you were hoping on using a voice assistant and telling it, "Open Pokemon Legends Z-A", you would need to be sitting with the controller in your hands anyways, just to get to the home menu and then let the automation navigate and find the game for you. Which, uh, fine? But it is not as satisfying. In that time you might as well switch games yourself. And if you leave the game active while you are away, then your remote control attempt to switch games won't be helpful.

So, if you plan on having your console generally on, and you step away and want to switch applications, you can't just hang out in Splatsville and leave your TV on so you can vibe to the music. You need to get in the habit of leaving your game on the home menu when you are not using it.

Technically, that is not too difficult, especially since the actual use cases where you want to switch titles will really only be handy if you are not in front of your console anyways to switch titles. And unlike the Wii U, switching titles is actually easy, because the menu is so lightweight it is fast. On a Switch 2, you basically can instantly rendezvous into the home menu and out of it. No music though, and the home menu is still lifeless, but whatever.

Still, you can't have that nice satisfying proof of concept where you save your Pokemon game, and click a button on your computer to switch to Pokemon Home without any user interaction.

I actually only thought of this as I was typing this blog post, I was initially going to go on about option five, which I will mention.

## Option Four: Use a game cart switcher
Suggested by PB&J from Nintendo Homebrew discord.

<img src="/blog/assets/switchcarts.png">

Unfortunately for me, I actually bought digital games, because I was running on the train of hoping that automation would come some day, and since I did not think these devices existed (I thought it would have to be built by hand and it would be hard to do), I thought digital would be easiest.

So... this works too? If you save your game? By forcibly **crashing it by taking the cartridge out of the console** just to get into the home menu and then relaunching your newly inserted game that way.

I guess you could use this in combination with digital games, where you define which games you want to switch to are digital or not - but again, this is programming each game individually.

## Option Five: Custom controller
This was actually what I was going to make the blog post be about - how home automation would require using a custom built controller, that would also have a WiFi server or method of contacting it to tell it to execute a specific button press when needed.

This would be **hard**. Not only making the controller itself, with just basic buttons, but ideally being a wireless controller, having gyroscope, include joysticks (while you are at it, figure out those hall effect joysticks), and somehow, in the controller's tiny program space, be able to also squeeze in a web server or whatever method of communication is needed to override all input and send a certain signal.

So actually, this is the best solution, second to custom firmware. You will have to build your own controller.

And I did some researching on how other people have made their own controllers, and I am not a hardware engineer, so I have very limited experience with this sort of thing.

Although controller libraries exist, you then still need to make a board, and 3D print shells, and somehow be able to even keep the controller on (battery powered?) to even make it worth switching.

In that vein, why even bother.

# The valley of despair
There is no one good solution. They are each problematic in their own ways, and require DIY skills that may not be beginner friendly.

CFW is not coming to the Switch 2 anytime soon. And for newer Switch models, modchipping is difficult and can damage your console.

Nintendo is probably not going to do what Microsoft or Sony did, where they do offer methods of smart home integration. Microsoft made newer Xbox's compatible with Google Home, and the newer PlayStation's have [MQTT](https://community.home-assistant.io/t/ps5-mqtt-control-playstation-5-devices-using-mqtt/441141).

Because of Nintendo's security, I doubt this would happen. I don't think there are enough of us with enough money to try lobbying Nintendo to make it happen. We can try pressuring them - letters, news outlets, etc. But even then, the chance is still **very** low.

The Nintendo Switch Online app is apparently getting an update that requires the minimum iOS version to be iOS 16. It says that this is for a new feature, but I am raising an eyebrow because iOS 16 is the version that introduces support for connecting [Switch controllers](https://www.theverge.com/2022/6/7/23157642/apple-ios-16-nintendo-switch-pro-joy-con-controller-support). Some in the Nintendo Homebrew discord have argued that it is probably just the general iOS end of life version so that they do not have to maintain ancient phones.

# Ending note:  A beam of light
I think it is still worth setting up nxapi integration into Home Assistant, for the sake of the dashboard. And it should still be possible to power on the console. You can power off the console via HDMI-CEC; if you turn off your TV, it actually puts the Switch into sleep mode. (Switch Lite's do not apply here, but for the Switch 2 and other models it works).

Probably in 20-30 years, we will get some sort of exploit for the Switch 2, or there will be some way of making CFW possible.

With enough media pressure, and if the entire Nintendo Homebrew community rallies together with IoT enthusiasts, Nintendo could maybe open the door to smart home integration. Smart home integration is the only reason I want the Switch 2 hacked. Nintendo would be doing me a favor, because why would I need to hack the Switch 2 if I don't have a reason to? And besides, this puts Nintendo in the world of the future.

And although you still lose out on functionality, you can still have *some* control over your console, if you use it right. I only thought about Option Three while writing. This initially was going to be a blog post expressing my upset for the requirement of building a controller for home automation. But, when you consider the actual use cases, it may actually not be that bad.

For now, we continue to hope, and do our best to think outside the box.

## Ending sidenote
There is the question of making a Atmosphere (Switch CFW) module that would do what Ristretto does. I actually did try to start one, but I do not have a modded Switch, and it would take a lot of time to debug with someone else by talking to them via Discord or whatever.

I probably should still do it, though. But since the server culture of the aforementioned Switch hacking server is... not great, I will be lurking, and avoid speaking at all. (I hate to talk so badly about people behind their back, but the people in this Discord server come off as very rude, not even willing to help teach you why X idea won't work to solve Y. The NH community knows which server I am referring to, and unfortunately, it is not going away anytime soon, because the people in charge are the most technically knowledgable when it comes to Switch hacking. Curiosity almost feels unwelcome here. Moderators of that server: I am sorry. But given the "server culture" you want to enforce, I think I have the right to express my opinion in saying that your server should be avoided. It does not hurt to be kind or to help people understand concepts. Do better.)