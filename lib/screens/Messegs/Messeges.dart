import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Model/chat.dart';
import '../../routes/Approutes.dart';

class Messeges extends StatefulWidget {
  const Messeges({super.key});

  @override
  State<Messeges> createState() => _MessegesState();
}

class _MessegesState extends State<Messeges> with WidgetsBindingObserver {
  User? UserID = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    setStatus("online");
    fatchEmailaddress();
  }
  bool islodding = false;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // online
      setStatus("Online");
    } else {
      // offline
      setStatus("Offline");
    }
  }

  String? UserEmails;
  String? name;

  Future<void> fatchEmailaddress() async {
    islodding = true;
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(UserID!.uid);
    final snapshot = await documentReference.get();
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    String emails = data["email"];
    setState(() {
      UserEmails = emails;
      islodding = false;
    });
  }

  void setStatus(String status) async {
    await _firestore.collection("Users").doc(UserID!.uid).update({
      "status": status,
    });
  }
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return islodding
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
                title: Text(
              "Messeges",
              style: TextStyle(color: Colors.black, fontSize: 25),
            )),
            body: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  searchBar(),
                  SizedBox(
                    height: 15,
                  ),
                  ListOfMeseges(),
                ],
              ),
            ));
  }

  String chartRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }
  ListOfMeseges() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Users")
          .where("email", isNotEqualTo: UserEmails)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          // Handle error states here.
          return Center(
            child: Text('Error fetching data'),
          );
        } else if (snapshot.data == null) {
          return Container(
           
          );
        } else {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var UserName = snapshot.data!.docs[index]['name'];
                var ImageFile = snapshot.data!.docs[index]['imagepath'];
                var status = snapshot.data!.docs[index]["status"];
                var userUid = snapshot.data!.docs[index]["Uid"];
                {
                  if(name == null){
                    return  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(ImageFile),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                                  UserName,
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                String authName = _auth.currentUser!.uid as String;
                                String roomId = chartRoomId(authName, userUid);
                                print('Status is $status');
                                chartModels chartStorage =
                                chartModels(UserName, roomId, status, userUid);
                                // Navigator.pushNamed(context,Approutes.chatScreen,arguments: chartStorage);
                                //  Navigator.push(context, MaterialPageRoute(builder: (context) => chatScreens(chartStorage),),);

                                Navigator.pushNamed(context, Approutes.chatScreen,
                                    arguments: chartStorage);
                              },
                              child: CircleAvatar(
                                backgroundColor: Colors.green,
                                child: Icon(Icons.message),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  else if(UserName.toString().toLowerCase().contains(name!.toLowerCase())){
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 10,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(ImageFile),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                    UserName,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  String authName = _auth.currentUser!.uid as String;
                                  String roomId = chartRoomId(authName, userUid);
                                  print('Status is $status');
                                  chartModels chartStorage =
                                  chartModels(UserName, roomId, status, userUid);
                                  // Navigator.pushNamed(context,Approutes.chatScreen,arguments: chartStorage);
                                  //  Navigator.push(context, MaterialPageRoute(builder: (context) => chatScreens(chartStorage),),);

                                  Navigator.pushNamed(context, Approutes.chatScreen,
                                      arguments: chartStorage);
                                },
                                child: CircleAvatar(
                                  backgroundColor: Colors.green,
                                  child: Icon(Icons.message),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      );
                  }else{
                    return Container();
                  }
                }
              },
            ),
          );
        }
      },
    );
  }

  searchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black38.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            name = value;
          });
        },
        decoration: const InputDecoration(
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            hintText: 'Search Product',
            prefixIcon: Icon(Icons.search),
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
      ),
    );
  }
}
