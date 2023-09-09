import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class contactDetails extends StatelessWidget {
  String phoneNo;
  contactDetails(this.phoneNo);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Mobile"),
                        Text("+91 ${phoneNo}",style: TextStyle(color: Colors.blue,),)
                      ],
                    ),
                    Expanded(child: Container()),
                    InkWell(
                      onTap: () async {
                        makingPhoneCall(context,phoneNo);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.green,
                        child: Icon(Icons.call),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        print(phoneNo);
                        // makingmesegeTouser(context,phoneNo);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        child: Icon(Icons.mail),
                      ),
                    ),
                  ],
                )
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(CupertinoIcons.tag_fill),
                            Text("Tag"),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical:5),

                          child: Text("Mobile contacts"),
                        )
                      ],
                    ),

                  ],
                )
            ),
          ),
        ),
      ],
    );
  }

  void makingPhoneCall(BuildContext context,String phone) async {
    FlutterPhoneDirectCaller.callNumber(phone);
  }

  void makingmesegeTouser(BuildContext context, phoneNo) async {
    var url = Uri.parse("sms:+$phoneNo");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}