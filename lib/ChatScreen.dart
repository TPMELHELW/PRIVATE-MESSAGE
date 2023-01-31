import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pppp/Screen2.dart';
import 'package:pppp/main.dart';

// final currentUseer = FirebaseAuth.instance.currentUser!.email;
final textEdit = TextEditingController();

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  getuser() async {
    var userref = await FirebaseAuth.instance.currentUser;
  }

  String? text;
  @override
  void initState() {
    getuser();
    getDta();
    super.initState();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.off(() => const HomeScreen());
            },
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Get.to(() => Screen2());
          },
        ),
        title: const Text("ChatScreen"),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("chatScreen")
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, i) {
                        final sender1 = snapshot.data!.docs[i].get("sender");
                        final currentUseer =
                            FirebaseAuth.instance.currentUser?.email;
                        return Messages(
                          stream: snapshot.data!.docs[i],
                          isMe: currentUseer == sender1,
                        );
                      },
                    ),
                  );
                }

                return const Text("");
              }),
            ),
            Stack(
              alignment: AlignmentDirectional.centerEnd,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: users.isEmpty || users == null
                            ? Text("LOADING")
                            : TextField(
                                controller: textEdit,
                                onChanged: (value) {
                                  text = value;
                                },
                                decoration: InputDecoration(
                                  labelText: "HELLO ${users[0]["username"]}",
                                  border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    textEdit.clear();
                    await FirebaseFirestore.instance
                        .collection("chatScreen")
                        .add({
                      "message": text,
                      "sender": FirebaseAuth.instance.currentUser!.email,
                      "time": FieldValue.serverTimestamp()
                    });
                  },
                  child: const Text("SEND"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Messages extends StatelessWidget {
  Messages({
    super.key,
    required this.stream,
    required this.isMe,
  });
  final bool isMe;
  // ignore: prefer_typing_uninitialized_variables
  var stream;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe == true ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          "${stream["sender"]}",
          style: const TextStyle(fontSize: 12),
        ),
        Material(
          borderRadius: BorderRadius.circular(50),
          elevation: 10,
          color: isMe == true ? Colors.amber : Colors.blueAccent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("${stream["message"]}"),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
