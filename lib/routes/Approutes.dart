
import 'package:flutter/material.dart';
import 'package:miniproject2/Model/ContectData.dart';

import 'package:miniproject2/screens/AddContacts/Addcontacts.dart';
import 'package:miniproject2/screens/Updatecontact/updateContact.dart';

import '../Model/chat.dart';
import '../onBoddingScreens/onBodding.dart';
import '../screens/Homescreens/Homescreens.dart';
import '../screens/Login_screens/login.dart';
import '../screens/chatScreens/chatScreens.dart';
import '../screens/contectList/contectList.dart';
import '../screens/details/details.dart';
import '../screens/registerPage/RagisterPage.dart';
import '../splaceScreens/splesh.dart';



class Approutes {
  static const splashScreen = '/';
  static const onBoardingScreen = '/onBoarding';
  static const login = '/login';
  static const ragister = '/register';
  static const Home = '/home';
  static const ForgetPass = '/forget';
  static const datail= '/details';
  static const contectListscreens = '/ContectList';
  static const chatScreen = '/chartScreens';
  static const addContact = '/contactAdd';
  static const Updatecontacts = '/UpdateContacts';
  static Route<dynamic>? genrateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (context) => SplaceScreens(),
        );
      case onBoardingScreen:
        return MaterialPageRoute(
          builder: (context) => Onboddingscreens(),
        );
      case login:
        return MaterialPageRoute(
          builder: (context) => login_screens(),
        );
      case ragister:
        return MaterialPageRoute(
          builder: (context) => RegisterPage(),
        );
      case Home:
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );
      case addContact:
        return MaterialPageRoute(
          builder: (context) => Addcontacts(),
        );
      case chatScreen:
        chartModels? cat = settings.arguments != null ? settings.arguments as chartModels : null;
        return MaterialPageRoute(builder: (context) => chatScreens(cat!));

      case datail:
        contact? cats = settings.arguments != null ? settings.arguments as contact : null;
        return MaterialPageRoute(
          builder: (context) => details(cats!),
        );
      case Updatecontacts:
        contact? cats = settings.arguments != null ? settings.arguments as contact : null;
        return MaterialPageRoute(
          builder: (context) => UpdateContact(cats!),
        );

      case contectListscreens:
        return MaterialPageRoute(
          builder: (context) => contectList(),
        );
    }
  }
}