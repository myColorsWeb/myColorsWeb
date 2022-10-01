import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/local/my_color.dart';

SizedBox textField(
    {required BuildContext context,
    required String hintText,
    required TextEditingController controller,
    required void Function(String)? onFieldSubmitted,
    required String? Function(String?)? validator,
    TextInputType? keyboardType = TextInputType.text,
    required double width,
    required Color color,
    bool obscureText = false,
    bool includeSuffixIcon = false,
    Widget? suffixIcon,
    int maxLen = 40}) {
  return SizedBox(
    width: width,
    child: Theme(
      data: Theme.of(context).copyWith(
          textSelectionTheme:
              const TextSelectionThemeData(selectionColor: Colors.grey)),
      child: TextFormField(
          maxLength: maxLen,
          onFieldSubmitted: onFieldSubmitted,
          controller: controller,
          textInputAction: TextInputAction.done,
          validator: validator,
          style: TextStyle(color: color),
          keyboardType: keyboardType,
          cursorColor: color,
          obscureText: obscureText,
          obscuringCharacter: "!",
          decoration: InputDecoration(
              suffixIcon: includeSuffixIcon ? suffixIcon : null,
              counterText: "",
              counterStyle: TextStyle(color: MyColor.blueishIdk),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: color,
                width: 2,
              )),
              hintText: hintText,
              hintStyle: TextStyle(color: color))),
    ),
  );
}

void showDialogPlus({
  required BuildContext context,
  required Widget title,
  required Widget content,
  required Function()? onSubmitTap,
  required Function()? onCancelTap,
  required String submitText,
  required String cancelText,
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: Colors.grey[900],
      title: title,
      content:
          SingleChildScrollView(scrollDirection: Axis.vertical, child: content),
      actions: <Widget>[
        if (onCancelTap != null)
          TextButton(
            onPressed: () => onCancelTap(),
            child:
                Text(cancelText, style: TextStyle(color: MyColor.blueishIdk)),
          ),
        if (onSubmitTap != null)
          TextButton(
            onPressed: () => onSubmitTap(),
            child:
                Text(submitText, style: TextStyle(color: MyColor.blueishIdk)),
          ),
      ],
    ),
  );
}

void makeToast(String msg) {
  Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
}

SizedBox animatedText(BuildContext context, String text,
    {void Function()? onTap}) {
  List<Color> colorizeColors = [
    Colors.white,
    Colors.white,
    Colors.green,
    Colors.pink,
    Colors.blue,
  ];
  const colorizeTextStyle = TextStyle(fontSize: 20);
  return SizedBox(
    child: AnimatedTextKit(
      onTap: () => onTap,
      animatedTexts: [
        ColorizeAnimatedText(text,
            textStyle: colorizeTextStyle,
            colors: colorizeColors,
            textAlign: TextAlign.center),
      ],
      isRepeatingAnimation: false,
    ),
  );
}

Widget animatedColorsGrid(List<MyColor> colors, int index, Widget child) {
  return AnimationConfiguration.staggeredList(
    position: index,
    duration: const Duration(milliseconds: 777),
    child: child,
  );
}

bool isScreenWidth500Above(BuildContext context) =>
    MediaQuery.of(context).size.width >= 500;

double authTextFieldWidth(BuildContext context) =>
    MediaQuery.of(context).size.width / 2;
