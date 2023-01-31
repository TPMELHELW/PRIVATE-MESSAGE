import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pppp/ChatScreen.dart';
import 'package:pppp/Controller.dart';
import 'package:pppp/Widgets.dart';

// ignore: must_be_immutable
class LogIn extends StatelessWidget {
  String? email, password;

  LogIn({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[300],
      body: GetBuilder<Controller>(
        init: Controller(),
        builder: (controller) => ModalProgressHUD(
          inAsyncCall: controller.spinner,
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/2.png"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: "EMAIL",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      obscureText: true,
                      onChanged: (value) {
                        password = value;
                      },
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
                        labelText: "PASSWORD",
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Button(
                    title: "LOG IN",
                    color: Colors.indigo,
                    pressed: () async {
                      try {
                        controller.spinner = true;
                        controller.update();
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                          email: email!,
                          password: password!,
                        );
                        controller.spinner = false;
                        controller.update();
                        Get.to(() => const ChatScreen());
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  title: "No user found for that email.")
                              .show();
                          controller.spinner = false;
                          controller.update();
                        } else if (e.code == 'wrong-password') {
                          controller.spinner = false;
                          controller.update();
                          AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  title:
                                      "Wrong password provided for that user.")
                              .show();
                        }
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
