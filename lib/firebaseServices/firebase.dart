import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:miniproject2/Model/recent_call.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/user.dart';


class FirebaseServices{
  static final _instance = FirebaseServices.instance();
  FirebaseServices.instance();
  factory FirebaseServices() {
    return _instance;
  }
  final DatabaseReference _mRsf = FirebaseDatabase.instance.ref();
  CollectionReference UserDeleted = FirebaseFirestore.instance.collection('Users');
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference ContectAdd = FirebaseFirestore.instance.collection('AddContecs');
  CollectionReference recentData = FirebaseFirestore.instance.collection("Recent");
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Reference _storageRef = FirebaseStorage.instance.ref();
  final FirebaseAuth _mAuth = FirebaseAuth.instance;
  var _data = FirebaseFirestore.instance;
  Future<dynamic> login(String email,String password,BuildContext context)async{
    try{
      UserCredential credential = await _mAuth.signInWithEmailAndPassword(email: email, password: password);
      print("User id ${credential.user!.uid}");
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user";
      }
    }
  }

  Future<dynamic> createUser(String Email,String pass, String? name,String? imageUrl) async {
    try{
      User? user = (await _mAuth.createUserWithEmailAndPassword(
          email: Email, password: pass)).user;
      if(user!= null){
        user.updateDisplayName(name);
        await _firestore.collection("Users").doc(_mAuth.currentUser!.uid).set({
          "name" : name,
          "email" : Email,
          "password": pass,
          "imagepath" :imageUrl,
          "Uid" : _mAuth.currentUser!.uid
        });
        return user;
      }
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "No user found for that email";
      } else if (e.code == 'wrong-password') {
        return "Wrong password provided for that user";
      }
    }
  }

  Future<void> add(Users userContectData)async {
    return await ContectAdd.doc().set(userContectData.toMap()).then((value) => {
      print("Data add")
    });
  }

  Future<void> recentContect_list(Recent dataRecent) async {

    print("${user!.uid}");
        return await recentData.doc(user!.uid).collection('recent').doc().set(dataRecent.toMap());
  }
  addUserDetails(String? name) async{
    return await _data.collection("userNames").doc().set({"Name" : name}).then((value) => {
      print("Set Name")
    });
  }
  // deleted(String? documentId) async {
  //   print(documentId);
  //   await ContectAdd.doc(documentId).delete().then((value) => {
  //     print("The Data IS Deleted"),
  //     Get.offAll(() => HomePage())
  //   });
  // }


  DeleteUser(String? UserId,BuildContext context) async{
    bool isDeleted = false;
    user!.delete().then((value) => {
      isDeleted = true,
    });
    await UserDeleted.doc(UserId).delete().then((value) => {
      isDeleted = true,
    });
    if(isDeleted){
      return isDeleted;
    }else{
      return isDeleted;
    }
  }
  logout()async{
    await _mAuth.signOut();
  }



  // *****************************Firebase Storage *********************
  Future<String> uploadContectImage(File? imageFile) async {
    String url = "";
    String tempFile = basename(imageFile!.path);
    var ex = extension(tempFile);
    String filename = '$tempFile$ex';
    try{
      var image = await _storageRef.child("Addcontect").child(filename).putFile(imageFile);
      if(image != null){
        url = await _storageRef.child("Addcontect").child(filename).getDownloadURL();
      }else{
        print("Error");
      }
    } on FirebaseException catch(e){
      print("Error Is e");
    }
    return url;
  }

  Future<String> RegisterUserImage(File? imageFile) async {
    String url = "";
    String tempFile = basename(imageFile!.path);
    var ex = extension(tempFile);
    String filename = '$tempFile$ex';
    try{
      var image = await _storageRef.child("Register").child(filename).putFile(imageFile);
      if(image != null){
        url = await _storageRef.child("Register").child(filename).getDownloadURL();
      }else{
        print("Error");
      }
    } on FirebaseException catch(e){
      print("Error Is e");
    }
    return url;
  }

  Future<String> UpdateUserDatas(File? Imagepath) async {
    String url = "";
    String tempFile = basename(Imagepath!.path);
    var ex = extension(tempFile);
    String filename = '$tempFile$ex';
    try{
      var image = await _storageRef.child("Addcontect").child(filename).putFile(Imagepath);
      if(image != null){
        url = await _storageRef.child("Addcontect").child(filename).getDownloadURL();
      }else{
        print("Error");
      }
    }on FirebaseException catch(e){
      print("Error Is e");
    }
    return url;
  }


}


