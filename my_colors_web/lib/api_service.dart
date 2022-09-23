import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_colors_web/my_color.dart';

Future<List<MyColor>> getColors(String color, String numOfColors) async {
  final response = await http.get(Uri.parse(
      'https://x-colors.herokuapp.com/api/random/$color?number=$numOfColors&type=dark'));
  if (response.statusCode == 200) {
    Iterable l = json.decode(response.body);
    List<MyColor> colors =
        List<MyColor>.from(l.map((model) => MyColor.fromJson(model)));
    return colors;
  } else {
    throw Exception('Error: ${response.statusCode}\nOutput: $response');
  }
}
