import 'package:flutter/material.dart';
import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class call extends StatelessWidget {
  const call({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Dail Pad',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: DailPad(),
    );
  }
}

class DailPad extends StatefulWidget {
  const DailPad({super.key});

  @override
  State<DailPad> createState() => _DailPadState();
}

class _DailPadState extends State<DailPad> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: DialPad(
            enableDtmf: true,
            outputMask: "(000) 000-0000",
            hideSubtitle: true,
            backspaceButtonIconColor: Colors.red,
            makeCall: (number){
             makingCall(number);
            }
        )
    );
  }

  void makingCall(String number) {
    FlutterPhoneDirectCaller.callNumber(number);
  }
}

