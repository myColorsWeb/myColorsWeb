import 'package:firebase_auth/firebase_auth.dart';
import '../data/local/my_color.dart';
import '../pages/sign_up_page.dart';
import 'sign_in_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final controller = PageController(initialPage: 1);

  final _isSignedIn = FirebaseAuth.instance.currentUser != null;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, _isSignedIn);
        return Future.value(false);
      },
      child: RawScrollbar(
        thumbColor: MyColor.blueishIdk,
        controller: controller,
        thumbVisibility: true,
        trackVisibility: true,
        child: Scaffold(
          body: PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            children: [
              SignUpPage(
                  onNavigate: () => controller.animateToPage(1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeIn)),
              SignInPage(
                  onNavigate: () => controller.animateToPage(0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut))
            ],
          ),
        ),
      ),
    );
  }
}
