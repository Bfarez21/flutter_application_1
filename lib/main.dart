import 'package:flutter/material.dart';

// screens
import 'package:flutter_application_1/screens/home.dart';
import 'package:flutter_application_1/screens/profile.dart';
import 'package:flutter_application_1/screens/settings.dart';
import 'package:flutter_application_1/screens/components.dart';
import 'package:flutter_application_1/screens/onboarding.dart';
import 'package:flutter_application_1/screens/pro.dart';

void main() => runApp(MaterialKitPROFlutter());

class MaterialKitPROFlutter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Material Kit PRO Flutter",
        debugShowCheckedModeBanner: false,
        initialRoute: "/onboarding",
        routes: <String, WidgetBuilder>{
          "/onboarding": (BuildContext context) => new Onboarding(),
          "/pro": (BuildContext context) => new Pro(),
          "/home": (BuildContext context) => new Home(),
          "/components": (BuildContext context) => new Components(),
          "/profile": (BuildContext context) => new Profile(),
          "/settings": (BuildContext context) => new Settings(),
        });
        
  }
}
