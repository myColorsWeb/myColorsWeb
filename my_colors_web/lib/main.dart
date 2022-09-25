import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_colors_web/data/local/my_color.dart';

import 'firebase/firebase_options.dart';
import 'pages/home_page.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'myColorsWeb',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: MyColor.getColorFromHex("#53a99a"),
            secondary: Colors.grey[900]),
      ),
      home: const MyHomePage(title: 'myColorsWeb'),
    );
  }
}
