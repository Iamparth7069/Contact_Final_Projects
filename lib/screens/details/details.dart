import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:miniproject2/Model/ContectData.dart';
import 'package:miniproject2/Model/notes.dart';
import 'package:miniproject2/routes/Approutes.dart';
import 'package:miniproject2/screens/Database/DBhelper.dart';
import 'package:miniproject2/testing/custom.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contactDetails.dart';
import 'notes.dart';

class details extends StatefulWidget {
  contact cont;
  details(this.cont);
  @override
  State<details> createState() => _detailsState(cont);
}

class _detailsState extends State<details>  with SingleTickerProviderStateMixin{
  contact cont;
  _detailsState(this.cont);

  late TabController _tabController;
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync:this);
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  User? UserID = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('AddContecs')
        .doc('${cont.docId}');

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Contact Info",
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(onPressed: () {
              Navigator.pushNamed(context,Approutes.Updatecontacts,arguments: cont);
            }, icon: Icon(Icons.edit)
            ),
          ],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream:  documentReference.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if (snapshot.hasError) {
              // Handle error states here.
              return Center(
                child: Text('Error fetching data'),
              );
            } else if(snapshot.data!.data() == null) {
              return  Container(
                child: Text("Thare No Data"),
              );
            }else{
              Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
              return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(data["imagepath"]),

                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(data["name"],style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                            Expanded(child: Container()),
                            IconButton(onPressed: () {

                              deleteData();
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Contact The Deleted!'),
                              ));
                              Navigator.pop(context);
                            }, icon: Icon(Icons.delete))
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TabBar(
                          controller: _tabController,
                          indicatorColor: Colors.lightBlue,
                          tabs: const [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.profile_circled,color: Colors.blue),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text("Contact Info",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.attachment,color: Colors.blue),
                                  SizedBox(
                                    width: 7,
                                  ),
                                  Text("Note",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              // Content for Tab
                              contactDetails(data["phoneNo"]),
                              // Content for Tab 2
                              notes(),
                            ],
                          ),
                        ),
                      ],
            ),
              );
            }
          },
        )
    );
  }

  Future<void> deleteData() async {
    await  FirebaseFirestore.instance.collection("AddContecs").doc(cont.docId).delete();
  }
}







