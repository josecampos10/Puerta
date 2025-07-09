import 'package:lapuerta2/administrador/AdminloginCheck.dart';
import 'package:lapuerta2/administrador/admin_auth.dart';
import 'package:lapuerta2/administrador/admin_mainwrapper.dart';
import 'package:flutter/material.dart';



class AdminWidgetTree extends StatefulWidget{
  const AdminWidgetTree({Key? key}) : super(key: key);

  @override 
  State<AdminWidgetTree> createState() => _AdminWidgetTreeState();
}

class _AdminWidgetTreeState extends State<AdminWidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AdminAuth().authStateChanges, 
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if(snapshot.data?.email.toString() == 'admin@lapuertawaco.com'){
            return AdminMainwrapper();
          }
          return AdminLoginNow();
        }else {
          return const AdminLoginNow();
        }
      },
    );
  }
}



