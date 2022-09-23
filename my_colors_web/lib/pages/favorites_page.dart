import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../firebase/firestore.dart';
import '../data/local/my_color.dart';
import '../utils/utils.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final List<MyColor?> _favColors = [];

  @override
  void initState() {
    super.initState();
    FireStore.getFavDocument().get().then((value) {
      for (var color in value.data()!.values) {
        setState(() {
          _favColors.add(MyColor(hex: color.toString(), hsl: "", rgb: ""));
        });
      }
    });
  }

  Padding favoritesGrid(List<MyColor?> colors) {
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
              String hex = colors[index]!.hex;
              return InkWell(
                onDoubleTap: () {
                  Clipboard.setData(ClipboardData(text: hex));
                  toast("Copied $hex");
                },
                onLongPress: () {
                  setState(() {
                    _favColors.remove(colors[index]);
                  });
                  FireStore.deleteFavColor(hex);
                  toast("Deleted $hex from Favorites");
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
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: favoritesGrid(_favColors),
    );
  }
}
