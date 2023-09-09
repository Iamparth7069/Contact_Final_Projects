

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniproject2/onBoddingScreens/sideViews.dart';


import '../../routes/Approutes.dart';
import '../Model/items.dart';
import '../PrefManager/Prefmanager.dart';
import 'indicator.dart';

class Onboddingscreens extends StatefulWidget {
  const Onboddingscreens({super.key});

  @override
  State<Onboddingscreens> createState() => _OnboddingscreensState();
}

class _OnboddingscreensState extends State<Onboddingscreens> {
  List<Item> listitems = [];
  int currentIndex = 0;
  final _pageController = PageController();
  User? userid = FirebaseAuth.instance.currentUser;
  void initState() {
    super.initState();
    listitems.add(
      Item(
          tital: 'Add Existing Contects',
          desc:
              'Easily add Your existing mobile contect or create new contects on the go and manage them with the app',
          images: 'assets/images/image1.jpg'),
    );
    listitems.add(
      Item(
          tital: 'Manage Your Contects',
          desc:
              'Orgnize your contects using contect Groups. You can further filter them using contect Tags as Well',
          images: 'assets/images/images2.jpg'),
    );
    listitems.add(
      Item(
          tital: 'Share Contacts With Users',
          desc:
              'Use our Web platform to share your contects effortlessy with your peers. They will see the contacts instantly',
          images: 'assets/images/images3.jpg'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, right: 10),
            child: Align(
              alignment: Alignment.topRight,
              child: currentIndex == listitems.length - 1
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, Approutes.login);
                      },
                      child: Container(
                        height: 50,
                        width: 80,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: Colors.grey),
                        child: Center(
                          child: Text(currentIndex == listitems.length - 1
                              ? 'Finish'
                              : 'Skip'),
                        ),
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.8,
            child: PageView.builder(
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value!;
                  // print("The Current Index $value");
                });
              },
              itemCount: listitems.length,
              controller: _pageController,
              itemBuilder: (context, index) {
                return sliderViews(listitems[index]);
              },
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding:
            EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.06),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                for (int i = 0; i < listitems.length; i++)
                  if (i == currentIndex)
                    getindicator(true)
                  else
                    getindicator(false)
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MaterialButton(
                color: currentIndex == listitems.length -1 ? Colors.black : Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                onPressed: () {
                  if (currentIndex == listitems.length - 1) {
                    PrefManager.updateOnboardingStatus(true);
                    if(userid != null){
                      Navigator.pushReplacementNamed(context, Approutes.Home);
                    }
                    else{
                      Navigator.pushReplacementNamed(context, Approutes.login);
                    }
                  } else {
                    currentIndex++;
                    _pageController.animateToPage(currentIndex,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear);
                  }
                },
                child: Text(
                    currentIndex == listitems.length - 1 ? "Finish" : "Next",style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
