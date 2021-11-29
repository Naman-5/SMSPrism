import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sms_prism/res/onboarding_screen_items.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  double? currentPage = 0;
  final _pageViewController = PageController();

  late final List<Widget> _pages;

  _OnboardingScreenState() {
    _pages = _getPages();
  }

  List<Widget> _getIndicator() => List<Widget>.generate(
      _pages.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: currentPage?.round() == index
                    ? Colors.indigo[600]
                    : Colors.indigo[600]?.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));

  List<Widget> _getPages() {
    return items
        .map((item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: SvgPicture.asset(
                    item['image'],
                    fit: BoxFit.fitWidth,
                    width: 290.0,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(children: [
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          item['header'],
                          style: const TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.w400,
                              fontSize: 35.0,
                              height: 2.0),
                        ),
                        Text(
                          item['description'],
                          style: TextStyle(
                              color: Colors.indigo[400],
                              fontSize: 15.0,
                              height: 1.2,
                              letterSpacing: 1.15),
                          textAlign: TextAlign.center,
                        )
                      ])),
                ),
              ]),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        margin: const EdgeInsets.only(top: 10.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0),
                    ),
                  )),
            ),
            PageView.builder(
                controller: _pageViewController,
                itemCount: _pages.length,
                itemBuilder: (BuildContext context, int index) {
                  _pageViewController.addListener(() {
                    setState(() {
                      currentPage = _pageViewController.page;
                    });
                  });
                  return _pages[index];
                }),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 70.0),
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _getIndicator(),
                  ),
                )),
            if (currentPage == 2)
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 30),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo[400],
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(15),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {},
                  ),
                ),
              )
          ],
        ),
      )),
    );
  }
}
