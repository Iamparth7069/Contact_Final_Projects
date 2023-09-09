import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../Model/ContectData.dart';
import '../../Model/recent_call.dart';
import '../../firebaseServices/firebase.dart';
import '../../routes/Approutes.dart';

class contectList extends StatefulWidget {
  const contectList({super.key});

  @override
  State<contectList> createState() => _contectListState();
}

class _contectListState extends State<contectList> {
  String? name;
  CollectionReference Addcontect =
      FirebaseFirestore.instance.collection('AddContecs');
  bool isLoading = true;

  // int countData =Addcontect.count() as int;
  User? UserID = FirebaseAuth.instance.currentUser;

  // int count = countThedata() as int;

  FirebaseServices _services = FirebaseServices();
  List<String> getDocumentid = [];
  List<contact> contactList = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext contexts) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            appbarname(),
            header(),
            searchBar(),
            ListofData(),
          ],
        ),
      )),
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

  void makingPhoneCall(BuildContext context, contact contactList) async {
    FlutterPhoneDirectCaller.callNumber(contactList.phone);
    DateTime date = DateTime.now();
    String time = "${date.hour}:${date.minute}:${date.second}";
    Recent recent = Recent(
        number: contactList.phone,
        Name: contactList.name,
        uid: UserID!.uid,
        time: time,
        imageUrl: contactList.imagepath);
    recentDataAdd(recent);
  }

  Future<void> recentDataAdd(Recent recent) async
  {
    return await _services.recentContect_list(recent);
  }

  void makingmesegeTouser(BuildContext context, phoneNo) async {
    var url = Uri.parse("sms:+$phoneNo");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  appbarname() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        'Contact List',
        style: TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  ListofData() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("AddContecs")
          .where("id", isEqualTo: UserID?.uid)
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
        }
        else if(snapshot.data!.docs == null) {
          return  Container(
            child: Text("Thare No Data"),
          );
        }else {
          return Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                String UserName = snapshot.data!.docs[index]['name'];
                var phoneNo = snapshot.data!.docs[index]['phoneNo'];
                var address = snapshot.data!.docs[index]['email'];
                var homeadd = snapshot.data!.docs[index]['HomeAdd'];
                var ImageFile = snapshot.data!.docs[index]['imagepath'];
                var documentid = snapshot.data!.docs[index].id;
                var data = snapshot.data!.docs[index].data();
                contact conts = contact(email: address, HomeAdd: homeadd, imagepath: ImageFile, name: UserName, phone: phoneNo);
                if(name == null){
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        contact contacts = contact(email: address, HomeAdd: homeadd, imagepath: ImageFile, name: UserName, phone: phoneNo,docId: documentid);
                        Navigator.pushNamed(context, Approutes.datail,arguments: contacts);
                      },
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
                              backgroundImage: NetworkImage(conts.imagepath),
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
                                    UserName,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    address,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                makingPhoneCall(context, conts);
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
                                makingmesegeTouser(context, phoneNo);
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
                    ),
                  );
                }
                if(data['name'].toString().toLowerCase().contains(name!.toLowerCase())){
                  return Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: GestureDetector(
                      onTap: () {
                        contact contacts = contact(email: address, HomeAdd: homeadd, imagepath: ImageFile, name: UserName, phone: phoneNo,docId: documentid);
                        Navigator.pushNamed(context, Approutes.datail,arguments: contacts);
                      },
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    UserName,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    address,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                makingPhoneCall(context,conts);
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
                                makingmesegeTouser(context, phoneNo);
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
                    ),
                  );
                }
                else{
                  return Container();
                }
              },
            ),
          );
        }
      },
    );
  }
}

class header extends StatefulWidget {
  const header({super.key});

  @override
  State<header> createState() => _headerState();
}

class _headerState extends State<header> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    Text(
                      "All Contects ",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Icon(
                      CupertinoIcons.arrowtriangle_down_circle_fill,
                      size: 15,
                    ),
                  ],
                )),
          ],
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, Approutes.addContact);
                },
                icon: Icon(
                  Icons.add,
                  size: 25,
                )),
            IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(
                  Icons.refresh,
                  size: 25,
                )),
          ],
        ),
      ],
    );
  }
}
