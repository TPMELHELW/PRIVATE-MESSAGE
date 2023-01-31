import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  String? email, password, username;
  bool spinner = false;
  signup(context) async {
    var formData = formstate.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        AwesomeDialog(
                context: context,
                dialogType: DialogType.success,
                title: "YOUR EMAIL IS CREATED")
            .show();
        return userCredential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  title: "The password provided is too weak")
              .show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
                  context: context,
                  dialogType: DialogType.error,
                  title: "The account already exists for that email.")
              .show();
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
