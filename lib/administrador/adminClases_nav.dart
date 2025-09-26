import 'package:flutter/material.dart';
import 'package:lapuerta2/Profe%20Clasess/Ciudadania/profeCiudadania.dart';
import 'package:lapuerta2/Profe%20Clasess/Ciudadania/profeCiudadania_files.dart';
import 'package:lapuerta2/Profe%20Clasess/Ciudadania/profeCiudadania_students.dart';
import 'package:lapuerta2/Profe%20Clasess/Cosmetologia/profeCosmetologia.dart';
import 'package:lapuerta2/Profe%20Clasess/Cosmetologia/profeCosmetologia_files.dart';
import 'package:lapuerta2/Profe%20Clasess/Cosmetologia/profeCosmetologia_students.dart';
import 'package:lapuerta2/Profe%20Clasess/Costura%20_am/profeCostura_am.dart';
import 'package:lapuerta2/Profe%20Clasess/Costura%20_am/profeCostura_files_am.dart';
import 'package:lapuerta2/Profe%20Clasess/Costura%20_am/profeCostura_students_am.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%201%20%20pm/profeESLpm.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%201%20%20pm/profeESLpm_files.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%201%20%20pm/profeESLpm_students.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%202%20PM/profeESLpm2.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%202%20PM/profeESLpm2_files.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%202%20PM/profeESLpm2_students.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Chick%20fila/profechick.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Chick%20fila/profechick_files.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Chick%20fila/profechick_students.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Clifton/profeESL_Clifton.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Clifton/profeESLclifton_files.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Clifton/profeESLclifton_students.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Corte%202/profeCorte2.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Corte%202/profeCorte2_files.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Corte%202/profeCorte2_students.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Corte1/profeCorte1.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Corte1/profeCorte1_files.dart';
import 'package:lapuerta2/Profe%20Clasess/ESL%20Corte1/profeCorte1_students.dart';
import 'package:lapuerta2/Profe%20Clasess/ESLam/profeESLam.dart';
import 'package:lapuerta2/Profe%20Clasess/ESLam/profeESLam_files.dart';
import 'package:lapuerta2/Profe%20Clasess/ESLam/profeESLam_students.dart';
import 'package:lapuerta2/Profe%20Clasess/ESLam2/profeESLam2.dart';
import 'package:lapuerta2/Profe%20Clasess/ESLam2/profeESLam2_files.dart';
import 'package:lapuerta2/Profe%20Clasess/ESLam2/profeESLam2_students.dart';
import 'package:lapuerta2/Profe%20Clasess/GED_am/profeGEDam.dart';
import 'package:lapuerta2/Profe%20Clasess/GED_am/profeGEDam_files.dart';
import 'package:lapuerta2/Profe%20Clasess/GED_am/profeGEDam_students.dart';
import 'package:lapuerta2/Profe%20Clasess/GED_pm/profeGED.dart';
import 'package:lapuerta2/Profe%20Clasess/GED_pm/profeGED_files.dart';
import 'package:lapuerta2/Profe%20Clasess/GED_pm/profeGED_students.dart';
import 'package:lapuerta2/Profe%20Clasess/GEDam2/profeGEDam2.dart';
import 'package:lapuerta2/Profe%20Clasess/GEDam2/profeGEDam2_files.dart';
import 'package:lapuerta2/Profe%20Clasess/GEDam2/profeGEDam2_students.dart';
import 'package:lapuerta2/Profe%20Clasess/GEDpm2/profeGED2.dart';
import 'package:lapuerta2/Profe%20Clasess/GEDpm2/profeGED2_files.dart';
import 'package:lapuerta2/Profe%20Clasess/GEDpm2/profeGED2_students.dart';
import 'package:lapuerta2/Profe%20Clasess/feed/feedlapuerta.dart';
import 'package:lapuerta2/administrador/adminClases.dart';
import 'package:lapuerta2/administrador/adminControl.dart';
import 'package:lapuerta2/administrador/adminPosts.dart';
import 'package:lapuerta2/administrador/adminPublicaciones.dart';
import 'package:lapuerta2/administrador/adminRecursos.dart';
import 'package:lapuerta2/administrador/adminUsuarios.dart';
import 'package:lapuerta2/administrador/admin_dashboard.dart';
import 'package:lapuerta2/administrador/admin_panel.dart';
import 'package:lapuerta2/administrador/admin_wishlist_nav.dart';

