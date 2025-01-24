import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/navbar.dart';
import 'package:flutter_application_1/widgets/drawer.dart';
import 'package:flutter_application_1/widgets/screen_home/sign_to_Text.dart';
import 'package:flutter_application_1/widgets/screen_home/text_to_Sign.dart';
import 'package:flutter_application_1/widgets/screen_home/selection-bar.dart';

class Home extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home> {
  bool isReversed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void toggleLayout() {
    setState(() {
      isReversed = !isReversed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue[700],
        appBar: Navbar(
          title: "Traductor",
          searchBar: false,
        ),
        drawer: MaterialDrawer(currentPage: "Home"),
        body: Column(
          children: [
            SelectionBar(toggleLayout: toggleLayout, isReversed: isReversed),
            SizedBox(height: 1.0),
            Expanded(
              child: isReversed ? TextToSign() : SignToText(),
            ),
          ],
        ));
  }
}
