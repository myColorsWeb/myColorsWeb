import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_colors_web/pages/auth_page.dart';
import '../data/remote/api_service.dart';
import 'favorites_page.dart';
import '../firebase/fire_auth.dart';
import 'dart:math';

import '../data/local/my_color.dart';
import 'package:flutter/services.dart';

import '../firebase/firestore.dart';
import '../utils/utils.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
  var randIntStr = "12";

  var isSignedInAndVerified = false;

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
    isSignedInAndVerified =
        FirebaseAuth.instance.currentUser?.emailVerified == true;
    myColors = getColors(random, randIntStr);
  }

  @override
  void dispose() {
    super.dispose();
    _colorController.dispose();
    _countController.dispose();
  }

  void search() {
    setState(() {
      myColors =
          getColors(_colorController.text.toLowerCase(), _countController.text);
    });
  }

  void searchRandom() {
    setState(() {
      randIntStr = (Random().nextInt(12) + 2).toString();
      _colorController.text = random;
      _countController.text = randIntStr;
      myColors = getColors(random, randIntStr);
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
        submitText: "Nice!",
        cancelText: "");
  }

  void showSignIn() {
    showDialogPlus(
        context: context,
        title: Text("Sign In", style: TextStyle(color: MyColor.blueishIdk)),
        content: Text("You must Sign In before saving / accessing Favorites.",
            style: TextStyle(color: MyColor.blueishIdk)),
        onSubmitTap: () {
          Navigator.pop(context);
          signInOut();
        },
        onCancelTap: () {
          Navigator.pop(context);
        },
        submitText: "Sign In",
        cancelText: "Cancel");
  }

  Padding colorsGrid(List<MyColor> colors) {
    var count = 2;
    if (isScreenWidth500Above(context)) {
      count = 4;
    }
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: RefreshIndicator(
          color: MyColor.blueishIdk,
          backgroundColor: Colors.grey[900],
          onRefresh: () {
            searchRandom();
            return Future.value(null);
          },
          child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1 / .5,
                crossAxisCount: count,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: colors.length,
              itemBuilder: (_, index) {
                String hex = colors[index].hex;
                return animatedColorsGrid(
                    colors,
                    index,
                    ScaleAnimation(
                      child: InkWell(
                        onTap: () => showDialogPlus(
                            context: context,
                            title: Text("Selected Color",
                                style: TextStyle(
                                    color: MyColor.getColorFromHex(hex))),
                            content: Container(
                              width: MediaQuery.of(context).size.width / 5,
                              height: MediaQuery.of(context).size.width / 5,
                              decoration: BoxDecoration(
                                  color: MyColor.getColorFromHex(hex)),
                              child: Center(
                                  child: Text(
                                hex,
                                style: const TextStyle(color: Colors.white),
                              )),
                            ),
                            onSubmitTap: () {
                              Navigator.pop(context);
                            },
                            onCancelTap: () {
                              Clipboard.setData(ClipboardData(text: hex));
                              Navigator.pop(context);
                              makeToast("Copied $hex to Clipboard");
                            },
                            submitText: "Nice!",
                            cancelText: "Copy to Clipboard"),
                        onDoubleTap: () {
                          Clipboard.setData(ClipboardData(text: hex));
                          makeToast("Copied $hex to Clipboard");
                        },
                        onLongPress: () {
                          if (isSignedInAndVerified) {
                            FireStore.updateFavorites({hex: hex});
                            makeToast("Saved $hex to Favorites");
                          } else {
                            showSignIn();
                          }
                        },
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: MyColor.getColorFromHex(hex)),
                          child: Center(
                              child: Text(
                            hex,
                            style: const TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ));
              }),
        ));
  }

  Widget showSearchButtonAppBar() {
    var shouldShow = isScreenWidth500Above(context);
    if (shouldShow) {
      return Padding(
        padding: const EdgeInsets.only(top: 15),
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.white)),
            onPressed: () {
              search();
            },
            child: Text(
              "Search",
              style: TextStyle(color: MyColor.blueishIdk),
            )),
      );
    }
    return const SizedBox();
  }

  List<Widget> appBarChildren() => [
        textField(
            context: context,
            width: MediaQuery.of(context).size.width / 5,
            color: Colors.white,
            hintText: "Color",
            controller: _colorController,
            maxLen: 7,
            validator: (s) {
              if (s == null || s.isEmpty) {
                return "";
              } else if (!additionalInfo.contains(s.toUpperCase())) {
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
            color: Colors.white,
            hintText: "#",
            controller: _countController,
            keyboardType: TextInputType.number,
            maxLen: 2,
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
                } else if (int.parse(s) > 12) {
                  _countController.text = "12";
                }
              }
              return null;
            },
            onFieldSubmitted: (s) {
              if (_formKey.currentState!.validate()) {
                search();
              }
            }),
        const SizedBox(width: 15),
        showSearchButtonAppBar()
      ];

  List<Widget>? appBarActions() => [
        Container(
          decoration: BoxDecoration(color: MyColor.blueishIdk),
          child: PopupMenuButton(
              itemBuilder: (context) {
                isSignedInAndVerified =
                    FirebaseAuth.instance.currentUser?.emailVerified == true;
                return [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Random",
                        style: TextStyle(color: MyColor.blueishIdk)),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Favorites",
                        style: TextStyle(color: MyColor.blueishIdk)),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Info",
                        style: TextStyle(color: MyColor.blueishIdk)),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: isSignedInAndVerified
                        ? Text("Sign Out",
                            style: TextStyle(color: MyColor.blueishIdk))
                        : Text("Sign In",
                            style: TextStyle(color: MyColor.blueishIdk)),
                  ),
                ];
              },
              onSelected: (value) {
                switch (value) {
                  case 0 /*Random*/ :
                    searchRandom();
                    break;
                  case 1 /*Favorites*/ :
                    if (isSignedInAndVerified) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FavoritesPage()));
                    } else {
                      showSignIn();
                    }
                    break;
                  case 2 /*Info*/ :
                    showInfo();
                    break;
                  case 3 /*Sign Out*/ :
                    signInOut();
                    break;
                }
              },
              color: Colors.grey[900]),
        ),
      ];

  List<Widget> errorIconAndMsg(String errorMsg) => [
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 60, color: Colors.white),
            const SizedBox(height: 20),
            const Text("Something went wrong.",
                style: TextStyle(color: Colors.white, fontSize: 25)),
            const Text("Reload the page and try again.",
                style: TextStyle(color: Colors.white, fontSize: 25)),
            const SizedBox(height: 10),
            Text(errorMsg,
                style: const TextStyle(color: Colors.white, fontSize: 15))
          ],
        ))
      ];

  void signInOut() {
    if (isSignedInAndVerified) {
      FireAuth.signOut();
      makeToast("Signed Out");
      setState(() {
        isSignedInAndVerified = false;
      });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const AuthPage()));
    }
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
              animatedText(context, "myColorsWeb", onTap: () {}),
              const SizedBox(width: 20),
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: appBarChildren(),
                ),
              )
            ],
          ),
          actions: appBarActions(),
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
                children: errorIconAndMsg("Error\n - ${snapshot.error}"),
              ));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: !isScreenWidth500Above(context)
            ? FloatingActionButton(
                backgroundColor: MyColor.blueishIdk,
                onPressed: () {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState!.validate()) {
                    search();
                  }
                },
                child: const Icon(Icons.search),
              )
            : null,
      ),
    );
  }
}