class AdminclasesNav extends StatefulWidget{
  const AdminclasesNav({super.key});
  @override
  State<AdminclasesNav> createState() => _AdminclasesNavState();
}

class _AdminclasesNavState extends State<AdminclasesNav> with TickerProviderStateMixin {
  GlobalKey<NavigatorState> wishlistNavigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    return Navigator(
      
      key: wishlistNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          
          settings: settings,
          builder: (BuildContext context) {
            

//***********************************PROFESORES ***************************
              //GED PM////
              if (settings.name == '/profeGEDpm') {
                return Profegedpm();
              }
              if (settings.name == '/profeGEDpm_files') {
                return Profegedfilespm();
              }
              if (settings.name == '/profeGEDpm_students') {
                return Profegedstudentspm();
              }
               //GED PM 2////
              if (settings.name == '/profeGEDpm2') {
                return Profegedpm2();
              }
              if (settings.name == '/profeGEDpm2_files') {
                return Profegedfilespm2();
              }
              if (settings.name == '/profeGEDpm2_students') {
                return Profegedstudentspm2();
              }
              //GED AM///
              if (settings.name == '/profeGEDam') {
                return Profegedam();
              }
              if (settings.name == '/profeGEDam_files') {
                return Profegedfilesam();
              }
              if (settings.name == '/profeGEDam_students') {
                return Profegedstudentsam();
              }
              //GED AM 2///
              if (settings.name == '/profeGEDam2') {
                return Profegedam2();
              }
              if (settings.name == '/profeGEDam2_files') {
                return Profegedfilesam2();
              }
              if (settings.name == '/profeGEDam2_students') {
                return Profegedstudentsam2();
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
              //ESL AM 1 //
              if (settings.name == '/profeESLam') {
                return Profeeslam();
              }
              if (settings.name == '/profeESLam_files') {
                return Profeeslfilesam();
              }
              if (settings.name == '/studentESLam_students') {
                return Profeeslstudentsam();
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
              ////// ESL AM 2 /////
              if (settings.name == '/profeESLam2') {
                return Profeeslam2();
              }
              if (settings.name == '/profeESLam2_files') {
                return Profeeslfilesam2();
              }
              if (settings.name == '/studentESLam2_students') {
                return Profeeslstudentsam2();
              }
              ////// ESL CHICK-FIL-A /////
              if (settings.name == '/profechick') {
                return Profechick();
              }
              if (settings.name == '/profechick_files') {
                return Profechickfiles();
              }
              if (settings.name == '/studentchick_students') {
                return Profechickstudents();
              }
              /////COSTURA AM ///////
              if (settings.name == '/profeCosturaAM') {
                return ProfeCosturaAM();
              }
              if (settings.name == '/profeCostura_filesAM') {
                return ProfeCosturafilesAM();
              }
              if (settings.name == '/profeCostura_students') {
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
               /////CORTE Y CONFECCION 1 ///////
              if (settings.name == '/profeCorte1') {
                return ProfeCorte1();
              }
              if (settings.name == '/profeCorte1_files') {
                return ProfeCorte1files();
              }
              if (settings.name == '/profeCorte1_students') {
                return ProfeCorte1students();
              }
               /////CORTE Y CONFECCION 2 ///////
              if (settings.name == '/profeCorte2') {
                return ProfeCorte2();
              }
              if (settings.name == '/profeCorte2_files') {
                return ProfeCorte2files();
              }
              if (settings.name == '/profeCorte2_students') {
                return ProfeCorte2students();
              }
              //ESL CLIFTON //
              if (settings.name == '/profeESLclifton') {
                return Profeeslclifton();
              }
              if (settings.name == '/profeESLclifton_files') {
                return Profeeslfilesclifton();
              }
              if (settings.name == '/studentESLclifton_students') {
                return Profeeslstudentsclifton();
              }
              


            //main Page
            return Adminclases();
          }
        );
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