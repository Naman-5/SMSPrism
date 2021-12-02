import 'package:flutter/material.dart';
import 'package:sms_prism/layouts/onboarding_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'message_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// the messages variable contains few messages for intial classification
var messages = [
  {
    "s": "Sender",
    "c":
        "The Secret OTP is 349239 for your txn of INR 1.0 at CODEDAMN on card ending 1712. Valid only for 3 minutes. Do not share the OTP with anyone :PPBL"
  },
  {
    "s": "Sender",
    "c":
        "Dear Customer: as promised free preventive maintenance service of Livpure RO is due with call ID JS-19121101424367 call closure code 58418 allocated for 2019-12-13 to Santanu Parida (2000050) East Delhi, 8800696468. Plz give an appointment when engineer call. Do not share closure code till service is done. Please call 18004199399 for any query ."
  },
  {
    "s": "Sender",
    "c":
        "Lenskart Black Friday Sale! Use code: BLACKFRI to get Rs 300 Off on 3000 in Sunglasses & Rs 500 Off on 5000 for Eyeglasses. TnC App lskt.me/b5 Store lskt.me/k5"
  },
  {
    "s": "Sender",
    "c":
        "Get 100% Scholarship on highest rated coding courses by Coding Ninjas.Learn C++, Java, Python, Web Dev & Data Science/ML from IIT & Stanford Alumni. Use code CODING50 to get 50% off. Hurry: https://bit.ly/3cmrYBK"
  },
  {
    "s": "Sender",
    "c":
        "Recharge in advance and save 20% today. Your current plan validity is not lost. Valid only till 30th Nov. Recharge now www.jio.com/r/rRTOjOwMo"
  },
  {
    "s": "Sender",
    "c":
        "Time to invest in Bitcoin! Choose CoinDCX, trusted by 40lac Indians. Get free Bitcoin worth INR 100. Use code: COINDCX Click - http://1kx.in/gzGyuK CCDEMT"
  },
  {
    "s": "Sender",
    "c":
        "Today only! Get free shipping on your order, no minimum required. Shop now: ADD URL"
  }
];
var hamMessages =
    []; // All important messages and alerts are seperated to the hamMessages variable
var spamMessages =
    []; // All spam, fradulent and unimportant messages are seperated to the spamMessages variable

// classifying message content by sending the content to the model hosted on
// local host using flask
Future<void> categorize() async {
  var url = Uri.parse('http://127.0.0.1:5000/predict');

  for (var i in messages) {
    try {
      var response =
          await http.post(url, body: json.encode({'key': '${i['c']}'}));
      i['type'] = json.decode(response.body);
    } on Exception {}
  }
}

// sorting messages using the label received from the model
Future<void> sort() async {
  for (var i in messages) {
    if (i['type'].toString().trim() == "Advertising" ||
        i['type'].toString().trim() == "Spam" ||
        i['type'].toString().trim() == 'Malicious' ||
        i['type'].toString().trim() == 'Fradulent') {
      spamMessages.add({"s": i['s'], "c": i['c'], 'type': i['type']});
    } else {
      hamMessages.add({"s": i['s'], "c": i['c'], 'type': i['type']});
    }
  }
}

void main() async {
  await categorize();
  await sort();
  await Hive.initFlutter();
  await Hive.openBox('T&C');
  if (Hive.box('T&C').isEmpty) {
    runApp(const MaterialApp(
      home: OnboardingScreen(),
    ));
  } else {
    runApp(Home(hamMessages, spamMessages));
  }
}
