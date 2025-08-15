import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'kanji_details_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _controller = TextEditingController();
  Map<String, dynamic>? kanjiData;
  String? error;
  bool isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchKanji(String kanji) async {
    if (kanji.isEmpty) return;
    setState(() {
      isLoading = true;
      error = null;
      kanjiData = null;
    });
    try {
      final res = await http.get(
        Uri.parse('https://kanjiapi.dev/v1/kanji/$kanji'),
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          kanjiData = data;
        });
      } else {
        setState(() {
          error = 'Kanji not found';
        });
      }
    } catch (e) {
      setState(() {
        error = 'Network error';
      });
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S E A R C H', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.black54,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                maxLength: 5,
                decoration: InputDecoration(
                  hintText: 'Enter Kanji',
                  border: const OutlineInputBorder(),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                              kanjiData = null;
                              error = null;
                            });
                          },
                        ),
                ),
                onSubmitted: fetchKanji,
              ),
              const SizedBox(height: 20),
              if (isLoading) const CircularProgressIndicator(
                color: Colors.white,
              ),
              if (error != null)
                Text(error!, style: const TextStyle(color: Colors.red)),
              if (kanjiData != null)
                GestureDetector(
                  onTap: () {
                    // Navigate to Details screen with kanjiData
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            KanjiDetailsScreen(kanjiData: kanjiData!),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      kanjiData!['kanji'] ?? '',
                      style: const TextStyle(fontSize: 48),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
