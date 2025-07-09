import 'package:lapuerta2/auth.dart';
import 'package:lapuerta2/loginCheck.dart';
import 'package:flutter/material.dart';
import 'package:lapuerta2/mainwrapper.dart';



class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}) : super(key: key);

  @override 
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
 final Authen = Auth().authStateChanges;

@override
  void initState() {
   Authen;
    super.initState();
  }

  

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Authen, 
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          
          if(snapshot.data?.email.toString() != 'admin@lapuertawaco.com'){
            
            return const Mainwrapper();
          }
          return const LoginNow();
        }else {
          return const LoginNow();
        }
      },
    );
  }
}



