---
layout: post
title: "The Ristretto Story, Part 1: A HTTP server"
date: 2025-08-30 11:46:16 -0400
categories: wiiu ristretto iot
---

Hello again!

So when I wrote my last [blog post](https://jpeisach.github.io/blog/misc/yapping/honey/honey-extension/2025/08/13/online-name-change.html), it was actually the one year anniversary of when I sent this message in the Aroma discord server.
<img src="/blog/assets/ristretto-part-1/thefirstmessage.png">
And this morning, now a few days out from school starting, as I have been thinking about what can be done for my Switch 2 (blog post for another time), I thought I should finally make that blog post I have been promising that went more in depth into how Ristretto worked.

This is the first time I had tried to ever run a web server, and utilize network sockets and threading. So this will be a bit of a story more than an actual explanation, but this is what helped me learn about these concepts, which I have never used before.
# Introduction
It is okay if you have not read [my original ](https://jpeisach.github.io/blog/wiiu/ristretto/iot/homekit/2024/09/24/the-start-of-wiiu-home-automation.html) post, though it may provide you with a bit more context than I will quickly run over.

## Terminology
- Cafe OS - The Wii U's main operating system. It runs on the Wii U's PowerPC CPU.
- PowerPC - A CPU architecture type. You are most likely reading this on either a "x86-64" (which is the general Intel and AMD computers) or an "arm"-like device, if you are on a phone, or Raspberry Pi, or new Apple computer hardware, or handhelds. PowerPC is separate from these.
- Espresso - the PowerPC CPU the Wii U uses
- Console hacking - also known as console modding or "homebrewing". This is running unsigned code on a device that the manufacturers did not originally intended for.
- Custom firmware - With a modded console, a reimplementation, or set of software patches and tweaks to improve upon the existing operating system
- HTTP - **H**yper**t**ext **T**ransfer **P**rotocol. It is what the internet used to run on, but today it primarily runs around HTTPS, a more secure version of it. Think of this as the basis for all internet communication.
- Aroma - Custom firmware designed for Cafe OS
- Aroma plugin - The best way I can describe this is basically a bunch of code that can be used for Aroma to patch Cafe OS functions or run small processes in t he background at an application level.
- Ristretto - An Aroma plugin that runs a HTTP server on the console, so other devices can interact with it via the local network

## Credits/Thanks
Thank you to everyone who helped make Ristretto possible in its early stages, which will be discussed in this post:
- Daniel K.O (dkosmari)
- Maschell
- Trace (TraceEntertains)

## Why I knew this was doable
Maschell had made a FTP (file transfer protocol) plugin for Aroma called [ftpiiu](https://github.com/wiiu-env/ftpiiu_plugin). This basically was what I am going to do, but instead of being a FTP server, it is a HTTP server. There are some places where ftpiiu does not quite work.. that is also for another blog post.

# Getting Started - tinyhttp
I initially named the project "SmartEspresso" because this project would make the Espresso... smart. In a way.

While I know what HTTP does, I have **no idea** how it works. I also have no idea about how sockets or networking in general works. So what I ended up using was "kissbeni"'s tiny C++ [HTTP server](https://github.com/kissbeni/tinyhttp) and focused on getting it to run on the Wii U.

This server also required using "zsmj2017"'s "[MiniJson](https://github.com/zsmj2017/MiniJson)" library, so I threw that in too.

All that was needed, thankfully, due to the amazing work of the devkitPro team that made [wut](https://github.com/devkitPro/wut), a toolchain specifically for Wii U development, most of the standard, general C++ functions would work out of the box.

In terms of sockets, we're thankfully covered. We can use the Cafe OS [nsysnet](https://wut.devkitpro.org/group__nsysnet.html) library, which has networking and socket definitions and structures already defined (these would be the usual `<arpa/inet.h>` and `<socket.h>` includes on a usual computer system, like Linux).

Daniel K.O helped me with getting the networking up and running. Here is basically what the plugin did initially:
```cpp
HttpServer server;

ON_APPLICATION_START() {
    initLogging();
    nn::ac::Initialize ();
    nn::ac::ConnectAsync ();
    
    server.when("/")->posted([](const HttpRequest& req) {
            return HttpResponse{200};
    });
    server.startListening(8572);

	DEBUG_FUNCTION_LINE("ON_APPLICATION_START of example_plugin!");
}
```
If you know anything about working with writing an API, this probably makes sense. But essentially,
1) Initialize the `nn::ac` library. `ac` means "Auto Connect". We need this so we can then call `ConnectAsync`, which actually connects to the network.
2) Tell the server, when we receive a `POST` request to `/`, return an empty response, code `200`, which means a usual success.
3) Now that we have defined the server's endpoints, start listening on port `8572`. Why `8572`? I didn't know if the usual ports, like `80` (which would make sense for a HTTP server) would be used by any game or application, so I wanted to use something random that *nothing* would ever touch.

I started the console and... it never moved past the splash screen. The audio kept playing, which means nothing crashed. But something was causing the plugin initialization to hang.

But, if I opened my browser and typed in the console's IP address with its port, I got this:
<img src="/blog/assets/ristretto-part-1/methodnotallowed.png">

This meant the **server was running!*** The issue here is that I told the server to expect a POST request, not a GET request, and since I had not told it what to do on a `GET` request to `/` the server just returns `405 method not allowed`. Unfortunately, the console still would not complete booting.
# Threading + Exceptions
It turns out what we needed was a **thread**.

I have never created a thread yet. I knew of them when I made the [Thred List](https://github.com/JPeisach/ThredList) plugin (not a typo), but now I had to deal with them at a concept level and actually apply their use. If you are unfamiliar with a "thread", it basically is like another code process. It essentially allows for one thing to be running at the same time another thing is running. Your browser uses threads all the time as it waits for website data to be downloaded before displaying content.

I moved all the server initialization into a new function called `make_server`. Then I just created `thready`, of type `std::thread`. I also made a function stopping the server when the current application ends.

This worked, but then something along the lines of this happened:
```
Wii U Plugin System:
   abort() called. Uncaught exception?
```

Daniel K.O **really** helped with the debugging here, and I am sure having experience with this helped him. For me, I thought the issue had to do with how I setup the server or initialized the network connections. At one point, the server just seemed to not run. But he knew that I just needed to wrap the server in a try-catch block and use threads properly.

He also suggested I use `std::jthread`, which is a more modern version of `thread`. For various reasons, it is better.

Once I called `thready.detach()` to stop code execution from blocking the OS boot, it worked. I setup a simple endpoint for those `GET /` requests:
```cpp
        server.when("/")->requested([](const HttpRequest &req) {
            return HttpResponse{200, "text/plain", "Ristretto"};
        });
```
And now, if I made a GET request:
```
> curl 192.168.1.195:8572/
Ristretto
>
```
This meant that now there was a web server running on the Wii U, in the background, ready to respond to any request we throw at it - as long as it is defined.

# Things begin to quickly get crazy
I spent so much time talking about the HTTP server that I think it is overwhelming to continue the story from here in this post.

Next blog post will be about starting to experiment with what power this gave me. But in the meantime, I wrote a small configuration option to disable the HTTP server (because there are various reasons it may be best if it is disabled). Trace helped with this, and also provided appropriate implementations for [`sys/endian.h`](https://github.com/wiiu-smarthome/Ristretto/commit/dc75a8e88433194e1bc72bad828191093ecf76e4#diff-d09c37b78df05ff2259dcbc2aaa6e0293ebce36a310793ce129466558dae9411) on our big endian processor.

But although I was determined solely on the HTTP server, by doing this I had learned to make threads, a little bit of how networking works (as I had to chase down the headers with all the socket functions in `nsysnet` for the HTTP server to compile), and a slightly better idea of how HTTP works. It also gave me experience with porting code to other platforms, and what Ristretto will also teach me (as I continue the story) is how a lot of Cafe OS works.