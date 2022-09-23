import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

SizedBox textField(
    {required String hintText,
    required TextEditingController controller,
    required double width}) {
  return SizedBox(
    width: width,
    child: TextFormField(
        controller: controller,
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
            child: Text(submitText, style: const TextStyle(color: Colors.blue)),
          ),
      ],
    ),
  );
}

void toast(String msg) {
  Fluttertoast.showToast(msg: msg, toastLength: Toast.LENGTH_LONG);
}
