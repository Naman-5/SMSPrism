import 'package:flutter/material.dart';
import 'package:sms_prism/layouts/onboarding_screen.dart';

const messages = [
  {"s": "Sender", "c": "Content"},
  {"s": "Sender", "c": "Content"},
  {"s": "Sender", "c": "Content"},
  {"s": "Sender", "c": "Content"},
  {"s": "Sender", "c": "Content"},
];
void main() {
  runApp(const MaterialApp(
    home: OnboardingScreen(),
  ));
}
