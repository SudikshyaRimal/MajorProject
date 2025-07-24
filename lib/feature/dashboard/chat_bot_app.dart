import 'package:flutter/material.dart';

void main() {
  runApp(ChatBotApp());
}

class ChatBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatBotScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ChatBotScreen extends StatefulWidget {
  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  List<Map<String, dynamic>> messages = [
    {"text": "Hi, I’m Sendbird Bot!\nHow can I help you today? 😊", "isBot": true}
  ];

  final TextEditingController _controller = TextEditingController();

  bool showOptions = true;

  void onOptionSelected(String option) {
    setState(() {
      showOptions = false;
      messages.add({"text": option, "isBot": false});
      Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          messages.add({"text": "Ok, I’m transferring you to Alex.", "isBot": true});
        });
      });
    });
  }

  void sendMessage() {
    String userInput = _controller.text.trim();
    if (userInput.isEmpty) return;

    setState(() {
      messages.add({"text": userInput, "isBot": false});
      _controller.clear();

      // Dummy bot response after delay
      Future.delayed(Duration(milliseconds: 700), () {
        setState(() {
          messages.add({
            "text": "You said: \"$userInput\"\nI’m still learning to respond 😊",
            "isBot": true
          });
        });
      });
    });
  }

  Widget buildBotMessage(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xFFDCEAFE),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.smart_toy, color: Colors.blueAccent),
            SizedBox(width: 8),
            Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }

  Widget buildUserMessage(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.purple[100],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(text, style: TextStyle(fontSize: 16, color: Colors.purple[900])),
      ),
    );
  }

  Widget buildUserOption(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.purple,
          side: BorderSide(color: Colors.purple),
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        ),
        onPressed: () => onOptionSelected(label),
        child: Text(label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Care Bot"),
        backgroundColor: Colors.blue[800],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length + (showOptions ? 3 : 0),
              itemBuilder: (context, index) {
                // Option buttons


                // Adjust index for message list
                final actualIndex = index - (showOptions ? 3 : 0);

                if (actualIndex >= 0 && actualIndex < messages.length) {
                  final message = messages[actualIndex];
                  return message["isBot"]
                      ? buildBotMessage(message["text"])
                      : buildUserMessage(message["text"]);
                }

                return SizedBox.shrink(); // For any invalid index
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => sendMessage(),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
