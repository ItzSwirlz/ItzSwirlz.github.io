import 'package:flutter/material.dart';

import 'package:yaru_icons/yaru_icons.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

class BlogsPage extends StatefulWidget {
  const BlogsPage({Key? key}) : super(key: key);

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Website of Joshua Peisach"),
        actions: [
          TextButton(
            child: const Text('Blogs'),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const BlogsPage()));
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
      body: const YaruPage(
        children: [
          Text('We are the world, we are the **children**'),
        ],
      ),
    );
  }
}
