

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:miniproject2/Model/utiles.dart';

import '../../firebaseServices/firebase.dart';
import '../../routes/Approutes.dart';

class login_screens extends StatefulWidget {
  const login_screens({super.key});

  @override
  State<login_screens> createState() => _login_screensState();
}

class _login_screensState extends State<login_screens> {
  bool _passeordvisible = true;
  bool isLodding = false;
  @override
  void initState() {
    // TODO: implement initState
  }
  final _logins = TextEditingController();
  final _pass = TextEditingController();
  final _globlaKey = GlobalKey<FormState>();
  FirebaseServices _services = FirebaseServices();
  @override
  Widget build(BuildContext context) {
    return isLodding ? Scaffold(
      body: Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ),
    ):Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _globlaKey,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Log in",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value == null || !utils.isvalidemail(value)) {
                              return "Enter the Valid Email";
                            } else {
                              return null;
                            }
                          },
                          controller: _logins,
                          decoration: InputDecoration(
                              hintText: "example@gmail.com",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Password",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 15),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context,Approutes.ForgetPass);
                              },
                              child:  Text("Forgot password?",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15),
                              ),),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _pass,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter the Valid Password";
                            } else {
                              return null;
                            }
                          },
                          obscureText: _passeordvisible,
                          decoration: InputDecoration(
                              hintText: "Enter Your Password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _passeordvisible = !_passeordvisible;
                                  });
                                }, icon: Icon(_passeordvisible ? Icons.visibility_off : Icons.visibility),
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(Colors.blue)
                            ),
                            onPressed: () async {
                              if(_globlaKey.currentState!.validate()){
                                var email = _logins.text.trim().toString();
                                var pass = _pass.text.trim().toString();
                                setState(() {
                                  isLodding = true;
                                });
                                var sign =await _services.login(email, pass, context);
                                if(sign is UserCredential){
                                  isLodding = false;
                                  Navigator.pushNamedAndRemoveUntil(context, Approutes.Home, (route) => false);
                                }
                                else if(sign is String){
                                  setState(() {
                                    isLodding = false;
                                  });
                                  Fluttertoast.showToast(
                                      msg: sign,
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 16.0
                                  );
                                }
                              }else{
                                print("Invalid Data");
                              }
                            }, child: Text("Log in"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text("OR",style: TextStyle(fontSize: 18)),
                SizedBox(
                  height: 20,
                ),
                buildGooglesignin(),
                SizedBox(
                  height: 20,
                ),
                buildAppleIdRegistation(),
                SizedBox(
                  height: 20,
                ),
                Text("Don't have an account yet?",style:TextStyle(fontSize: 15),),
                buildCreateAccount(context),
                SizedBox(
                  height: 30,
                ),
                Text("By clicking the sign up button above,"),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text("you agree to our"),
                    Text("Terms of Use ",style: TextStyle(color: Colors.blue,fontSize: 10),),
                    Text("and ",style: TextStyle(fontSize: 10),),
                    Text("Privacy statement",style: TextStyle(color: Colors.blue,fontSize: 10),)
                  ],
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }

  buildGooglesignin() {
    return MaterialButton(onPressed: () {
    },color: Colors.redAccent,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Icon(Icons.g_mobiledata,color: Colors.white,size: 40,),
              ],
            ),
            Row(
              children: [
                Text("Sign in with Google",style: TextStyle(fontSize: 18),),
              ],
            )
          ],
        )
    );
  }

  buildAppleIdRegistation() {
    return MaterialButton(onPressed: () {

    },color: Colors.black,
        minWidth: double.infinity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              children: [
                Icon(Icons.apple,color: Colors.white,size: 40,),
              ],
            ),
            Row(
              children: [
                Text("Sign in with Google",style: TextStyle(fontSize: 18,color: Colors.white),),
              ],
            )
          ],
        )
    );
  }

}

buildCreateAccount(BuildContext context) {
  return MaterialButton(onPressed: () {
    Navigator.pushNamed(context, Approutes.ragister);
  },color: Colors.white,
      minWidth: double.infinity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            children: [
              Text("Create an account",style: TextStyle(fontSize: 20,color: Colors.black),),
            ],
          )
        ],
      )
  );
}
