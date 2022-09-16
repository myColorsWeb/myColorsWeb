import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
  final _colorTextField = const TextField(
    decoration: InputDecoration(
        hintText: 'Color | Hue',
        hintStyle: TextStyle(color: Colors.grey)),
  );

  final _numOfColorsTextField = TextFormField(
      decoration: const InputDecoration(
          hintText: 'Number of Colors',
          hintStyle: TextStyle(color: Colors.grey)));

  SizedBox _colorTextInput() =>
      _textFieldContainer(textFormField: _colorTextField);

  SizedBox _numOfColorsInput() =>
      _textFieldContainer(textFormField: _numOfColorsTextField);

  SizedBox _textFieldContainer({required Widget textFormField}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 8,
      child: textFormField,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title),
              const SizedBox(width: 20),
              ElevatedButton(onPressed: () {}, child: const Text("Random")),
              const SizedBox(width: 20),
              ElevatedButton(onPressed: () {}, child: const Icon(Icons.info)),
              const SizedBox(width: 20),
              ElevatedButton(
                  onPressed: () {}, child: const Icon(Icons.favorite)),
              const SizedBox(width: 20),
            ],
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(width: 15),
                _colorTextInput(),
                const SizedBox(width: 20),
                _numOfColorsInput(),
                const SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ElevatedButton(
                      onPressed: () {}, child: const Text("Search")),
                )
              ],
            ),
          ],
        ));
  }
}
