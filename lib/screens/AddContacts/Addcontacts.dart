import 'dart:io';


import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:miniproject2/Model/utiles.dart';

import '../../Model/user.dart';
import '../../firebaseServices/firebase.dart';

class Addcontacts extends StatefulWidget {
  const Addcontacts({super.key});

  @override
  State<Addcontacts> createState() => _AddcontactsState();
}

class _AddcontactsState extends State<Addcontacts> {
  String dob = '';
  FirebaseServices _services = FirebaseServices();

  User? userId  = FirebaseAuth.instance.currentUser;
  final _fname = TextEditingController();
  final _lastname = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _globlaKey = GlobalKey<FormState>();
  bool IsLodding = false;
  File? ImageFile;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( title: Text("Contact Add", style: TextStyle(color: Colors.black,fontSize:25 ),)),
        body: IsLodding ? Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ) : Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Container(
                padding:  EdgeInsets.fromViewPadding(View.of(context).viewInsets, View.of(context).devicePixelRatio + 20),
                child: Form(
                  key: _globlaKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CircleAvatar(
                              backgroundColor: Colors.blue.shade200,
                              radius: 70,
                              backgroundImage: ImageFile != null ? FileImage(File(ImageFile!.path)) :  AssetImage('assets/images/user.png') as ImageProvider,
                            ),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                pickTheImage();
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.grey,
                                ),
                                child: Icon(LineAwesomeIcons.alternate_pencil,
                                  color: Colors.black,),
                              ),
                            )
                        ),
                      ]),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: TextFormField(

                                  controller:_fname,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the First Name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "First Name",
                                    hintText: "First Name",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13)
                                    ),
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  ),
                                )),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: TextFormField(
                                  controller: _lastname,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Enter the Last Name";
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(13)
                                    ),
                                    labelText: "Last Name",
                                    hintText: "Last Name",
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                  ),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _email,
                        validator: (value) {
                          if (value == null || !utils.isvalidemail(value)) {
                            return "Valid Email Address";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            label: Text("Enter Email"),
                            hintText: "Email",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),

                            )
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || !utils.isvalidmobile(value)) {
                            return "Enter the Number";
                          } else {
                            return null;
                          }
                        },
                        controller: _phone,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            label: Text("Enter Number"),
                            hintText: "Number",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                            )
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter the Address";
                          } else {
                            print("null");
                            return null;
                          }
                        },
                        controller: _address,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        decoration: InputDecoration(
                            labelText: "Address",
                            hintText: 'Address',
                            alignLabelWithHint: true,
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(13),
                            )
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      MaterialButton(onPressed: () async {
                        if(ImageFile != null){
                          if(_globlaKey.currentState!.validate()){
                            setState(() {
                              IsLodding = true;
                            });
                            String name = '${_fname.text.toString().trim().toLowerCase()} ${_lastname.text.toString().trim().toLowerCase()}';
                            String phone = '${_phone.text.toString().trim()}';
                            String email = '${_email.text.toString().trim()}';
                            String address = '${_address.text.toString().trim()}';
                            String? imagepath = await _services.uploadContectImage(ImageFile!);
                            print(imagepath);
                            var userContectData = Users(name: name,phoneNo: phone,email: email,imagepath: imagepath,add: address);
                            dataAdd(userContectData,context);
                          }else{
                            print("Its Error ");
                          }
                        }else{

                          // image is not selected
                          toastToImagePickes();
                          print("This is Not Selected Images");
                        }
                      },
                        child: Text("Add Contect"),
                        minWidth: double.infinity,
                        padding: EdgeInsets.all(15),
                        color: Color(0xFF01579B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                    ],
                  ),
                ),

              ),
            ),
          ),
        )
    );
  }


  resetThedata() {
    ImageFile = null;
    _fname.text = "";
    _lastname.text = "";
    _phone.text = "";
    _address.text = "";
    _email.text = "";
  }

  Future<void> dataAdd(Users? userContectData, BuildContext context) async {
    userContectData!.id = userId!.uid;
    print(userContectData.id);
    print("User is Is ${ userContectData!.id}");
    IsLodding = false;
    setState(() {
      resetThedata();
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Contact Added!'),
    ));

    return await _services.add(userContectData);
  }

  Future<bool?> toastToImagePickes() {
    return Fluttertoast.showToast(
        msg: "Pick The Images",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.purple.shade100,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
