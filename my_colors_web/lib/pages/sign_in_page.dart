import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_colors_web/data/local/my_color.dart';
import 'package:my_colors_web/firebase/fire_auth.dart';
import 'package:my_colors_web/pages/home_page.dart';
import 'package:my_colors_web/utils/utils.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                    isScreenWidth500Above(context)
                        ? Lottie.asset('arrow_up_lottie.json')
                        : Lottie.asset('arrow_up_35.json'),
                    Text("Sign In",
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
                        width: authTextFieldWidth(context),
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
                        width: authTextFieldWidth(context),
                        color: MyColor.blueishIdk!),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              var user =
                                  await FireAuth.signInUsingEmailPassword(
                                      email: _emailController.text,
                                      password: _passwordController.text);
                              if (user != null) {
                                await FirebaseAnalytics.instance.logLogin();
                                if (mounted) {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyHomePage(
                                                  title: "myColorsWeb")),
                                      (Route<dynamic> route) => false);
                                }
                              }
                            }
                          },
                          child: const Text("Sign In")),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
