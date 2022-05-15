import 'package:flutter/material.dart';

import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class BlogsPage extends StatefulWidget {
  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
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
      body: YaruPage(
        children: [
          Text('We are the world, we are the **children**'),
        ],
      ),
    );
  }

}