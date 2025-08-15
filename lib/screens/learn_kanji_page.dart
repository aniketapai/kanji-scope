import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class LearnKanjiPage extends StatefulWidget {
  const LearnKanjiPage({super.key});

  @override
  State<LearnKanjiPage> createState() => _LearnKanjiPageState();
}

class _LearnKanjiPageState extends State<LearnKanjiPage> {
  final Gemini gemini = Gemini.instance;
  List<ChatMessage> messages = [];

  ChatUser currentUser = ChatUser(id: "0", firstName: "User");
  ChatUser geminiUser = ChatUser(
    id: "1",
    firstName: "StudyBot",
    profileImage: "",
  );

  static const String instruction = """
You are a helpful Japanese learning assistant.
Rules:
- Only answer questions about Japanese language, kanji, vocabulary, grammar, or culture.
- If the question is off-topic, politely say: 'I can only answer Japanese learning questions.'
- Use simple, clear explanations.
- While explaining please don't join the words, there should a space separating them
- Include romaji and furigana when relevant.
- Give short example sentences in Japanese with translations.
""";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("L E A R N", style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.black54,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: _buildUI(),
      ),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: currentUser,
      onSend: _sendMessage,
      messages: messages,
      scrollToBottomOptions: const ScrollToBottomOptions(disabled: false),
      messageOptions: MessageOptions(
        currentUserContainerColor: Colors.white,
        currentUserTextColor: Colors.black,
        containerColor: Colors.black38,
        textColor: Colors.white,
        borderRadius: 16,
        onLongPressMessage: (message) {
          Clipboard.setData(ClipboardData(text: message.text));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Copied to clipboard")),
          );
        },
      ),
      inputOptions: InputOptions(
        inputTextStyle: const TextStyle(color: Colors.white),
        cursorStyle: CursorStyle(color: Colors.white),
        inputDecoration: InputDecoration(
          hintText: "Type a message...",
          hintStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.grey.shade900,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: const BorderSide(color: Colors.white, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
        ),
        sendButtonBuilder: (Function() onSend) {
          return IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: onSend,
          );
        },
      ),
    );
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });

    String question = "$instruction\n\nUser: ${chatMessage.text}";

    String buffer = ""; // Temporary storage for streaming text

    try {
      gemini
          .promptStream(parts: [Part.text(question)])
          .listen(
            (value) {
              String partial = value?.output ?? '';
              if (partial.isNotEmpty) {
                buffer += partial; // Append new chunk to buffer
              }
            },
            onDone: () {
              if (buffer.isNotEmpty) {
                buffer = _cleanMarkdown(buffer); // Clean formatting
                setState(() {
                  messages = [
                    ChatMessage(
                      user: geminiUser,
                      createdAt: DateTime.now(),
                      text: buffer,
                    ),
                    ...messages,
                  ];
                });
              }
            },
            onError: (e) {
              print("Gemini Error: $e");
            },
          );
    } catch (e) {
      print("Gemini Error: $e");
    }
  }

  String _cleanMarkdown(String text) {
    text = text.replaceAllMapped(
      RegExp(r'\*\*(.*?)\*\*'),
      (match) => '"${match.group(1)}"',
    );
    text = text.replaceAll(RegExp(r'^\s*-\s*', multiLine: true), '• ');
    text = text.replaceAll(RegExp(r'[ \t]+$', multiLine: true), '');
    return text;
  }
}
