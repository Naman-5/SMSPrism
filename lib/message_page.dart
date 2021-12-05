import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';
import 'dart:ui';

var _messages = [];
Color color = Colors.green;
String colorSelector = "Important";

/*
Function to send message content to the flask API and
fetch the user respose.
 */
Future<String> categorize(msg) async {
  var url = Uri.parse('http://127.0.0.1:5000/predict');
  var response = await http.post(url, body: json.encode({'key': '$msg'}));
  return json.decode(response.body);
}

Future<void> sort(i) async {
  if (i['type'].toString().trim() == "Advertising" ||
      i['type'].toString().trim() == "Spam" ||
      i['type'].toString().trim() == 'Malicious' ||
      i['type'].toString().trim() == 'Fradulent') {
    spamMessages.add({"s": i['s'], "c": i['c'], 'type': i['type']});
  } else {
    hamMessages.add({"s": i['s'], "c": i['c'], 'type': i['type']});
  }
}

Future setMessage(m) async {
  _messages = m;
}

Color getColor(type) {
  if (type == 'Important') {
    return Colors.green;
  } else {
    return Colors.red;
  }
}

// ignore: must_be_immutable
class Home extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  var hamMessages;
  // ignore: prefer_typing_uninitialized_variables
  var spamMessages;
  Home(this.hamMessages, this.spamMessages, {Key? key}) : super(key: key);
  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() => HomeState(hamMessages, spamMessages);
}

// ignore: must_be_immutable
class HomeState extends State<Home> {
  // ignore: prefer_typing_uninitialized_variables
  var hamMessages;
  // ignore: prefer_typing_uninitialized_variables
  var spamMessages;
  HomeState(this.hamMessages, this.spamMessages) {
    setMessage(hamMessages);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DisplayMessages(),
    );
  }
}

// ignore: must_be_immutable
class DisplayMessages extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  DisplayMessages({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => DisplayMessagesState();
}

class DisplayMessagesState extends State<DisplayMessages> {
  var change = false;
  // ignore: prefer_typing_uninitialized_variables
  DisplayMessagesState();

  final String header = "SMS Prism";
  static const String backgroundImagePath = "ImageAssets/SMS_background.jpg";
  String messageText = "";
  String sender = "";

  String finalMessageText = "";
  String finalSender = "";
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _senderController = TextEditingController();
  void showAlert(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enter new Message Sender and content'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      sender = value;
                    },
                    controller: _senderController,
                    decoration: const InputDecoration(hintText: "Sender"),
                  ),
                  TextField(
                    onChanged: (value) {
                      messageText = value;
                    },
                    controller: _textFieldController,
                    decoration:
                        const InputDecoration(hintText: "Message Content"),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    // setState(() {
                    _textFieldController.clear();
                    _senderController.clear();
                    Navigator.pop(context);
                    // });
                  },
                  child: const Text('CANCEL')),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      finalMessageText = messageText;
                      finalSender = sender;
                      if (finalMessageText.isNotEmpty &&
                          finalSender.isNotEmpty) {
                        var type = categorize(finalMessageText);
                        type.then((val) async {
                          await sort({
                            "s": finalSender,
                            'c': finalMessageText,
                            'type': val.toString().trim()
                          });
                          setState(() {
                            change = true;
                          });
                        });
                      }
                      _textFieldController.clear();
                      _senderController.clear();
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(header),
          backgroundColor: Colors.blue[800],
        ),
        drawer: const DrawerSection(),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => showAlert(context),
        ),
        body: Stack(children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage(backgroundImagePath),
              fit: BoxFit.cover,
            )),
          ),
          MessageList(),
        ]));
  }
}

// ignore: must_be_immutable
class MessageList extends StatelessWidget {
  var change = false;

  MessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.all(10.0),
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Text(
                      _messages[index]["s"].toString() +
                          " || " +
                          _messages[index]['type'].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: getColor(colorSelector)),
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
                Text(
                  _messages[index]["c"].toString(),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 2,
            ),
        itemCount: _messages.length);
  }
}

class DrawerSection extends StatelessWidget {
  static const listColor = Color.fromRGBO(170, 178, 232, 0.8);
  const DrawerSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      width: 200,
      child: Drawer(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(color: listColor),
            ),
            ListView(
              children: <Widget>[
                TextButton(
                    onPressed: () {
                      setMessage(hamMessages);
                      colorSelector = "Important";
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisplayMessages()));
                    },
                    child: const Text('Important Messages')),
                TextButton(
                  onPressed: () {
                    setMessage(spamMessages);
                    colorSelector = "Spam";
                    Navigator.of(context).pop();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DisplayMessages()));
                  },
                  child: const Text('Spam/Advertising'),
                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
