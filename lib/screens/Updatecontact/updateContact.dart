import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:miniproject2/Model/ContectData.dart';
import 'package:miniproject2/firebaseServices/firebase.dart';



class UpdateContact extends StatefulWidget {
  contact contacts;
  UpdateContact(this.contacts, {super.key});
  @override
  // ignore: no_logic_in_create_state
  State<UpdateContact> createState() => _UpdateContactState(contacts);
}

class _UpdateContactState extends State<UpdateContact> {
  contact contacts;
  final _email = TextEditingController();
  final _name = TextEditingController();
  final _phoneNo = TextEditingController();
  _UpdateContactState(this.contacts);
  User? UserID = FirebaseAuth.instance.currentUser;
  File? ImageFile;
  FirebaseServices _services = FirebaseServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _name.text = contacts.name.trim().toString();
    _email.text = contacts.email.trim().toString();
    _phoneNo.text = contacts.phone.trim().toString();
  }
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Update Contacts"),
        ),
        body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Tap To Update Image",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17)),
                        InkWell(
                          onTap: () {
                             pickTheImage();
                          },
                          child: CircleAvatar(
                            radius: 70,
                             backgroundImage: ImageFile != null ? FileImage(File(ImageFile!.path)) :  NetworkImage(contacts.imagepath) as ImageProvider,
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
                              label:const Text("Email"),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _phoneNo,
                          decoration: InputDecoration(
                              label:const Text("Contact Number"),
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
                                    if(ImageFile != null){
                                      var path = await _services.UpdateUserDatas(ImageFile!);
                                      print(path);
                                      try{
                                        await FirebaseFirestore.instance.collection("AddContecs").doc(contacts.docId).update({
                                          "imagepath" : path,
                                          "email" : _email.text,
                                          "name" : _name.text,
                                          "phoneNo" : _phoneNo.text
                                        });
                                        Navigator.pop(context);
                                        // Navigator.pushNamedAndRemoveUntil(context,Approutes.contectListscreens,(route) => false,);
                                      }catch(e){
                                          print("Error Is $e");
                                      }
                                    }else{
                                      try{
                                        await FirebaseFirestore.instance.collection("AddContecs").doc(contacts.docId).update({
                                          "imagepath" : contacts.imagepath,
                                          "email" : _email.text,
                                          "name" : _name.text,
                                          "phoneNo" : _phoneNo.text
                                        });
                                        Navigator.pop(context);
                                      }catch(e){
                                        throw Exception("Exception is ${e.toString()}");
                                      }
                                    }
                                  },
                                  child: Text("Save"),
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
                ),),);
  }

  Future<void> pickTheImage() async {
    var image = await FilePicker.platform.pickFiles(allowMultiple: true);
    String Path = '${image!.files.single.path}';
    if (image != null) {
      setState(() {
        ImageFile = File(Path);
      });
    }
    print("Image File Path Name ${ImageFile?.path}");
  }
}
