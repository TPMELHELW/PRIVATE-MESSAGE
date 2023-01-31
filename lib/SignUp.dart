import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pppp/Controller.dart';
import 'package:pppp/Widgets.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  const SignUp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigoAccent,
        body: GetBuilder<Controller>(
          init: Controller(),
          builder: (controller) => ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("images/2.png"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Form(
                      key: controller.formstate,
                      child: Column(
                        children: [
                          TextFormField(
                            onSaved: (value) {
                              controller.username = value;
                            },
                            validator: (value) {
                              if (value!.length < 4) {
                                return "USERNAME very short";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.person),
                                labelText: "USERNAME",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50))),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            onSaved: (value) {
                              controller.email = value;
                            },
                            validator: (value) {
                              if (value!.length < 6) {
                                return "EMAIL very short";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email),
                              labelText: "EMAIL",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            obscureText: true,
                            onSaved: (value) {
                              controller.password = value;
                            },
                            validator: (value) {
                              if (value!.length < 6) {
                                return "PASSWORD very short";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.password),
                              labelText: "PASSWORD",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Button(
                    title: "SIGN UP",
                    color: Colors.amber,
                    pressed: () async {
                      controller.spinner = true;
                      controller.update();
                      UserCredential? responde =
                          await controller.signup(context);

                      if (responde != null) {
                        await FirebaseFirestore.instance
                            .collection("users")
                            .add({
                          "username": controller.username,
                          "email": controller.email,
                          "passwprd": controller.password
                        });
                        controller.spinner = false;
                        controller.update();
                      } else {
                        controller.spinner = false;
                        controller.update();
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ));
  }
}
