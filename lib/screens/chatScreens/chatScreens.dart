import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Model/chat.dart';

class chatScreens extends StatefulWidget {
  chartModels chat;

  chatScreens(this.chat);

  @override
  State<chatScreens> createState() => _chatScreensState();
}

class _chatScreensState extends State<chatScreens> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final messge = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLoading = false;

  void onSendMessage() async {
    if (messge.text.trim().toString().isNotEmpty) {
      DateTime date = DateTime.now();
      String time = "${date.hour}:${date.minute}:${date.second}";
      print("time $time");
      Map<String, dynamic> messege = {
        "sendby": _auth.currentUser?.displayName,
        "message": messge.text,
        "time": time,
      };
      await _firestore
          .collection('chatroom')
          .doc(widget.chat.ChartRoomId)
          .collection('chats')
          .add(messege);
      messge.clear();
    } else {
      print("Enter Sum Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore
              .collection("Users")
              .doc(widget.chat.UserId)
              .snapshots(),
          builder: (context, snapshot) {
            String status = snapshot.data!["status"];
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.chat.username,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, fontSize: 20),
                    ),
                    Container(
                      child: Text(
                        status,
                        style: TextStyle(fontSize: 17),
                      ),
                    )
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(widget.chat.ChartRoomId)
                    .collection('chats')
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic>? map = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;
                        return messeges(size, map!);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: size.height / 12,
                        width: size.width / 1.5,
                        child: TextFormField(
                          controller: messge,
                          decoration: InputDecoration(
                              label: Text("Enter the Message"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 3.0),
                      decoration: BoxDecoration(
                          /*color: Colors.grey,*/
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: IconButton(
                          color: Colors.white,
                          onPressed: onSendMessage,
                          icon: Icon(Icons.send_outlined)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar:
    );
  }

  Widget messeges(Size size, Map<String, dynamic> map) {
    return SafeArea(
      child: Container(
        width: size.width,
        alignment: map['sendby'] == _auth.currentUser?.displayName
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 17),
          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15), color: Colors.blue),
          child: Text(
            map['message'],
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
