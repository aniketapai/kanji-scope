import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("H O M E", style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.black54,
        centerTitle: true,
        elevation: 0,
      ),
      body: const Center(child: Text('Home Page Content')),
    );
  }
}
