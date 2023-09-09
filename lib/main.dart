import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:miniproject2/routes/Approutes.dart';

import 'PrefManager/Prefmanager.dart';
import 'components/theme.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PrefManager.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: apptheame(),
      title: 'Contact Book',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Approutes.genrateRoutes,
    );
  }
}