import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'blogs.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // URLs
  Uri facebookURI = Uri.https('facebook.com', 'joshua.peisach.1');
  Uri githubURI = Uri.https('github.com', 'ItzSwirlz');
  Uri instagramURI = Uri.https('instagram.com', 'itzswirlz');
  Uri twitchURI = Uri.https('twitch.tv', 'itzswirlz12');
  Uri twitterURI = Uri.https('twitter.com', 'ItzSwirlz');
  Uri ubuntuURI = Uri.https('wiki.ubuntu.com', 'itzswirlz');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Website of Joshua Peisach"),
        actions: [
          TextButton(
            child: const Text('Blogs'),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BlogsPage()));
            },
          ),
          IconButton(
            icon: const Icon(YaruIcons.information),
            onPressed: () {
              showAboutDialog(
                  context: context,
                  applicationName: "ItzSwirlz's Website",
                  applicationVersion:
                  "View the licenses of the packages used to make this blog!",
                  applicationLegalese: 'GNU General Public License v3.0');
            },
          ),
        ],
      ),
      body: const Center(
        child: YaruPage(
          children: [
            Text(
                "Welcome to my website! It is pretty small at the moment, considering I just started it, but it will grow.",
                textScaleFactor: 2.0),
            Text(
                "This is not a regular blog/site built using WordPress or Weebly, but in fact it is a site built ground-up, from scratch with love in Flutter!",
                textScaleFactor: 2.0),
            Text("Uh... check back for when I continue working on this thing."),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Tooltip(
                message: 'GitHub',
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.github),
                  onPressed: () async {
                    if(!await launchUrl (githubURI)) {
                      throw 'Could not open GitHub profile';
                    }
                  },
                )
            ),
            Tooltip(
                message: 'Ubuntu Wiki Page',
                child: IconButton(
                  icon: const Icon(YaruIcons.ubuntu_logo),
                  onPressed: () async {
                    if(!await launchUrl (ubuntuURI)) {
                      throw 'Could not open Ubuntu Wiki Page';
                    }
                  },
                )
            ),
            Tooltip(
                message: 'Twitter',
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.twitter),
                  onPressed: () async {
                    if(!await launchUrl (twitterURI)) {
                      throw 'Could not open Twitter profile';
                    }
                  },
                )
            ),
            Tooltip(
                message: 'Facebook/Meta',
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.facebook),
                  onPressed: () async {
                    if(!await launchUrl (facebookURI)) {
                      throw 'Could not open Facebook profile';
                    }
                  },
                )
            ),
            Tooltip(
                message: 'Instagram',
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.instagram),
                  onPressed: () async {
                    if(!await launchUrl (instagramURI)) {
                      throw 'Could not open Instagram profile';
                    }
                  },
                )
            ),
            Tooltip(
                message: 'Twitch',
                child: IconButton(
                  icon: const Icon(FontAwesomeIcons.twitch),
                  onPressed: () async {
                    if(!await launchUrl (twitchURI)) {
                      throw 'Could not open Twitch profile';
                    }
                  },
                )
            ),
          ],
        ),
      ),
    );
  }
}
