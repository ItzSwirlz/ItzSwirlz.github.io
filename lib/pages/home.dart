import 'package:flutter/material.dart';

import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'blogs.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog of Joshua Peisach"),
        actions: [
          TextButton(
            child: Text('Blogs'),
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
                  applicationName: "ItzSwirlz's Blog",
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
                "Welcome to my blog! It is pretty small at the moment, considering I just started it, but it will grow.",
                textScaleFactor: 2.0),
            Text(
                "This is not a regular blog built using WordPress or Weebly, but in fact it is a blog built ground-up, from scratch with love in Flutter!",
                textScaleFactor: 2.0),
            Text("Uh... check back for when I continue working on this thing."),
          ],
        ),
      ),
    );
  }
}
