import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthServices {
  String email;
  String password;

  AuthServices({required this.email, required this.password});

  createUser(String name) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: this.email,
        password: this.password,
      );

      FirebaseAuth _auth = FirebaseAuth.instance;

      var user = FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': _auth.currentUser?.email,
        'user_id': _auth.currentUser?.uid,
        'gender': '',
        'location': '',
        'phone_number': '',
        'avatar_url': '',
      });
      Get.snackbar("Message", "User account successfully created.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(
            seconds: 4,
          ),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        Get.snackbar("Message", "The password provided is too weak.",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(15),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        Get.snackbar("Message", "Account already exists.",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(15),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      }
    } catch (e) {
      print(e);
      Get.snackbar("Erro", "e",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    }
  }

  loginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: this.email,
        password: this.password,
      );
      Get.snackbar("Message", "User login successfully.",
          snackPosition: SnackPosition.BOTTOM,
          borderRadius: 20,
          duration: const Duration(seconds: 4),
          margin: const EdgeInsets.all(15),
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
          forwardAnimationCurve: Curves.easeInOutBack);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        Get.snackbar("Message", "No user found for that email.",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 3),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        Get.snackbar("Message", "Wrong password",
            snackPosition: SnackPosition.BOTTOM,
            borderRadius: 20,
            duration: const Duration(seconds: 4),
            margin: const EdgeInsets.all(15),
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
            forwardAnimationCurve: Curves.easeInOutBack);
      }
    }
  }

  logoutUser() async {
    await FirebaseAuth.instance.signOut();
    Get.snackbar("Message", "User logout successfully.",
        snackPosition: SnackPosition.BOTTOM,
        borderRadius: 20,
        duration: const Duration(seconds: 4),
        isDismissible: true,
        margin: const EdgeInsets.all(15),
        dismissDirection: DismissDirection.horizontal,
        forwardAnimationCurve: Curves.easeInOutBack);
  }
}
