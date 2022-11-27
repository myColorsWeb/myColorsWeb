import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../firebase/firestore.dart';
import '../data/local/my_color.dart';
import '../utils/utils.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesPage> {
  final List<MyColor> _favColors = [];

  @override
  void initState() {
    super.initState();
    FireStore.getFavDocument().get().then((value) {
      for (var color in value.data()!.values) {
        setState(() {
          _favColors.add(MyColor(hex: color.toString()));
        });
      }
    });
  }

  void _showColorPickerDialog() {
    Color selectedColor = Colors.white;
    showDialogPlus(
        context: context,
        title: Text("Add Color", style: TextStyle(color: MyColor.blueishIdk)),
        content: Column(
          children: [
            ColorPicker(
                enableAlpha: false,
                labelTypes: const [],
                pickerColor: MyColor.blueishIdk!,
                onColorChanged: (color) => setState(() {
                      selectedColor = color;
                    })),
            const SizedBox(height: 30),
            Text(
              "Double-Click a color copy\nLong-Press a color to remove",
              style: TextStyle(color: MyColor.blueishIdk),
            )
          ],
        ),
        onSubmitTap: () {
          Navigator.pop(context);
          var intColor = selectedColor.value;
          var hex =
              "#${intColor.toRadixString(16).padLeft(6, '0').substring(2).toUpperCase()}";
          setState(() {
            _favColors.add(MyColor(hex: hex));
          });
          FireStore.updateFavorites({hex: hex});
        },
        onCancelTap: null,
        submitText: "Save",
        cancelText: "");
  }

  Padding _favoritesGrid(List<MyColor> colors) {
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 1 / .5,
              crossAxisCount: isScreenWidth500Above(context) ? 4 : 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: colors.length,
            itemBuilder: (_, index) {
              String hex = colors[index].hex;
              return animatedColorsGrid(
                  colors,
                  index,
                  InkWell(
                    onDoubleTap: () {
                      Clipboard.setData(ClipboardData(text: hex));
                      makeToast("Copied $hex to Clipboard");
                    },
                    onLongPress: () {
                      setState(() {
                        _favColors.remove(colors[index]);
                      });
                      FireStore.deleteFavColor(hex);
                      makeToast("Deleted $hex from FavoritesPage");
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
                  ));
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.grey[900],
      body: _favoritesGrid(_favColors),
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyColor.blueishIdk,
        onPressed: () {
          FocusManager.instance.primaryFocus?.unfocus();
          _showColorPickerDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
