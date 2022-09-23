import 'package:flutter/material.dart';

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
