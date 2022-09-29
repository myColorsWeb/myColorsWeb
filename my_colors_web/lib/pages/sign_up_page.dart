import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_colors_web/data/local/my_color.dart';
import 'package:my_colors_web/utils/utils.dart';
import 'package:lottie/lottie.dart';

import '../firebase/fire_auth.dart';
import 'home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cPasswordController = TextEditingController();

  void showEmailVerificationDialog() {
    final email = _emailController.text;
    showDialogPlus(
        context: context,
        title: Text("Verify Your Email",
            style: TextStyle(color: MyColor.blueishIdk)),
        content: Text(
            "A verification email has been sent to <$email>. Please verify your email. Be sure to check your spam folder.",
            style: TextStyle(color: MyColor.blueishIdk)),
        onSubmitTap: () {
          Navigator.pop(context);
        },
        onCancelTap: () {
          FireAuth.reSendEmailVerification();
          Navigator.pop(context);
        },
        submitText: "Nice!",
        cancelText: "Re-Send");
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sign Up",
                        style:
                            TextStyle(color: MyColor.blueishIdk, fontSize: 30)),
                    const SizedBox(height: 15),
                    Text("Access your Favs via\nmyColors for Android",
                        style:
                            TextStyle(color: MyColor.blueishIdk, fontSize: 14)),
                    const SizedBox(height: 40),
                    textField(
                        context: context,
                        hintText: "Email",
                        controller: _emailController,
                        onFieldSubmitted: (s) {},
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            return "Please provide a value";
                          }
                          return null;
                        },
                        width: MediaQuery.of(context).size.width / 2,
                        color: MyColor.blueishIdk!),
                    const SizedBox(height: 20),
                    textField(
                        context: context,
                        hintText: "Password",
                        controller: _passwordController,
                        maxLen: 20,
                        onFieldSubmitted: (s) {},
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            return "Please provide a value";
                          }
                          return null;
                        },
                        width: MediaQuery.of(context).size.width / 2,
                        color: MyColor.blueishIdk!),
                    const SizedBox(height: 20),
                    textField(
                        context: context,
                        hintText: "Confirm Password",
                        controller: _cPasswordController,
                        maxLen: 20,
                        onFieldSubmitted: (s) {},
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            return "Please provide a value";
                          }
                          return null;
                        },
                        width: MediaQuery.of(context).size.width / 2,
                        color: MyColor.blueishIdk!),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                          onPressed: () async {
                            showEmailVerificationDialog();
                            if (_formKey.currentState!.validate()) {
                              var user =
                                  await FireAuth.registerUsingEmailPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      onResend: (() {
                                        Navigator.pop(context);
                                        showEmailVerificationDialog();
                                      }));
                              if (user != null && mounted) {
                                if (user.emailVerified) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyHomePage(
                                                  title: "myColorsWeb")),
                                      (Route<dynamic> route) => false);
                                } else {}
                              }
                            }
                          },
                          child: const Text("Sign Up")),
                    ),
                    if (MediaQuery.of(context).size.width >= 500)
                      Lottie.asset('arrow_down_lottie.json')
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
