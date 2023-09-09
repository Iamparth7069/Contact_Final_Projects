import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:miniproject2/screens/profile/Profile.dart';
import 'package:miniproject2/testing/custom.dart';

import '../../Model/userinfo.dart';
import '../../firebaseServices/firebase.dart';
import '../../routes/Approutes.dart';
import '../Login_screens/login.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  User? UserID = FirebaseAuth.instance.currentUser;
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _cpass = TextEditingController();
  File? ImageFile;
  bool isLoading = true;
  FirebaseServices _services = FirebaseServices();
  bool updatesLoddings = false;
  late DocumentSnapshot? userData;
  String? documentIds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  String? name;
  String? email;
  late String pass;
  String? imageUrl;

  void fetchData() async {
    final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('Users').doc(UserID!.uid);
    try {
      final snapshot = await documentReference.get();
      if (snapshot.exists) {

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String name1 = data['name'];
        print(name1);
        String emails = data["email"];
        String passs = data["password"];
        String imageUrls = data["imagepath"];

        setState(() {
          pass = passs ?? "";
          imageUrl = imageUrls;
          _name.text = name1!;
          _email.text = emails!;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data: $error');
    }
  }

  final _global = GlobalKey<FormState>();
  bool _finalcheck = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile Info"),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : imageUrl != null
                ? buildUserData()
                : Text('No data found for the current user.'));
  }

  Future<void> pickTheImage() async {
    var image = await FilePicker.platform.pickFiles(allowMultiple: true);
    String Path = '${image!.files.single.path}';
    if (image != null) {
      setState(() {
        ImageFile = File(Path);
      });
    }
  }

  buildUserData() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Tap To Update Image",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
              InkWell(
                onTap: () {
                  pickTheImage();
                },
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: ImageFile != null
                      ? FileImage(File(ImageFile!.path))
                      : NetworkImage(imageUrl!) as ImageProvider,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _name,
                decoration: InputDecoration(
                    label: Text("Name"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    label: Text("Email"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(
                height: 10,
              ),

              SizedBox(
                width: double.infinity,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: MaterialButton(
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                        minWidth: double.infinity,
                        padding: EdgeInsets.all(15),
                        color: Colors.purple.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: MaterialButton(
                        onPressed: () {
                          openDialog(context);
                        },


                        child: Text("Update"),
                        minWidth: double.infinity,
                        padding: EdgeInsets.all(15),
                        color: Colors.purple.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future openDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return updatesLoddings ? CircularProgressIndicator() : Form(
          key: _global,
          child: AlertDialog(
            title: const Text('Update UserDatas'),
            content: Text(
                "Update The User Profile , Email and Password Update Data"),
            actions: [
              TextFormField(
              obscureText: true,
                validator: (value) {
                  if (!value!.contains(pass!)) {
                    return "Invalid Password";
                  } else {
                    return null;
                  }
                },
                controller: _cpass,
                decoration: InputDecoration(
                    label: Text("Enter Old Password"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('update'),
                    onPressed: () {
                      if (_global.currentState!.validate()) {
                        updateUserDetails(context);
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> updateUserDetails(BuildContext context) async {
    final DocumentReference documentReference =
    FirebaseFirestore.instance.collection('User').doc(UserID!.uid);
    final DocumentSnapshot documentSnapshot = await documentReference.get();
    var documentid = documentSnapshot.id;
    String emails = UserID!.email ?? "";
    if(ImageFile != null){
      var path =await _services.RegisterUserImage(ImageFile);
        // print("Ths Image Path ${path}");
      final DocumentReferences = FirebaseFirestore.instance.collection("Users").doc(documentid);
      await DocumentReferences.update({
        'imagepath' : path,
        'email' : _email.text.toString(),
        'name': _name.text.trim()
      });
      if(emails.toString().toLowerCase().contains(_email.text.toString().toLowerCase())){
        Navigator.pop(context);
      }else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: emails, password: pass).then((value) => {
          UserID!.updateEmail(_email.text.toString().trim()),
          print("Email updated"),
          Get.offAll(() => login_screens()),
        });
      }
    }else{

      final DocumentReferences = FirebaseFirestore.instance.collection("Users").doc(documentid);
      await DocumentReferences.update({
        'imagepath' : imageUrl,
        'email' : _email.text.toString(),
        'name': _name.text.trim()
      });
      if(emails.toString().toLowerCase().contains(_email.text.toString().toLowerCase())){
        Navigator.pop(context);
      }else {
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: emails, password: pass).then((value) => {
          UserID!.updateEmail(_email.text.toString().trim()),
          Get.offAll(() => login_screens()),
        });
      }
    }
  }

}
