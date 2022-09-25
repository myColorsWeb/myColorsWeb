import 'dart:ui';

class MyColor {
  final String hex;

  const MyColor({required this.hex});

  factory MyColor.fromJson(Map<String, dynamic> json) =>
      MyColor(hex: json['hex']);

  static Color? blueishIdk = getColorFromHex("#53a99a");

  static Color? getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return null;
  }
}
