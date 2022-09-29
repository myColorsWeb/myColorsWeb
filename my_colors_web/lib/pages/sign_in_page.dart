import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:my_colors_web/data/local/my_color.dart';
import 'package:my_colors_web/utils/utils.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(width: 30),
              Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign In",
                          style: TextStyle(
                              color: MyColor.blueishIdk, fontSize: 30)),
                      const SizedBox(height: 15),
                      Text(
                          "Access your Favorites on your Android phone via myColors",
                          style: TextStyle(
                              color: MyColor.blueishIdk, fontSize: 14)),
                      const SizedBox(height: 77),
                      textField(
                          context: context,
                          hintText: "Email",
                          controller: _emailController,
                          onFieldSubmitted: (s) {},
                          validator: (s) {
                            return null;
                          },
                          width: MediaQuery.of(context).size.width / 3.5,
                          color: MyColor.blueishIdk!),
                      const SizedBox(height: 20),
                      textField(
                          context: context,
                          hintText: "Password",
                          controller: _passwordController,
                          onFieldSubmitted: (s) {},
                          validator: (s) {
                            return null;
                          },
                          width: MediaQuery.of(context).size.width / 3.5,
                          color: MyColor.blueishIdk!),
                      const SizedBox(height: 77),
                      ElevatedButton(
                          onPressed: () {}, child: const Text("Sign In"))
                    ]),
              ),
              const SizedBox(width: 100),
              Lottie.asset('arrow_up_lottie.json')
            ],
          ),
        ),
      ),
    );
  }
}
