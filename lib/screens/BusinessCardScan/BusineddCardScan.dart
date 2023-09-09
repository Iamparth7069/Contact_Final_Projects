import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class BusinessCardScan extends StatefulWidget {
  const BusinessCardScan({super.key});

  @override
  State<BusinessCardScan> createState() => _BusinessCardScanState();
}

class _BusinessCardScanState extends State<BusinessCardScan> {
  File? _image;
  final imagePicker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( title: Text("Business Card Scan", style: TextStyle(color: Colors.black,fontSize:25 ),)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
              Lottie.asset('assets/lottie/animation_lkp27ork.json',height: 400,repeat: true,reverse: false),
             buildpickcamaraScan(context),
           ],
          ),
        ),
      ),
    );
  }

  buildpickcamaraScan(BuildContext context) {
      return MaterialButton(
          color: Colors.purple.shade100,
          padding: EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onPressed: () {
              openModelBottomSheet(context);
        
      }, child: Text("Scan Your Document Card"));
  }

  Future openModelBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context, builder: (context) {
      return SizedBox(
        height: 200,
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
            children: [
              Text("Select Images"),
              Divider(),
              buildOpenCamara(),
              Divider(),
              buildopenGalary(),
            ],
          ),
        ),
      );
    },);
  }

  buildOpenCamara() {
    return MaterialButton(onPressed: () async {
       var image = await getimagePick();
       Navigator.pop(context);
    },
      color: Colors.grey.shade100,
      minWidth: double.infinity,
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    child: Text("Open Camara" ,style: TextStyle(fontSize: 20),),);
  }

  buildopenGalary() {
    return MaterialButton(onPressed: () {
      getimageformGallary();
      Navigator.pop(context);
    },
      color: Colors.grey.shade100,
      minWidth: double.infinity,
      padding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text("Open Photos" ,style: TextStyle(fontSize: 20),),);
  }

  Future<String> getimagePick() async {
    final image = await imagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = File(image!.path);
      });
      return _image!.path;
  }

  Future<String> getimageformGallary() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
    return _image!.path;
  }
}
