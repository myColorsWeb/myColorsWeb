import 'package:firebase_auth/firebase_auth.dart';
import '../firebase/firestore.dart';
import '../utils/utils.dart';
import 'dart:developer' as dev;

class FireAuth {
  static Future<User?> registerUsingEmailPassword(
      {required String email,
      required String password,
      required void Function() onResend}) async {
    User? user;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      await user!.reload();
      user.sendEmailVerification();
      user = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          makeToast('The password provided is too weak.');
          break;
        case 'email-already-in-use':
          onResend();
          break;
      }
    }
    return user;
  }

  static Future<User?> signInUsingEmailPassword(
      {required String email, required String password}) async {
    User? user;
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
      FireStore.createFavoritesDocument(user!);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          makeToast('No user found for that email.');
          break;
        case 'wrong-password':
          makeToast('Wrong password provided.');
          break;
        case 'user-disabled':
          makeToast('Account is disabled. Please contact the admin.');
          break;
      }
    }
    return user;
  }

  static reSendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.reload();
      if (!user.emailVerified) {
        user
            .sendEmailVerification()
            .onError((error, stackTrace) => dev.log(error.toString()));
        makeToast("A new verification email has been sent to: ${user.email}");
      } else {
        makeToast('Your email has already been verified.');
      }
    }
  }

  static signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  static void deleteUserAccount() {
    FirebaseAuth.instance.currentUser?.delete().whenComplete(() {
      makeToast("Account has been deleted.");
    });
  }

  static updateEmail({required String newEmail}) {
    User? user = FirebaseAuth.instance.currentUser;
    user!
        .updateEmail(newEmail)
        .then((value) => makeToast("Email has been updated."));
  }

  static sendResetPasswordLink({required String email}) async {
    final auth = FirebaseAuth.instance;
    await auth
        .sendPasswordResetEmail(email: email)
        .whenComplete(() => makeToast("A link has been sent to $email"))
        .onError((error, stackTrace) => dev.log(error.toString()));
  }
}
