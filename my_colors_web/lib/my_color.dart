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
}
