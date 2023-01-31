import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Screen2 extends StatefulWidget {
  const Screen2({super.key});

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> {
  List users = [];
  var ref = FirebaseFirestore.instance
      .collection("users")
      .where("email", isEqualTo: FirebaseAuth.instance.currentUser!.email);

  getDta() async {
    var ref1 = await ref.get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          users.add(element.data());
        });
      });
    });
  }

  @override
  void initState() {
    getDta();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amberAccent[100],
      body: users.isEmpty || users == null
          ? const Text("LOADING")
          : Column(
              children: [
                Image.asset(
                  "images/2.png",
                  height: 200,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                  child: const Text(
                    "YOU DON’T HAVE TO BE GREAT TO START BUT YOU HAVE TO START TO BE GREAT",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      50,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "YOUR EMAIL : ${users[0]["email"]}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const Text("=========================="),
                      Text(
                        "YOUR UID : ${FirebaseAuth.instance.currentUser?.uid}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const Text("=========================="),
                      Text(
                        "YOUR PASS : ${users[0]["passwprd"]}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const Text("=========================="),
                      Text(
                        "USERNAME : ${users[0]["username"]}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
