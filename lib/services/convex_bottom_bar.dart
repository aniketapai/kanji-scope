import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:kanji_app/screens/learn_kanji_page.dart';
import 'package:kanji_app/screens/search_page.dart';
import 'package:kanji_app/screens/settings.page.dart';

import '../screens/home_page.dart';

class ConvexBottomBar extends StatefulWidget {
  const ConvexBottomBar({super.key});

  @override
  State<ConvexBottomBar> createState() => _ConvexBottomBarState();
}

class _ConvexBottomBarState extends State<ConvexBottomBar> {
  var _currentIndex = 0;

  // List of pages
  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    LearnKanjiPage(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: _pages[_currentIndex]
      ),
      bottomNavigationBar: ConvexAppBar(
        backgroundColor: Colors.black54,
        style: TabStyle.react,
        items: [
          TabItem(icon: Icons.home),
          TabItem(icon: Icons.manage_search),
          TabItem(icon: Icons.book),
          TabItem(icon: Icons.settings),
        ],
        initialActiveIndex: 0,
        onTap: (var index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
