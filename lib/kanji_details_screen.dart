import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KanjiDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> kanjiData;

  const KanjiDetailsScreen({super.key, required this.kanjiData});

  @override
  State<KanjiDetailsScreen> createState() => _KanjiDetailsScreenState();
}

class _KanjiDetailsScreenState extends State<KanjiDetailsScreen> {
  List<Map<String, dynamic>> exampleWords = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExampleWords();
  }

  Future<void> fetchExampleWords() async {
    final kanji = widget.kanjiData['kanji'] ?? '';
    if (kanji.isEmpty) return;

    final url = Uri.parse('https://kanjiapi.dev/v1/words/$kanji');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          exampleWords = data
              .take(10)
              .map((e) => e as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget buildReadingChips(List<String> readings) {
    if (readings.isEmpty) {
      return const Text('N/A');
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: readings
          .map(
            (reading) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(reading, style: const TextStyle(fontSize: 16)),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<String> kunReadings = List<String>.from(
      widget.kanjiData['kun_readings'] ?? [],
    );
    List<String> onReadings = List<String>.from(
      widget.kanjiData['on_readings'] ?? [],
    );

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Kanji Character
            Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  widget.kanjiData['kanji'] ?? '',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.grey, thickness: 1, height: 32),
            const SizedBox(height: 24),
            Center(
              child: Text(
                (widget.kanjiData['meanings'] as List?)
                        ?.join(', ')
                        .toLowerCase() ??
                    'N/A',
                style: const TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 16),
            Center(child: const Text('Kun readings:')),
            const SizedBox(height: 8),
            Center(child: buildReadingChips(kunReadings)),
            const SizedBox(height: 16),
            Center(child: const Text('On readings:')),
            const SizedBox(height: 8),
            Center(child: buildReadingChips(onReadings)),
            const SizedBox(height: 16),
            Center(
              child: Text('JLPT level: ${widget.kanjiData['jlpt'] ?? 'N/A'}'),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.grey, thickness: 1, height: 32),
            const SizedBox(height: 24),
            // Example Words Section
            const Text(
              'Example Words:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (exampleWords.isEmpty)
              const Center(child: Text('No examples available'))
            else
              ...exampleWords.map((word) {
                final variant = (word['variants'] as List?)?.first;
                final meaning =
                    (word['meanings'] as List?)?.first['glosses'] as List?;
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        variant?['written'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        meaning != null ? meaning.join(', ') : '',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
