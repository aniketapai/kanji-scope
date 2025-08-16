import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'kanji_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = ''; // "jlpt" or "grade"
  String? selectedValue;
  List<String> kanjiList = [];
  bool isLoading = false;

  final jlptLevels = ['5', '4', '3', '2', '1'];
  final gradeLevels = ['1', '2', '3', '4', '5', '6', '8']; // 7 skipped

  Future<void> fetchKanjiList() async {
    if (selectedCategory.isEmpty || selectedValue == null) return;

    setState(() => isLoading = true);
    try {
      final url = selectedCategory == 'jlpt'
          ? "https://kanjiapi.dev/v1/kanji/jlpt-$selectedValue"
          : "https://kanjiapi.dev/v1/kanji/grade-$selectedValue";

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          kanjiList = List<String>.from(data);
        });
      } else {
        setState(() => kanjiList = []);
      }
    } catch (e) {
      setState(() => kanjiList = []);
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("H O M E", style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.black54,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Category toggle
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: const Text("JLPT"),
                  selectedColor: Colors.black,
                  selected: selectedCategory == 'jlpt',
                  onSelected: (val) {
                    setState(() {
                      selectedCategory = 'jlpt';
                      selectedValue = null;
                      kanjiList = [];
                    });
                  },
                ),
                const SizedBox(width: 10),
                ChoiceChip(
                  label: const Text("Grade"),
                  selected: selectedCategory == 'grade',
                  selectedColor: Colors.black,
                  onSelected: (val) {
                    setState(() {
                      selectedCategory = 'grade';
                      selectedValue = null;
                      kanjiList = [];
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Dropdown
            if (selectedCategory.isNotEmpty)
              DropdownButton<String>(
                value: selectedValue,
                hint: Text(
                  selectedCategory == 'jlpt'
                      ? "Select JLPT Level"
                      : "Select Grade",
                ),
                items: (selectedCategory == 'jlpt' ? jlptLevels : gradeLevels)
                    .map(
                      (level) => DropdownMenuItem(
                        value: level,
                        child: Text(
                          selectedCategory == 'jlpt'
                              ? "JLPT-$level"
                              : "Grade $level",
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedValue = value!);
                  fetchKanjiList();
                },
              ),
            const SizedBox(height: 20),

            // Kanji grid
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: Colors.white,))
                  : kanjiList.isEmpty
                  ? const Center(
                      child: Text("Select JLPT or Grade to view Kanji"),
                    )
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 4,
                            mainAxisSpacing: 4,
                          ),
                      itemCount: kanjiList.length,
                      itemBuilder: (context, index) {
                        final kanji = kanjiList[index];
                        return GestureDetector(
                          onTap: () async {
                            final url = Uri.parse(
                              "https://kanjiapi.dev/v1/kanji/$kanji",
                            );
                            final response = await http.get(url);

                            if (response.statusCode == 200) {
                              final data =
                                  json.decode(response.body)
                                      as Map<String, dynamic>;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      KanjiDetailsScreen(kanjiData: data),
                                ),
                              );
                            }
                          },
                          child: Card(
                            color: Colors.black87,
                            child: Center(
                              child: Text(
                                kanji,
                                style: const TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
