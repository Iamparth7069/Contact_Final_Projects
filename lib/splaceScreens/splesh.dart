import 'dart:async';



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../routes/Approutes.dart';
import '../PrefManager/Prefmanager.dart';

class SplaceScreens extends StatefulWidget {
  const SplaceScreens({super.key});

  @override
  State<SplaceScreens> createState() => _SplaceScreens();
}

class _SplaceScreens extends State<SplaceScreens> {
  User? userid = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      Timer(Duration(seconds: 3), () {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if(user == null){
            var status = PrefManager.getLoginStatus();
            if(status){
            Navigator.pushReplacementNamed(context, Approutes.login);
            }else{
              Navigator.pushReplacementNamed(context, Approutes.onBoardingScreen);
            }
          }else{

            Navigator.pushReplacementNamed(context, Approutes.Home);
          }
        });
      });
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text("Contect Book",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
