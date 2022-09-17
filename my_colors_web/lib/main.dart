import 'package:flutter/material.dart';
import 'dart:math';

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

  final List<Color> _colors = List.generate(
      15,
      (index) => Color.fromRGBO(Random().nextInt(359), Random().nextInt(359),
          Random().nextInt(359), 1)).toList();

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
                  _textField(
                      hintText: "Color", controller: _colorController),
                  const SizedBox(width: 10),
                  _textField(
                      hintText: "Count", controller: _countController),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          print("Search Pressed");
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
                case 0:
                  break;

                case 1:
                  break;

                case 2:
                  break;

                case 3:
                  break;
              }
            }),
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1 / .5,
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _colors.length,
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () {
                      print(index);
                    },
                    child: Container(
                      width: 15,
                      height: 15,
                      decoration:
                          BoxDecoration(color: Color(_colors[index].value)),
                      child: Center(
                          child: Text(
                        "${_colors[index]}",
                        style: const TextStyle(color: Colors.white),
                      )),
                    ),
                  );
                })));
  }
}
