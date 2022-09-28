import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data/local/my_color.dart';

SizedBox textField(
    {required String hintText,
    required TextEditingController controller,
    required TextInputAction? textInputAction,
    required void Function(String)? onFieldSubmitted,
    required String? Function(String?)? validator,
    required double width}) {
  return SizedBox(
    width: width,
    child: TextFormField(
        onFieldSubmitted: onFieldSubmitted,
        controller: controller,
        textInputAction: textInputAction,
        validator: validator,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(
              color: Colors.white,
              width: 2,
            )),
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.white))),
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
                Text(cancelText, style: const TextStyle(color: Colors.black)),
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

Padding colorsGrid(
        {required List<MyColor?> colors,
        required void Function()? onDoubleTap,
        required void Function()? onLongPress}) =>
    Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1 / .5,
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: colors.length,
            itemBuilder: (_, index) {
              String hex = colors[index]!.hex;
              return InkWell(
                onDoubleTap: onDoubleTap,
                onLongPress: onLongPress,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration:
                      BoxDecoration(color: MyColor.getColorFromHex(hex)),
                  child: Center(
                      child: Text(
                    hex,
                    style: const TextStyle(color: Colors.white),
                  )),
                ),
              );
            }));
