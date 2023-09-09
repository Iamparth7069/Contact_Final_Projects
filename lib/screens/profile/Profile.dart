import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:miniproject2/routes/Approutes.dart';
import 'package:miniproject2/screens/BusinessCardScan/BusineddCardScan.dart';
import 'package:miniproject2/screens/profileInfo/profileInfo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../firebaseServices/firebase.dart';
import '../Login_screens/login.dart';
import '../UpdatePassword/updatePassword.dart';

class Profiles extends StatefulWidget {
  const Profiles({super.key});

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
   User? UserID = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fatchemails();
  }
  String? UserEmails;
  String? password;
  bool idlodding = false;
   Future<void> fatchemails() async {
     idlodding = true;
     final DocumentReference documentReference =
     FirebaseFirestore.instance.collection('Users').doc(UserID!.uid);
     final snapshot = await documentReference.get();
     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
     String emails = data["email"];
     String pass = data["password"];
     setState(() {
       UserEmails = emails;
       password =pass;
       idlodding = false;
     });
     print(UserEmails);
   }
   FirebaseServices firebase = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),)),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child:SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(stream: FirebaseFirestore.instance.collection("Users").where("email" ,isEqualTo: UserEmails).snapshots(), builder: (context, snapshot) {

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
                    child: Text("Thare No Data"),
                  );
                } else{
                  var Email = snapshot.data?.docs[0]["email"];
                  var ImageUrl = snapshot.data?.docs[0]["imagepath"];
                  var Name = snapshot.data?.docs[0]["name"];
                  return idlodding ? Center(
                    child: Container(
                      child: CircularProgressIndicator(),
                    ),
                  ) :ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(ImageUrl),
                    ),
                    title: Text(
                      Name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 25,
                      ),
                    ),
                    subtitle: Text(Email),
                  );
                }
              },),
              Divider(
                height: 50,
              ),
              ListTile(
                onTap: () {
                 Navigator.push(context,MaterialPageRoute(builder: (context) => ProfileInfo(),));
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.person,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
                title: Text(
                  "profile",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => updatePassword(password!,UserEmails!),));
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.security,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Password Update and Privacy",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => BusinessCardScan(),));
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.business_sharp,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Business Card Scan",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () {
                  helpandsupport();
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.live_help,
                    color: Colors.blue,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Help & support",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () {
                  lounchUrl();
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    CupertinoIcons.doc_person_fill,

                    color: Colors.orange,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Terms & Conditions",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
              Divider(
                height: 40,
              ),

              ListTile(
                onTap: ()async {
                   firebase.logout().then((value) => {
                      Navigator.pushNamedAndRemoveUntil(context, Approutes.login, (route) => false)
                   });
                },
                leading: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout,
                    color: Colors.redAccent.shade100,
                    size: 35,
                  ),
                ),
                title: Text(
                  "Log Out",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios_rounded),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void lounchUrl() async{
    var url = Uri.parse('https://www.contactbook.app/terms');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> helpandsupport() async {
    var url = Uri.parse('https://www.contactbook.app/help');
    if (await canLaunchUrl(url)) {
    await launchUrl(url);
    } else {
    throw 'Could not launch $url';
    }
  }
}