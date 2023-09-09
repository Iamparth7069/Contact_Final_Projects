import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Login_screens/login.dart';

class updatePassword extends StatefulWidget {
  String password;
  String userEmails;

  updatePassword(this.password,this.userEmails);

  @override
  State<updatePassword> createState() => _updatePasswordState(password,userEmails);
}

class _updatePasswordState extends State<updatePassword> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  String password;
  String email;

  _updatePasswordState(this.password,this.email);
  User? UserID = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      // Implement password change logic here
      // Set _isLoading to true during the process
      setState(() {
        _isLoading = true;
      });
      // Simulate a delay (replace this with your actual logic)
      Future.delayed(Duration(seconds: 2), () async {
        // Reset _isLoading after the process is complete
        setState(() {
          _isLoading = false;
        });
        final DocumentReference documentReference =
        FirebaseFirestore.instance.collection('User').doc(UserID!.uid);
        final DocumentSnapshot documentSnapshot = await documentReference.get();
        var documentid = documentSnapshot.id;
        // Show a success message or navigate to a different screen
        final DocumentReferences = FirebaseFirestore.instance.collection("Users").doc(documentid);
        await DocumentReferences.update({
          'password' : _confirmPasswordController.text.toString().trim(),
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) => {
          UserID!.updatePassword(_confirmPasswordController.text.toString().trim()),
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Password changed successfully!'),
        )),
          Get.offAll(() => login_screens()),
        });
      });
    }
  }
  bool _passeordvisited = true;
  bool _cpassvisited = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                    labelText: 'Current Password'),
                
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your current password.';
                  }else if(!value.contains(password)){
                    return "Not Match Old Password";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),

              TextFormField(
                controller: _newPasswordController,
                obscureText: _passeordvisited,

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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    labelText: 'New Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a new password.';
                  }
                  // Implement your password validation logic here
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _cpassvisited,
                decoration: InputDecoration(labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _cpassvisited = !_cpassvisited;
                        });
                      },
                      icon: Icon(_cpassvisited
                          ? Icons.visibility_off
                          : Icons.visibility),
                    ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                )),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please confirm your new password.';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Passwords do not match.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Save Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
