import 'package:flutter/material.dart';
import 'package:my_colors_web/utils/utils.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Sign Up",
                style: TextStyle(color: Colors.white, fontSize: 30)),
            const SizedBox(height: 20),
            textField(
                context: context,
                hintText: "Email",
                controller: _emailController,
                onFieldSubmitted: (s) {},
                validator: (s) {
                  return null;
                },
                width: MediaQuery.of(context).size.width / 3.5),
            const SizedBox(height: 20),
            textField(
                context: context,
                hintText: "Password",
                controller: _passwordController,
                onFieldSubmitted: (s) {},
                validator: (s) {
                  return null;
                },
                width: MediaQuery.of(context).size.width / 3.5)
          ]),
        ),
      ),
    );
  }
}
