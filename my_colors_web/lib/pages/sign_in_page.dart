import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_colors_web/data/local/my_color.dart';
import 'package:my_colors_web/firebase/fire_auth.dart';
import 'package:my_colors_web/pages/home_page.dart';
import 'package:my_colors_web/utils/utils.dart';

import '../utils/validator.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final _forgotPassFormKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _resetPassController = TextEditingController();

  var _isPasswordObscured = true;

  void _showPasswordResetDialog() {
    showDialogPlus(
        context: context,
        title: Text("Forgot Password",
            style: TextStyle(color: MyColor.blueishIdk)),
        content: Form(
          key: _forgotPassFormKey,
          child: Column(
            children: [
              Text("A link to reset your password will be sent to:",
                  style: TextStyle(color: MyColor.blueishIdk)),
              textField(
                  context: context,
                  hintText: "Enter email",
                  controller: _resetPassController,
                  onFieldSubmitted: null,
                  validator: (s) => Validator.validateEmail(s),
                  width: authTextFieldWidth(context),
                  color: MyColor.blueishIdk!),
              const SizedBox(height: 30),
              Text("Please check your spam folder",
                  style: TextStyle(color: MyColor.blueishIdk))
            ],
          ),
        ),
        onSubmitTap: () {
          if (_forgotPassFormKey.currentState!.validate()) {
            FireAuth.sendResetPasswordLink(email: _resetPassController.text);
            _resetPassController.clear();
            Navigator.pop(context);
          }
        },
        onCancelTap: () {
          _resetPassController.clear();
          Navigator.pop(context);
        },
        submitText: "Send!",
        cancelText: "Cancel");
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _resetPassController.dispose();
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
                    Text("to access your Favorite colors",
                        style:
                            TextStyle(color: MyColor.blueishIdk, fontSize: 14)),
                    const SizedBox(height: 40),
                    textField(
                        context: context,
                        hintText: "Email",
                        controller: _emailController,
                        onFieldSubmitted: (s) {},
                        validator: (s) => Validator.validateEmail(s),
                        width: authTextFieldWidth(context),
                        color: MyColor.blueishIdk!),
                    const SizedBox(height: 20),
                    textField(
                      context: context,
                      hintText: "Password",
                      controller: _passwordController,
                      maxLen: 20,
                      onFieldSubmitted: (s) {},
                      validator: (s) => Validator.validatePassword(s,
                          showValidPassMsg: false),
                      width: authTextFieldWidth(context),
                      color: MyColor.blueishIdk!,
                      obscureText: _isPasswordObscured,
                      includeSuffixIcon: true,
                      suffixIcon: InkWell(
                        onTap: () => setState(() {
                          _isPasswordObscured = !_isPasswordObscured;
                        }),
                        child: Icon(
                            _isPasswordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: MyColor.blueishIdk),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Column(
                      children: [
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  var user =
                                      await FireAuth.signInUsingEmailPassword(
                                          email: _emailController.text
                                              .toLowerCase(),
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
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () => _showPasswordResetDialog(),
                            child: const Text("Forgot Password?"))
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
