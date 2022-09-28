import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../data/remote/api_service.dart';
import 'favorites_page.dart';
import '../firebase/fire_auth.dart';
import 'dart:math';

import '../data/local/my_color.dart';
import 'package:flutter/services.dart';

import '../firebase/firestore.dart';
import '../utils/utils.dart';

import 'package:animated_text_kit/animated_text_kit.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _colorController = TextEditingController();
  final _countController = TextEditingController();

  var random = "Random";
  var randIntStr = "5";

  var isSignedIn = FirebaseAuth.instance.currentUser != null;

  final _formKey = GlobalKey<FormState>();

  final additionalInfo = [
    "RED",
    "PINK",
    "PURPLE",
    "NAVY",
    "BLUE",
    "AQUA",
    "GREEN",
    "LIME",
    "YELLOW",
    "ORANGE",
    "RANDOM",
    "\n* Double-Click to Copy\n* Long-Press to Save"
  ];

  Future<List<MyColor>> myColors = Future<List<MyColor>>.value([]);

  @override
  void initState() {
    super.initState();
    myColors = getColors(random, randIntStr);
  }

  @override
  void dispose() {
    super.dispose();
    _colorController.dispose();
    _countController.dispose();
  }

  Padding colorsGrid(List<MyColor> colors) {
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
              String hex = colors[index].hex;
              return InkWell(
                onDoubleTap: () {
                  Clipboard.setData(ClipboardData(text: hex));
                  makeToast("Copied $hex to Clipboard");
                },
                onLongPress: () {
                  FireStore.updateFavorites({hex: hex});
                  makeToast("Saved $hex to Favorites");
                },
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
  }

  void search() {
    setState(() {
      myColors =
          getColors(_colorController.text.toLowerCase(), _countController.text);
    });
  }

  void showInfo() {
    showDialogPlus(
        context: context,
        title: Text("Colors to Search",
            style: TextStyle(color: MyColor.blueishIdk)),
        content: Text(additionalInfo.join("\n"),
            style: TextStyle(color: MyColor.blueishIdk)),
        onSubmitTap: () => Navigator.pop(context),
        onCancelTap: null,
        submitText: "OK",
        cancelText: "");
  }

  SizedBox _myColorsAnimated(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 10,
      child: TextLiquidFill(
        loadDuration: const Duration(milliseconds: 1000),
        waveDuration: const Duration(milliseconds: 750),
        text: 'myColorsWeb',
        waveColor: Colors.white,
        boxBackgroundColor: MyColor.blueishIdk!,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  SizedBox _colorizeAnimate(BuildContext context, String text) {
    List<Color> colorizeColors = [
      Colors.white,
      Colors.white,
      Colors.green,
      Colors.pink,
      Colors.blue,
    ];
    const colorizeTextStyle = TextStyle(fontSize: 20);
    return SizedBox(
      child: AnimatedTextKit(
        animatedTexts: [
          ColorizeAnimatedText(text,
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
              textAlign: TextAlign.center),
        ],
        isRepeatingAnimation: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _colorizeAnimate(context, "myColorsWeb"),
              const SizedBox(width: 20),
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    textField(
                        context: context,
                        width: MediaQuery.of(context).size.width / 5,
                        hintText: "Color",
                        controller: _colorController,
                        textInputAction: TextInputAction.done,
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            return "";
                          } else if (!additionalInfo
                              .contains(s.toUpperCase())) {
                            makeToast("Please enter a valid color");
                            showInfo();
                            return "";
                          }
                          return null;
                        },
                        onFieldSubmitted: (s) {
                          if (_formKey.currentState!.validate()) {
                            search();
                          }
                        }),
                    const SizedBox(width: 15),
                    textField(
                        context: context,
                        width: MediaQuery.of(context).size.width / 10,
                        hintText: "#",
                        controller: _countController,
                        textInputAction: TextInputAction.done,
                        validator: (s) {
                          if (s == null || s.isEmpty) {
                            makeToast("Please provide a count");
                            return "";
                          } else if (int.tryParse(s) == null) {
                            makeToast("Numbers only");
                            return "";
                          } else {
                            if (int.parse(s) < 2) {
                              _countController.text = "2";
                            } else if (int.parse(s) > 51) {
                              _countController.text = "51";
                            }
                          }
                          return null;
                        },
                        onFieldSubmitted: (s) {
                          if (_formKey.currentState!.validate()) {
                            search();
                          }
                        })
                  ],
                ),
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
                PopupMenuItem<int>(
                  value: 3,
                  child: isSignedIn
                      ? const Text("Sign Out")
                      : const Text("Sign In"),
                ),
              ];
            }, onSelected: (value) {
              switch (value) {
                case 0 /*Random*/ :
                  setState(() {
                    randIntStr = Random().nextInt(51).toString();
                    _colorController.text = random;
                    _countController.text = randIntStr;
                    myColors = getColors(random, randIntStr);
                  });
                  break;
                case 1 /*Favorites*/ :
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Favorites()));
                  break;
                case 2 /*Info*/ :
                  showInfo();
                  break;
                case 3 /*Sign Out*/ :
                  if (isSignedIn) {
                    FireAuth.signOut();
                    setState(() {
                      isSignedIn = false;
                    });
                  } else {
                    setState(() {
                      isSignedIn = true;
                    });
                    // TODO - Launch Sign Up / In page
                  }
                  break;
              }
            }),
          ],
        ),
        body: FutureBuilder<List<MyColor>>(
          future: myColors,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return colorsGrid(snapshot.data!);
            } else if (snapshot.hasError) {
              return Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 60, color: Colors.white),
                  const SizedBox(height: 20),
                  const Text(
                      "Something went wrong. Reload the page and please try again.",
                      style: TextStyle(color: Colors.white, fontSize: 25)),
                  const SizedBox(height: 10),
                  Text("Error: ${snapshot.error}",
                      style: const TextStyle(color: Colors.white, fontSize: 15))
                ],
              ));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: MyColor.blueishIdk,
          onPressed: () {
            FocusManager.instance.primaryFocus?.unfocus();
            if (_formKey.currentState!.validate()) {
              search();
            }
          },
          child: const Icon(Icons.search),
        ),
      ),
    );
  }
}
