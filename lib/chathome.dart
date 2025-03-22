import 'dart:convert';
import 'package:chatbot/formatting.dart';
import 'package:http/http.dart' as http;
import 'package:chatbot/messages.dart';
import 'package:flutter/material.dart';

class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  String apiKey = "ENTER API KEY";
  TextEditingController user_message = TextEditingController();
  String? data = null;
  final List<Message> _messages = [
    // Message(text: 'Heyy hows it going!!', isUser: true),
    // Message(text: 'This is text 22', isUser: true),
    // Message(text: 'woow veryyy cool', isUser: false),
  ];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurpleAccent,
            title: Text(
              'Gemini AI',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final text = message.text;
                      final user = message.isUser;
                      return ListTile(
                        title: Align(
                          alignment: user ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: user ? Colors.green : Colors.blue,
                            ),
                            child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                child: FormatBuilder(
                                  text: text,
                                )),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            setState(() {
                              _messages.add(Message(text: user_message.text.trim(), isUser: true));
                              getResponse(user_message.text.trim());
                            });
                            user_message.clear();
                          }
                        },
                        controller: user_message,
                        decoration: InputDecoration(border: OutlineInputBorder()),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.deepPurpleAccent,
                        ),
                        child: IconButton(
                            onPressed: () {
                              setState(() {
                                _messages.add(Message(text: user_message.text.trim(), isUser: true));
                                getResponse(user_message.text.trim());
                              });
                              user_message.clear();
                            },
                            icon: Icon(
                              Icons.send_rounded,
                            )))
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Future<void> getResponse(String query) async {
    setState(() {
      data = null;
    });
    try {
      final url =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=${apiKey}";

      final body = {
        "contents": [
          {
            "parts": [
              {"text": query}
            ]
          }
        ]
      };

      final res = await http.post(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (res.statusCode == 200) {
        final responseData = jsonDecode(res.body);
        setState(() {
          data = responseData['candidates'][0]['content']['parts'][0]['text'];
        });

        print(data);
        setState(() {
          if (data != null) {
            _messages.add(Message(text: data!, isUser: false));
          }
        });
      } else {
        print('Failed to get response. Status code: ${res.statusCode}');
        print('Error Response: ${res.body}');
      }
    } catch (err) {
      print('Error: $err');
    }
  }
}
