import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../data/local/my_color.dart';
import '../utils/utils.dart';
import 'package:lottie/lottie.dart';
import '../utils/validator.dart';

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

  var _isPasswordObscured = true;
  var _isCpasswordObscured = true;

  void showEmailVerificationDialog() {
    final email = _emailController.text;
    showDialogPlus(
        context: context,
        title: Text("Verify Your Email",
            style: TextStyle(color: MyColor.blueishIdk)),
        content: Text(
            "A verification email has been sent to <$email>."
            "Please verify your email. Be sure to check your spam folder.",
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

  void showPasswordDialog() {
    showDialogPlus(
        context: context,
        title: Text("Password Requirements",
            style: TextStyle(color: MyColor.blueishIdk)),
        content: Text(Validator.passwordSpecifications,
            style: TextStyle(color: MyColor.blueishIdk)),
        onSubmitTap: () {
          Navigator.pop(context);
        },
        onCancelTap: null,
        submitText: "Nice!",
        cancelText: "");
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
                    Text("to save your Favorite colors",
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
                      validator: (s) => Validator.validatePassword(s),
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
                    const SizedBox(height: 20),
                    textField(
                        context: context,
                        hintText: "Confirm Password",
                        controller: _cPasswordController,
                        maxLen: 20,
                        onFieldSubmitted: (s) {},
                        validator: (s) {
                          if (_passwordController.text != s) {
                            return "Passwords don't match";
                          }
                          return Validator.validatePassword(s);
                        },
                        width: authTextFieldWidth(context),
                        color: MyColor.blueishIdk!,
                        obscureText: _isCpasswordObscured,
                        includeSuffixIcon: true,
                        suffixIcon: InkWell(
                          onTap: () => setState(() {
                            _isCpasswordObscured = !_isCpasswordObscured;
                          }),
                          child: Icon(
                              _isCpasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: MyColor.blueishIdk),
                        )),
                    const SizedBox(height: 40),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2.5,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  showEmailVerificationDialog();
                                  var user =
                                      await FireAuth.registerUsingEmailPassword(
                                          email: _emailController.text.toLowerCase(),
                                          password: _passwordController.text,
                                          onResend: (() {
                                            Navigator.pop(context);
                                            showEmailVerificationDialog();
                                          }));
                                  if (user != null && user.emailVerified) {
                                    await FirebaseAnalytics.instance
                                        .logSignUp(signUpMethod: "email");
                                    if (mounted) {
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
                        const SizedBox(height: 10),
                        ElevatedButton(
                            onPressed: () => showPasswordDialog(),
                            child: const Text("Password Requirements"))
                      ],
                    ),
                    isScreenWidth500Above(context)
                        ? Lottie.asset('arrow_down_lottie.json')
                        : Lottie.asset('arrow_down_35.json'),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
