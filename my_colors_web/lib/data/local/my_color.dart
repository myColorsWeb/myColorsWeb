import 'dart:ui';

class MyColor {
  final String hex;
  final String hsl;
  final String rgb;

  const MyColor({
    required this.hex,
    required this.hsl,
    required this.rgb,
  });

  factory MyColor.fromJson(Map<String, dynamic> json) {
    return MyColor(
      hex: json['hex'],
      hsl: json['hsl'],
      rgb: json['rgb'],
    );
  }

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
