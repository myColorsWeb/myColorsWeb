import 'package:flutter/material.dart';
import 'package:my_colors_web/api_service.dart';
import 'dart:math';

import 'package:my_colors_web/my_color.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'myColorsWeb',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'myColorsWeb'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _colorController = TextEditingController();
  final _countController = TextEditingController();

  Future<List<MyColor>> myColors = Future<List<MyColor>>.value([]);

  @override
  void initState() {
    super.initState();
    myColors = getColors("Random", "5");
  }

  SizedBox _textField(
      {required String hintText, required TextEditingController controller}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 7,
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

  Padding configColorGrid(List<MyColor> colors) {
    return Padding(
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
              return InkWell(
                onTap: () {
                  print(index);
                },
                child: Container(
                  width: 15,
                  height: 15,
                  decoration:
                      BoxDecoration(color: _getColorFromHex(colors[index].hex)),
                  child: Center(
                      child: Text(
                    colors[index].hex,
                    style: const TextStyle(color: Colors.white),
                  )),
                ),
              );
            }));
  }

  Color? _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.title),
              const SizedBox(width: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _textField(hintText: "Color", controller: _colorController),
                  const SizedBox(width: 10),
                  _textField(hintText: "Count", controller: _countController),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            myColors = getColors(
                                _colorController.text, _countController.text);
                          });
                        },
                        child: const Text("Search")),
                  )
                ],
              )
            ],
          ),
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text("Random"),
                ),
                const PopupMenuItem<int>(
                  value: 1,
                  child: Text("Favorites"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Info"),
                ),
                const PopupMenuItem<int>(
                  value: 2,
                  child: Text("Sign Out"),
                ),
              ];
            }, onSelected: (value) {
              switch (value) {
                case 0 /*Random*/ :
                  setState(() {
                    var random = "Random";
                    var randIntStr = Random().nextInt(51).toString();
                    _colorController.text = random;
                    _countController.text = randIntStr;
                    myColors = getColors(random, randIntStr);
                  });
                  break;
                case 1 /*Favorites*/ :
                  break;
                case 2 /*Info*/ :
                  break;
                case 3 /*SIgn Out*/ :
                  break;
              }
            }),
          ],
        ),
        body: FutureBuilder<List<MyColor>>(
          future: myColors,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data!.toString());
              return configColorGrid(snapshot.data!);
            } else if (snapshot.hasError) {
              print('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ));
  }
}
