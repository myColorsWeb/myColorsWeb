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
              return animatedColorsGrid(colors, index);
            }));
  }

  Widget animatedColorsGrid(List<MyColor> colors, int index) {
    String hex = colors[index].hex;
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 777),
      child: ScaleAnimation(
        child: InkWell(
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
            decoration: BoxDecoration(color: MyColor.getColorFromHex(hex)),
            child: Center(
                child: Text(
              hex,
              style: const TextStyle(color: Colors.white),
            )),
          ),
        ),
      ),
    );
  }

  List<Widget> appBarChildren() => [
        textField(
            context: context,
            width: MediaQuery.of(context).size.width / 5,
            hintText: "Color",
            controller: _colorController,
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
            hintText: "#",
            controller: _countController,
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
            })
      ];

  List<Widget>? appBarActions() => [
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
              child:
                  isSignedIn ? const Text("Sign Out") : const Text("Sign In"),
            ),
          ];
        }, onSelected: (value) {
          switch (value) {
            case 0 /*Random*/ :
              setState(() {
                randIntStr = Random().nextInt(12).toString();
                _colorController.text = random;
                _countController.text = randIntStr;
                myColors = getColors(random, randIntStr);
              });
              break;
            case 1 /*Favorites*/ :
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Favorites()));
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const AuthPage()));
              }
              break;
          }
        }),
      ];

  List<Widget> errorIconAndMsg(String errorMsg) => [
        const Icon(Icons.error, size: 60, color: Colors.white),
        const SizedBox(height: 20),
        const Text(
            "Something went wrong. Reload the page and please try again.",
            style: TextStyle(color: Colors.white, fontSize: 25)),
        const SizedBox(height: 10),
        Text(errorMsg,
            style: const TextStyle(color: Colors.white, fontSize: 15))
      ];

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
              animatedText(context, "myColorsWeb"),
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
                children: errorIconAndMsg(snapshot.error.toString()),
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
