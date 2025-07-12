import 'package:lapuerta2/auth.dart';
import 'package:lapuerta2/guest/guest_mainwrapper.dart';
import 'package:flutter/material.dart';
import 'package:lapuerta2/onboarding.dart';



class GuestWidgetTree extends StatefulWidget{
  const GuestWidgetTree({super.key});

  @override 
  State<GuestWidgetTree> createState() => _GuestWidgetTreeState();
}

class _GuestWidgetTreeState extends State<GuestWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth().authStateChanges, 
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GuestMainwrapper();
        }else {
          return const OnboardingPage();
        }
      },
    );
  }
}



