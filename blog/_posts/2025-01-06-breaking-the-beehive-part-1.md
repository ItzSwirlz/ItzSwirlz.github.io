---
layout: post
title: "Breaking the Beehive - Part 1: Where Honey Took The Money"
date: 2025-01-06 20:49:54 -0500
categories: honey honey-extension
---
*This post assumes that you understand the ongoing controversy around the Honey browser extension. If you don't know, watch [MegaLag's video. ](https://www.youtube.com/watch?v=vc4yL3YTwW)TL;DW: The free browser extension advertised to be finding coupon codes for users to apply upon checkout when purchasing items online, has been found to be a lie in two ways: replacing the referral token (ruining content creator commission), and not actually showing you the best coupon codes available, with coupons being controlled by the store. This post focuses on the latter.*

I'm honestly surprised nobody else seems to be doing this, but I decided to take a look into the code of the Honey browser extension to see what it was actually doing. I'm able to do this because browser extensions are deployed in JavaScript, which is an interpreted language. So it is relatively easy to reconstruct and figure out what was happening - though some other things complicated this (more on it later).

In this blog post I will cover how I started "breaking the beehive", documenting the extension's code and what I've uncovered about which stores are impacted by Honey.

The first thing I did was ensure I uploaded a copy of the latest version of the extension to the Internet Archive. Someone else actually did this before me, but I didn't realize and had uploaded it anyways. I finished the work by uploading the macOS and iOS app contents, and now, every single platform Honey was ever built for: Chrome (and chrome-based browsers), Edge, Firefox, Android, iOS, macOS, all has their files backed up. **Why?** Because Honey can easily release a new version of the extension taking out the malicious code, or take down the extension entirely. Since LegalEagle just filed a class-action lawsuit, and by the time I checked, the latest version had been released before MegaLag's video, I didn't want Honey to get away with this.

On my GitHub repo, [Honey-Extension-Archive](https://github.com/ItzSwirlz/Honey-Extension-Archive) I uploaded an archived copy of the bundled extension and the "documented" version, which is what I'm working in, and where I have done my investigation and made my discoveries.

**My look into this is far from done.** I'm hoping others can help. This should be easy, but in reality, it wasn't.

So, off I went.

# Getting Started
The first thing you will see when you open the files for the first time (and trust me when I say that I'm pretty sure the core of the extension is in the `h0.js` file), is something like this...

<center><img src="/blog/assets/honeychaos.png"></center>

Just to be clear, this is not the entire extension. In fact, those lines that look like gibberish on the top is actually code... and it goes on in one line... for many, *many* characters.

## How Honey Was (Likely) Deployed
Honey used a bundler, [Webpack](https://webpack.js.org) , I'm pretty sure, based on strings in the code, to deploy its product. That is fine, but one of the techniques Honey did (which is standard) is to sort of "minimize" the code as much as possible. JavaScript does not need the indentations and paragraph breaks and lines that us humans need to read code. It can all be read as one string. Furthermore, to the public, variable names don't matter, so they can be anything. It doesn't have to make sense. That is why the file is a few lines of millions of characters of code with some copyright licensing metadata in between.

Using [js-beautify](https://github.com/beautifier/js-beautify), this isn't an issue. We can format the file to our liking, to be read by a human. Unfortunately, there are still lots of missing variable names, and because of whatever bundler was used, things are still hard to read and make sense of. The file is also more than 100,000 lines long.

I should also mention now that the original extension code is probably not JavaScript, but rather TypeScript. TypeScript compiles to JavaScript, so that's why the output looks very much like it is not written by a human, and also why things are literally all over the place. Especially the variable names, because the output of TypeScript does not need to refer to its variables from the original source.

So now, we end up with this file.

Let's now discuss some of the magic in it that the bundler (or Honey) has masterfully put into it to make anyone trying to reverse engineer (if that's the right word) or understand any of the code like a hamster running in a tiny ferris wheel.

##  Ground Level
This is what the top of the file looks like:
<center><img src="/blog/assets/h0.png"></center>

By the way, none of this is meaningful. I'm pretty confident that maybe half of the file is just garbage from the bundler trying to put things together to be used on platforms or browsers that don't support some JavaScript functionality. Like, this is worse than useless.

But don't worry - eventually, the extension *needs* to make some call to the browser. A simple search for `chrome.cookies` will bring you to it:
```js
function c(e) {

	return new(o())((function(t, r) {

		chrome.cookies.set({

			url: e.url,

			name: e.name,

			value: e.value,

			domain: e.domain,

			path: e.path,

			secure: !!e.secure,

			httpOnly: !!e.httpOnly,

			expirationDate: Math.round(parseInt(e.expires, 10) / 1e3) || null

		}, (function(e) {

			chrome.runtime.lastError ? r(new Error(chrome.runtime.lastError.message)) : t(s(e))

		}))
	}))

}
```
I'm not even going to try to explain how you're supposed to read this. These are lambda expressions. The most confusing part is, what is `o()`? 

Well, `o` is actually this:
```js
var n = r(59880),
o = r.n(n),
```
So, what the gives?

## Module Mayhem
*This is a bit confusing, but basically, the entire file is a compilation of modules, which makes it hard to track function calls.*

`r(59880)` refers to a specific part of the file actually. Specifically, it is the Bluebird JavaScript library.

The most obvious thing is to find all instances of `cookies` in the file, but that won't get you anywhere (other than the DACs which I will bring up momentarily). The developers did not code the entire extension in one file. They made node modules and every time one is imported (or exported), they are put into the file in it's own like, "ID", if that makes sense.

For example, here is the top `stats` module at `60599`:
```js
60599: (e, t, r) => {

	"use strict";

	r.d(t, {

		Z: () => _

	});
	// ...
}
```
Because of how the bundler names things, when calling other modules, it will not be as simple as `cookies.set`. You end up with something like `L.Z.(actualFunctionName)(parameters)`, or `L.Z.o`, where L is a reference to a module, `Z` is usually the class (the actual contents of that module), and `o` is a function.

If none of this makes sense, it's because it doesn't. I don't think there's a good way to explain this. When a module is imported, it's given a variable, and then that module that is trying to use that other module calls its functions from there. Sometimes it's not even the function directly - it's a wrapper function that just calls the function.

Sometimes, there is some luck: We get things like this:
```js
r(30714).Z.addListener("paypal:action", (function(e, t) {

	var r = t.action,

	n = t.data;

	switch (r) {

	case "getMessage":

		return v(n);

	case "getTsCookie":

		return m();

	default:

		return null

}

}));
```
This section of code actually makes sense - we know that clearly there is some listener being added and that action in `t` is trying to refer to a specific function. From here we know that `v(n)` is `getMessage(n)` and `m()` is `getTsCookie()`.

This process, of trying to work backwards and understand what functions are named, and then name the modules and name the variables *referring* to those modules is what makes this process so tedious.

Thankfully, there is one module at `67132`, which I believe is tied to the "entry point" of the extension that contains something like this:
```js
var Z = {

	$: c(),

	acorns: d.Z,

	adbBp: f.Z,

	alarms: h.Z,

	apiRequest: l.Z,

	button: m.Z,

	config: g.Z,

	cookies: y.Z,
	// ...
}
```
As you can probably guess, those single letter variables refer to those modules. We can use this to map the names of the "modules" or "sections" to their "IDs", and once you figure something out, a whole new set of code is revealed.

So, that's why this is chaos to work with. The bundler makes it difficult to trace function calls because of this "module referencing" system. And the kicker is: this is just `h0.js` and it has **no relation to the other files, like the one specifically for the popover!**

Anyways, while I have not found the most grudging issue, which is deliberately replacing affiliate tokens, I have been able to uncover how through Honey's partner program, stores are specifically choosing which coupons to show you.

# Companies and Coupons
This is the actual details part of what I've learned about the extension.
## DACs
A DAC stands for - I have absolutely no idea. But I'm pretty confident (and trust me on this because I will never get anywhere if I explain why) that a DAC is the module (a separate node module, I believe), that is responsible for managing coupon searching, selection and application for a specific website.

Take the CVS DAC for example:
```js
t.default = new s.default({

	description: "CVS DAC",

	author: "Honey Team",

	version: "0.1.0",

	options: {

		dac: {

			concurrency: 1,

			maxCoupons: 10

		}

	},

	stores: [{

		id: "7422251010108067594",

		name: "CVS"

	}],
	doDac: function(....
```
There are interesting things that stand out. First of all, the `maxCoupons` thing. I have not heard anyone else talk about this, but I am pretty confident that indeed, **through the partner program, companies can control how many coupons you can get through Honey to be used on the store.**  That's fun.

Now, you'll see that the store is given an ID. This ID actually means something.

In the code, there is a specific fetch request to get the trending stores, stored at `https://cdn.honey.io/extension/data/trending-stores.json` , which returns, well, the trending stores people are buying things off of, but also it contains, and this is just a small section of one response:
```json
"storeId":"88984720997497018","hasIcon":true,"coupons":[{"code":"BBFIRST"},{"code":"BFCMCA40"},{"code":"POPUP"},{"code":"BBTABLE"},{"code":"CART15"},{"code":"MOTHERSPL"},{"code":"GRADSPL"},{"code":"MEMORIAL30"},{"code":"SUMMER22"},{"code":"MEMO"},{"code":"MEM"},
```
The `storeId` field matches to something like a DAC, and those coupons can be pulled directly this way.

The purpose of these DAC modules (or acorns as they are sometimes referred to?) is to handle coupon application codes specific to each site, because the way the coupon data is stored (in its HTML or JavaScript, or in its cookies) vary.

Here's a good example: JCPenney's DAC (well it's called "Meta Function" in this case but it's the same thing basically). It gets the account ID that the order is being placed on, then using jQuery sends a request to add a coupon code to the purchase.

<center><img src="/blog/assets/jcpenneydac.png"></center>

This is just one example. Most of the DACs are unique because they are handled in different ways - different API endpoints, different ways of gathering the information and applying the coupon, you can see the file for yourself for more information.

So yeah, I'm still learning and working through the file, but I can proudly present now, a list of all the companies and or store websites that have special DACs.

  
- `4-Wheel-Parts`, line 1139

- `American Eagle`, line 1212

- `Aeropostale`, line 1270

- `Amazon`, line 1336 ("Amazon Find Savings")

- `Athleta FS`, line 1397

- `Banana Republic FS`, line 1456

- `Bath & Body Works`, line 1512

- `Belk`, line 1560

- `Buy a Gift UK` , line 1616

- `CARiD`, line 1668

- `Catherines`, line 1720

- `Coles`, line 1782

- `CVS`, line 1852

- `DSW`, line 2012

- `Expedia`, line 2119

- `Fitflop`, line 2219

- `Forever21`, line 2278

- `Gap FS`, line 2351

- `HM-CA`, line 2409

- `Hammacher Schlemmer`, line 2465

- `Home Depot`, line 2533

- `JcPenney`, line 2603

- `JCrew`, line 2684

- `Kohl's`, line 2753

- `Loft`, line 2804

- `Macy's`, line 2861

- `Office Depot`, line 2931

- `Old Navy FS`, line 3045

- `Papa John's`, line 3177

- `Pretty Little Thing` France: Line 3229, UK: Line 3349

- `Puritans-Pride`, line 3469

- `Saks Fifth Avenue`, line 3514

- `Sephora`, line 3576

- `Shopify Pay`, line 3641

- `Shutterstock`, line 3925

- `Staples`, line 4008

- `TJ Maxx`, line 4085

- `Vimeo`, line 4132

- `Vitacost`, line 4188

- `Wish`, line 4242

- `Worldmarket`, line 4298

I will give the benefit of the doubt to these places: they may have needed to partnership to prevent dealing with too many discounts that they couldn't turn profit.

However, you may have noticed that Newegg, which is what MegaLag showed the example of affiliate cookie replacement, is not in this list.

Well, it is in `h0.js`. As a matter of fact, it is part of line 129,908. A 14,500+ character JSON array of website URLs, that does include Newegg, but also many other online stores.

The list is so long: Some of the stores are the same websites but for other countries (like amazon.com vs amazon.co.uk). But some of the results were a bit surprising. For the full list, [see here.](https://github.com/ItzSwirlz/Honey-Extension-Archive/blob/main/Documented/17.0.2_0/storeURLs.json)

Here were some honorable mentions:
- Best Buy
- Crocs
- GameStop
- **Minecraft** - yes, `minecraft.net` (this is so stupid: I don't even think you can buy anything on that website, purchases I believe go through the Microsoft store for Bedrock edition)
- WordPress (for some reason???)
- AMD
- Mee6 (the discord bot)
	- *Update: I have reached out to Mee6. They do not have affiliate deals or commissions, and their coupon codes are very public, so they should be unaffected. They will investigate nonetheless.*
- BitDefender, Avast, and other antivirus software
- **Hypixel.** Yes, the **largest multiplayer server in Minecraft.**
- Steam (`steampowered.net`)
- JetBrains
- Xfinity
- LEGO
- Medium
- Kahoot
- World of Tanks
- Roblox
- FlightRadar24

However, in my testing, I found that Honey does find coupons for [TheCubicle](thecubicle.us) but it is not mentioned here. When testing, I have not found enough proof of a PayPal cookie or storage item being set after running through the extension. **I am not 100% sure, but I believe that this list MAY be a list of "acceptable domains" for Honey to replace affiliate commission cookies with their own (PayPal)'s. I still have a lot of tracing and research to do, but I think this is unfortunately, a possibility.**

I *believe* (unconfirmed) the difference between being in a DAC and being in the `storesList` is that a DAC is specifically responsible for applying coupon codes that the store can choose to give access to, while being in the `storesList` means Honey will attempt to replace the commission or affiliate tokens. And man, if this is true, the list of websites targeted is *massive*. Across nearly every area of shopping and online consumerism.

# Final thoughts
I labeled this "part one". Although I was thinking my second blog post would be a continuation of Ristretto, I happened to delve very deep into this. There is so much to learn and so much that I've yet to uncover. And I could probably write a book on how I've been trying to truly understand this extension, and all the blood, sweat and tears put into this. I left out a lot of details because things quickly get complex. If you want a more technical explanation, I think it's best to just look at my (WIP) documented files so you can see comments I've placed, what is missing, how the module stuff works and all that fun stuff.

I have unfortunately not found anything that can 100% confirm beyond reasonable doubt in the code that PayPal Honey has been stealing affiliate commission from content creators and/or has been falsely misleading consumers into believing they are getting the best coupon codes, but I am sure eventually everything will make sense. I'm just glad everything is archived so Honey can't get away with it :)

Most likely there will be a follow up post, and at least many revisions to this post with corrections, updates, more screenshots, and better explanations of how things work. I've been typing this for about an hour, and I'm just eager to send this out ASAP along with the list of DACs and Store URLs.

If you want to join the effort, feel free to open a pull request to my repository. There is lots to do.

*Updated on January 7 2024 at 11:42 AM EST: Update with new knowledge regarding Webpack being used as the bundler and Mee6's response. Also add Flightradar24 and Roblox to the list of store urls.*