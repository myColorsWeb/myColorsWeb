import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_colors_web/data/local/my_color.dart';
import 'package:my_colors_web/pages/sign_up_page.dart';

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
  var _isShowingSignIn = true;

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
          floatingActionButton: FloatingActionButton(
              backgroundColor: MyColor.blueishIdk,
              onPressed: () => setState(() {
                    if (_isShowingSignIn) {
                      controller.animateToPage(0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut);
                      _isShowingSignIn = false;
                    } else {
                      controller.animateToPage(1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn);
                      _isShowingSignIn = true;
                    }
                  }),
              child: _isShowingSignIn
                  ? const Icon(Icons.arrow_drop_up)
                  : const Icon(Icons.arrow_drop_down)),
          body: PageView(
            controller: controller,
            scrollDirection: Axis.vertical,
            children: const [SignUpPage(), SignInPage()],
          ),
        ),
      ),
    );
  }
}
