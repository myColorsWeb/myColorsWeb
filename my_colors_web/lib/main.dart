import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'data/local/my_color.dart';
import 'firebase/firebase_options.dart';
import 'pages/home_page.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    logAppOpen();
  }

  void logAppOpen() async => await FirebaseAnalytics.instance.logAppOpen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'myColorsWeb',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: MyColor.blueishIdk, secondary: Colors.grey[900]),
      ),
      home: const MyHomePage(title: 'myColorsWeb'),
    );
  }
}
