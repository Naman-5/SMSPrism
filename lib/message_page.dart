import 'package:flutter/material.dart';
import 'main.dart';

class DisplayMessages extends StatelessWidget {
  final String header = "SMS Prism";
  static const String backgroundImagePath = "ImageAssets/SMS_background.jpg";

  const DisplayMessages({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text(header),
        backgroundColor: Colors.blue[800],
      ),
      drawer: const DrawerSection(),
      body: Stack(
        children: <Widget>[
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
          // ignore: prefer_const_constructors
          // Text("Hello"),
          const MessageList(),
        ],
      ),
    ));
  }
}

class MessageList extends StatelessWidget {
  const MessageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 100,
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Text(messages[index]["s"].toString())
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => const SizedBox(
              height: 2,
            ),
        itemCount: messages.length);
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
              children: const <Widget>[
                ListTile(
                  title: Text("Important"),
                ),
                ListTile(
                  title: Text("Spam/Advertising"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
