

import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../Model/registerPage.dart';
import '../../firebaseServices/firebase.dart';
import '../Login_screens/login.dart';



class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullName = TextEditingController();
  final _emailaddress = TextEditingController();
  final _password = TextEditingController();
  final _cpassword = TextEditingController();
  bool _finalcheck = true;
  final _globlaKey = GlobalKey<FormState>();
  bool _passeordvisited = true;
  bool isLodding = false;
  FirebaseServices _services = FirebaseServices();
  User? currentUser = FirebaseAuth.instance.currentUser;
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
      appBar: AppBar(
          title: Text(
        "Sign Up",
        style: TextStyle(color: Colors.black),
      )),
      body:isLodding ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ) : Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Form(
            key: _globlaKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
               Center(
                 child: Column(
                   children: [
                     Text("Pick Profile Images",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                     SizedBox(
                       height: 10,
                     ),
                     GestureDetector(
                       onTap: () {
                            pickTheImage();
                       },
                       child: CircleAvatar(
                         radius: 50,
                         backgroundImage: ImageFile != null ? FileImage(ImageFile!) : AssetImage("assets/images/user.png") as ImageProvider,
                       ),
                     ),
                   ],
                 ),
               ),
                Text("Name"),
                SizedBox(
                  height: 13,
                ),
                TextFormField(
                  controller: _fullName,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Emter the Last Name";
                    } else {
                      return null;
                    }
                  },

                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: "Full name",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Email"),
                SizedBox(
                  height: 13,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter the Email";
                    }else{
                      return null;
                    }
                  },
                  controller: _emailaddress,
                  decoration: InputDecoration(
                      hintText: "Email Address",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    floatingLabelBehavior: FloatingLabelBehavior.auto,),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Password"),
                SizedBox(
                  height: 13,
                ),
                TextFormField(
                  controller: _password,
                  obscureText: _passeordvisited,
                  validator: (value) {
                    if (value == null || value!.isEmpty) {
                      return "Enter the Password";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passeordvisited = !_passeordvisited;
                          });
                        },
                        icon: Icon(_passeordvisited
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      hintText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("Confirm Password"),
                SizedBox(
                  height: 13,
                ),
                TextFormField(
                  obscureText: _finalcheck,
                  controller: _cpassword,
                  validator: (value) {
                    if (value == null || value!.isEmpty) {
                      return "Enter the Password";
                    } else if (value != _password.text.toString()) {
                      return "Password Mismatched";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                        },
                        icon: Icon(_finalcheck
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      hintText: "Confire Your Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(
                  height: 40,
                ),
                buildregistationButton(),

              ],
            ),
          ),
        ),
      ),

    );
  }

  buildregistationButton() {
    return MaterialButton(
      onPressed: () async {
        String name = _fullName.text.toString().trim();
        String email = _emailaddress.text.toString().trim();
        String pass = _password.text.toString().trim();
        String cpass = _cpassword.text.toString().trim();
        if (_globlaKey.currentState!.validate()) {
          _globlaKey.currentState!.save();
          setState(() {
            isLodding = true;
          });
          String imagePath = await _services.RegisterUserImage(ImageFile);
          var User =RegisterUsers(email: email,pass: pass,name: name,imagepath: imagePath);
          await createUser(User);
        }
        else{
          print("It is Error");
        }
      },
      color: Colors.blue,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.all(10),
      child: Text(
        "Sign Up ",
        style: TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }

  Future<void> createUser(RegisterUsers user) async {
    var create = await _services.createUser(user.email!,user.pass!,user.name,user.imagepath);
    if(create is User){
        if(create != null){
          _services.addUserDetails(user!.name);
          isLodding = false;
         Navigator.pop(context);
        }else if(create is String){
          isLodding = true;
        }
    }else if (create is String){
      setState(() {
        isLodding = false;
      });
      Fluttertoast.showToast(
          msg: create,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
}
