import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Chat extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Chat> {
  Color biscuitGrey = Color.fromRGBO(47, 47, 47, 1.0);
  final List<Map<String, dynamic>> messages = [];

  TextEditingController _messageController = TextEditingController();

  void _sendMessage(String message) async {
    String url = 'https://react.biscuitbobby.me/chat';
    Map<String, String> headers = {'Content-Type': 'application/json'};
    Map<String, dynamic> body = {"text": message};

    setState(() {
      messages.add({'text': message, 'isMe': true, 'icon': 'assets/user.png'});
    });
    _messageController.clear();

    http.Response response = await http.post(Uri.parse(url),
        headers: headers, body: json.encode(body));

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = json.decode(response.body);
      String responseMessage = responseData['text'];

      setState(() {
        messages.add({
          'text': responseMessage,
          'isMe': false,
          'icon': 'assets/logo.png'
        });
      });

      _messageController.clear();
    } else {
      setState(() {
        messages.add({'text': 'Error: ${response.statusCode}', 'isMe': false});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: biscuitGrey,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Container(
                    alignment: message['isMe']
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!message['isMe'])
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CircleAvatar(
                                radius: 21.0,
                                backgroundImage: AssetImage(
                                  message['icon'],
                                ),
                              ),
                            ),
                          Expanded(
                              child: Container(
                                  alignment: message['isMe']
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 4.0),
                                  child: Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width -
                                                125,
                                      ),
                                      decoration: BoxDecoration(
                                        color: message['isMe']
                                            ? Colors.green[300]
                                            : Colors.grey[300],
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0, vertical: 8.0),
                                      child: Text(
                                        message['text'],
                                        style: TextStyle(fontSize: 16.0),
                                      )))),
                          if (message['isMe'])
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: CircleAvatar(
                                radius: 21.0,
                                backgroundImage: AssetImage(
                                  message['icon'],
                                ),
                              ),
                            ),
                        ]),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
              margin: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message...',
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      String message = _messageController.text;
                      if (message.isNotEmpty) {
                        _sendMessage(message);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
