import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore {
  static DocumentReference<Map<String, dynamic>> getFavDocument() {
    return FirebaseFirestore.instance
        .collection('favorites')
        .doc(FirebaseAuth.instance.currentUser!.email.toString());
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>>
      createFavoritesStream() {
    return getFavDocument().snapshots();
  }

  static Future<void> updateFavorites(Map<String, dynamic> data) {
    return getFavDocument().update(data);
  }

  static void createFavoritesDocument(User user) async {
    final userDocumentReference = FirebaseFirestore.instance
        .collection('favorites')
        .doc(FirebaseAuth.instance.currentUser!.email)
        .get();
    userDocumentReference.then((value) async {
      if (!value.exists) {
        await FirebaseFirestore.instance
            .collection('favorites')
            .doc(user.email)
            .set({});
      }
    });
  }

  static void deleteFavColor(String color) {
    FirebaseFirestore.instance 
    .collection('favorites')
    .doc(FirebaseAuth.instance.currentUser!.email.toString())
    .update({color: FieldValue.delete()});
  }
}
