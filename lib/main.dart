import 'package:flutter/material.dart';
import 'package:sms_prism/layouts/onboarding_screen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'message_page.dart';

const messages = [
  {"s": "Sender", "c": "Content"},
  {"s": "Sender", "c": "Content"},
  {"s": "Sender", "c": "Content"},
  {"s": "Sender", "c": "Content"},
  {"s": "Sender", "c": "Content"},
];
void main() async {
  await Hive.initFlutter();
  await Hive.openBox('T&C');
  if (Hive.box('T&C').isEmpty) {
    runApp(const MaterialApp(
      home: OnboardingScreen(),
    ));
  } else {
    runApp(const DisplayMessages());
  }
}
