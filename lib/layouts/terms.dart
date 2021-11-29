import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sms_prism/res/terms_list.dart';
import 'package:sms_prism/message_page.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  _TermsScreenState createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final List<Widget> _termsList = terms
      .map((term) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Text('\u2022  $term',
              style: TextStyle(
                  color: Colors.grey[500],
                  letterSpacing: 1.01,
                  fontWeight: FontWeight.w500))))
      .toList();

  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: const EdgeInsets.only(top: 40),
            child: SvgPicture.asset(
              'assets/images/undraw_terms.svg',
              fit: BoxFit.fitWidth,
              width: 220.0,
              alignment: Alignment.bottomCenter,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 40, bottom: 20),
          child: Text('Terms & Conditions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              )),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _termsList,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: Row(
            children: [
              Checkbox(
                  value: _isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      _isChecked = value!;
                    });
                  }),
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  'I Agree to the above mentioned Terms and Conditions.',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            ],
          ),
        ),
        if (_isChecked)
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Colors.indigo[300], shape: const StadiumBorder()),
                onPressed: () {
                  Box db = Hive.box('T&C');
                  db.put('Accepted', 1);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const DisplayMessages()));
                },
                child: Row(
                  children: const [
                    Text(
                      'Continue',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    Icon(Icons.navigate_next_rounded)
                  ],
                ),
              ),
            ),
          ]),
      ],
    )));
  }
}
