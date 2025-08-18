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
import 'package:lapuerta2/Profe%20Clasess/feed/feedlapuerta.dart';
import 'package:lapuerta2/administrador/adminClases.dart';
import 'package:lapuerta2/administrador/adminControl.dart';
import 'package:lapuerta2/administrador/adminPosts.dart';
import 'package:lapuerta2/administrador/adminPublicaciones.dart';
import 'package:lapuerta2/administrador/adminRecursos.dart';
import 'package:lapuerta2/administrador/adminUsuarios.dart';
import 'package:lapuerta2/administrador/admin_dashboard.dart';
import 'package:lapuerta2/administrador/admin_details_wishlist_view.dart';
import 'package:lapuerta2/administrador/admin_panel.dart';
import 'package:lapuerta2/administrador/admin_profileHome.dart';
import 'package:lapuerta2/administrador/admin_wishlist_nav.dart';

class AdminperfilNav extends StatefulWidget{
  const AdminperfilNav({super.key});
  @override
  State<AdminperfilNav> createState() => _AdminperfilNavState();
}

class _AdminperfilNavState extends State<AdminperfilNav> with TickerProviderStateMixin {
  GlobalKey<NavigatorState> wishlistNavigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    return Navigator(
      
      key: wishlistNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          
          settings: settings,
          builder: (BuildContext context) {
            
           
            if (settings.name == '/detailsWishlist') {
              //details page
              return AdminDetailsWishlistView();
            }
            


            //main Page
            return AdminProfilehome();
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