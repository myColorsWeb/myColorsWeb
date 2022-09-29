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
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return RawScrollbar(
      thumbColor: MyColor.blueishIdk,
      controller: controller,
      thumbVisibility: true,
      trackVisibility: true,
      child: PageView(
        controller: controller,
        scrollDirection: Axis.vertical,
        children: const [SignUpPage(), SignInPage()],
      ),
    );
  }
}
