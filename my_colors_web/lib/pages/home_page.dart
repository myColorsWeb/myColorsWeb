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

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _colorController = TextEditingController();
  final _countController = TextEditingController();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  var random = "Random";
  var randIntStr = "5";

  final additionalInfo = [
    "Colors to Search",
    "---------------------------",
    "Red",
    "Pink",
    "Purple",
    "Navy",
    "Blue",
    "Aqua",
    "Green",
    "Lime",
    "Yellow",
    "Orange",
    "Random",
    "\nHue Color Range: 0 - 359\n",
    "* Double-Click to Copy\n* Long-Press to Save"
  ];

  Future<List<MyColor>> myColors = Future<List<MyColor>>.value([]);

  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _colorController.text = random;
    _countController.text = randIntStr;
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
                  toast("Copied $hex to Clipboard");
                },
                onLongPress: () {
                  FireStore.updateFavorites({hex: hex});
                  toast("Saved $hex to Favorites");
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

  @override
  Widget build(BuildContext context) {
    var textFieldWidth = MediaQuery.of(context).size.width / 7;
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(widget.title),
              const SizedBox(width: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textField(
                      width: textFieldWidth,
                      hintText: "Color",
                      controller: _colorController),
                  const SizedBox(width: 10),
                  textField(
                      width: textFieldWidth,
                      hintText: "Count",
                      controller: _countController),
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            myColors = getColors(
                                _colorController.text.toLowerCase(),
                                _countController.text);
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
                PopupMenuItem<int>(
                  value: 3,
                  child: currentUser != null
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
                  showDialogPlus(
                      context: context,
                      title: const Text("Info"),
                      content: Text(additionalInfo.join("\n")),
                      onSubmitTap: () => Navigator.pop(context),
                      onCancelTap: null,
                      submitText: "OK",
                      cancelText: "");
                  break;
                case 3 /*Sign Out*/ :
                  setState(() {
                    currentUser != null
                        ? FireAuth.signOut()
                        : showDialogPlus(
                            context: context,
                            title: const Text("Please Sign In",
                                style: TextStyle(color: Colors.white)),
                            content: Center(
                                child: Column(
                              children: [
                                textField(
                                    hintText: "Email",
                                    controller: _emailController,
                                    width: textFieldWidth),
                                textField(
                                    hintText: "Password",
                                    controller: _passwordController,
                                    width: textFieldWidth),
                                const SizedBox(height: 30),
                                ElevatedButton(
                                    onPressed: () {
                                      FireAuth.signInUsingEmailPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text);
                                      toast("Signed In!");
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Sign In")),
                                const SizedBox(height: 15),
                                ElevatedButton(
                                    onPressed: () {
                                      FireAuth.registerUsingEmailPassword(
                                          email: _emailController.text,
                                          password: _passwordController.text);
                                      toast("Account Created!");
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Sign Up")),
                              ],
                            )),
                            onSubmitTap: () => Navigator.pop(context),
                            onCancelTap: null,
                            submitText: "Cancel",
                            cancelText: "");
                  });
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
              return const Center(child: Icon(Icons.error));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ));
  }
}
