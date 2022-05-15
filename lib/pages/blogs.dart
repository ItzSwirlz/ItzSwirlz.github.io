import 'package:flutter/material.dart';

import 'package:yaru_widgets/yaru_widgets.dart';

class BlogsPage extends StatefulWidget {
  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: YaruPage(
        children: [
          Text('We are the world, we are the **children**'),
        ],
      ),
    );
  }

}