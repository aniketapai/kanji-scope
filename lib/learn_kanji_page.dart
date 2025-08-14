import 'package:flutter/material.dart';

class LearnKanjiPage extends StatelessWidget {
  const LearnKanjiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("L E A R N", style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.black54,
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(child: Text('Learn Page Content')),
    );
  }
}
