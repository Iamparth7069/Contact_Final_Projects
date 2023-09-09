import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../Model/recent_call.dart';

class recents extends StatelessWidget {
  const recents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recent Call',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: Recents(),
    );
  }
}

class Recents extends StatefulWidget {
  const Recents({super.key});

  @override
  State<Recents> createState() => _RecentsState();
}

class _RecentsState extends State<Recents> {

  final user = FirebaseAuth.instance.currentUser;

  User? UserID = FirebaseAuth.instance.currentUser;
  List<Recent> recentData = [];
    bool isLodding = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDAta();
  }
  @override
  Widget build(BuildContext context) {
    return isLodding ? Center(
      child: Container(
        child: CircularProgressIndicator(),
      ),
    ):Column(
      children: [
        LoadData(),
      ],
    );
  }

  LoadData() {
    return Expanded(
      child: ListView.builder(
        itemCount: recentData.length,
        itemBuilder: (context, index) {
        return Padding(
          padding:
          const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                  backgroundImage: NetworkImage('${recentData[index].imageUrl}'),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        '${recentData[index].Name}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${recentData[index].number}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                     makingPhoneCall(context, recentData[index].number);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.call),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    // makingmesegeTouser(context, phoneNo);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.mail),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
        );
      },),
    );
  }

  Future<void> fetchDAta() async {
    try{
      isLodding = true;
      QuerySnapshot querySnapshot =await FirebaseFirestore.instance.collection("Recent").doc(UserID!.uid).collection('recent').get();
      setState(() {
        recentData = querySnapshot.docs.map((e) => Recent.fromMap(e.data() as Map<String,dynamic>)).toList();
      });
    }catch(e){
      print("Error");
      isLodding = false;
    }finally{
      isLodding = false;
    }
  }
  void makingPhoneCall(BuildContext context,String phoneNo) {
    FlutterPhoneDirectCaller.callNumber(phoneNo);
  }
}


