import 'package:flutter/material.dart';
import 'package:lapuerta2/Profe%20Clasess/Ciudadania/profeCiudadania.dart';
import 'package:lapuerta2/Profe%20Clasess/Ciudadania/profeCiudadania_students.dart';
import 'package:lapuerta2/Profe%20Clasess/Cosmetologia/profeCosmetolog%C3%ADa_files.dart';
import 'package:lapuerta2/Profe%20Clasess/Cosmetologia/profeCosmetologia.dart';
import 'package:lapuerta2/Profe%20Clasess/Cosmetologia/profeCosmetologia_students.dart';
import 'package:lapuerta2/Profe%20Clasess/Costura%20_am/profeCostura_students.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%201%20%20pm/profeESLpm_students.dart';

import 'package:lapuerta2/Profe%20Clasess/Ciudadania/profeCiudadania_files.dart';
import 'package:lapuerta2/Profe%20Clasess/Costura%20_am/profeCostura_am.dart';
import 'package:lapuerta2/Profe%20Clasess/Costura%20_am/profeCostura_files_AM.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%201%20%20pm/profeESLpm.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%201%20%20pm/profeESLpm_files.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%202%20PM/profeESL2pm.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%202%20PM/profeESLpm2_files.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%202%20PM/profeESLpm2_students.dart';
import 'package:lapuerta2/Profe%20Clasess/GED_pm/profeGED.dart';
import 'package:lapuerta2/Profe%20Clasess/GED_pm/profeGED_files.dart';
import 'package:lapuerta2/Profe%20Clasess/GED_pm/profeGED_students.dart';
import 'package:lapuerta2/Profe%20Clasess/feed/feedlapuerta.dart';
import 'package:lapuerta2/Students%20Clases/Cosmetologia/studentCosmetologia.dart';
import 'package:lapuerta2/Students%20Clases/Cosmetologia/studentCosmetologia_files.dart';
import 'package:lapuerta2/UsermapHome.dart';

import 'package:lapuerta2/Students%20Clases/Ciudadania/studentCiudadania.dart';
import 'package:lapuerta2/Students%20Clases/Ciudadania/studentCiudadania_files.dart';
import 'package:lapuerta2/Students%20Clases/Costura%20am/studentCostura.dart';
import 'package:lapuerta2/Students%20Clases/Costura%20am/studentCostura_files.dart';
import 'package:lapuerta2/Students%20Clases/ESL%20pm/studentESL.dart';
import 'package:lapuerta2/Students%20Clases/ESL%20pm/studentESL_files.dart';
import 'package:lapuerta2/Students%20Clases/GED%20pm/studentGED.dart';
import 'package:lapuerta2/Students%20Clases/GED%20pm/studentGED_files.dart';

class StudentclasesNav extends StatefulWidget {
  const StudentclasesNav({super.key});
  @override
  State<StudentclasesNav> createState() => _StudentclasesNavState();
}

class _StudentclasesNavState extends State<StudentclasesNav>
    with TickerProviderStateMixin {
  GlobalKey<NavigatorState> wishlistNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: wishlistNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              ////////////////////////ESTUDIANTES//////////////////////************** */
              ///ESL PM////
              if (settings.name == '/studentESLpm') {
                return Studenteslpm();
              }
              if (settings.name == '/studentESLpm_files') {
                return Studenteslfilespm();
              }
              
              ////// GED PM/////////
              if (settings.name == '/studentGEDpm') {
                return Studentgedpm();
              }
              if (settings.name == '/studentGEDpm_files') {
                return Studentgedfilespm();
              }
              ///////COSTURA AM ////////////
              if (settings.name == '/studentCosturaAM') {
                return StudentCosturaAM();
              }
              if (settings.name == '/studentCostura_filesAM') {
                return StudentCosturafilesAM();
              }
              /////////////CIUDADANIA//////////////////
              if (settings.name == '/studentCiudadania') {
                //details page
                return StudentCiudadania();
              }
              if (settings.name == '/studentCiudadania_files') {
                //details page
                return StudentCiudadaniafiles();
              }
              ///////////////COSMETOLOGIA///////////////////////
               if (settings.name == '/studentCosmetologia') {
                //details page
                return StudentCosmetologia();
              }
              if (settings.name == '/studentCosmetologia_files') {
                //details page
                return StudentCosmetologiafiles();
              }
              

              //***********************************PROFESORES ***************************
              //GED PM////
              if (settings.name == '/profeGEDpm') {
                return Profegedpm();
              }
              if (settings.name == '/profeGEDpm_files') {
                return Profegedfilespm();
              }
              if (settings.name == '/studentGEDpm_students') {
                return Profegedstudentspm();
              }
              //ESL PM 1 //
              if (settings.name == '/profeESLpm') {
                return Profeeslpm();
              }
              if (settings.name == '/profeESLpm_files') {
                return Profeeslfilespm();
              }
              if (settings.name == '/studentESLpm_students') {
                return Profeeslstudentspm();
              }
              ////// ESL PM 2 /////
              if (settings.name == '/profeESLpm2') {
                return Profeeslpm2();
              }
              if (settings.name == '/profeESLpm2_files') {
                return Profeeslfilespm2();
              }
              if (settings.name == '/studentESLpm2_students') {
                return Profeeslstudentspm2();
              }
              /////COSTURA AM ///////
              if (settings.name == '/profeCosturaAM') {
                return ProfeCosturaAM();
              }
              if (settings.name == '/profeCostura_filesAM') {
                return ProfeCosturafilesAM();
              }
              if (settings.name == '/studentCostura_students') {
                return ProfeCosturastudents();
              }
              //////////////////CIUDADANIA////////////////
              if (settings.name == '/profeCiudadania') {
                return ProfeCiudadania();
              }
              if (settings.name == '/profeCiudadania_files') {
                return ProfeCiudadaniafiles();
              }
              if (settings.name == '/studentCiudadania_students') {
                return ProfeCiudadaniastudents();
              }
              ////////////////COSMETOLOGIA///////////////// 
              if (settings.name == '/profeCosmetologia') {
                return ProfeCosmetologia();
              }
              if (settings.name == '/profeCosmetologia_files') {
                return ProfeCosmetologiafiles();
              }
              if (settings.name == '/studentCosmetologia_students') {
                return Profecosmetologiastudents();
              }
              ////////////////////////FEED LA PUERTA///////////////////
              if (settings.name == '/profefeedlapuerta') {
                return feedLaPuerta();
              }

              //main Page
              return UsermapHome();
            });
      },
    );
  }
}

class SlideRoute extends PageRouteBuilder {
  final Widget page;
  @override
  final RouteSettings settings;
  SlideRoute({required this.page, required this.settings})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          settings: settings,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}
