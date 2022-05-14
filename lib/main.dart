import 'package:flutter/material.dart';
import 'package:itzswirlz_blog/pages/home.dart';

import 'package:yaru/yaru.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog of Joshua Peisach',
      theme: yaruDark,
      home: HomePage(),
    );
  }
}
