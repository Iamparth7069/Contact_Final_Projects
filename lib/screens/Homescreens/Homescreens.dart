
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:miniproject2/screens/callers/calls.dart';
import 'package:miniproject2/screens/favourites/favouties.dart';
import 'package:miniproject2/screens/profile/Profile.dart';

import '../Messegs/Messeges.dart';
import '../contectList/contectList.dart';
import '../recents/recents.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _screens = [
    call(),
    contectList(),
    recents(),
    Messeges(),
    Profiles()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _screens[_selectedIndex],
      bottomNavigationBar:Container(
        height: 80,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.black26,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          currentIndex: _selectedIndex,
          backgroundColor: Colors.white,
          items: [

            BottomNavigationBarItem(
                icon:Icon(
                    Icons.call
                ), label: "Dial"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled), label: "Contacts"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.time_solid), label: "Recents"),
            BottomNavigationBarItem(
                icon: Icon(Icons.message_rounded), label: "Messeges"),
            BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled), label: "Profile"),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.messenger), label: "Messenger"),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.person), label: "Profile"),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}