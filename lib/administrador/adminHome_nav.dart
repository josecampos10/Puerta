import 'package:flutter/material.dart';
import 'package:lapuerta2/administrador/adminClases.dart';
import 'package:lapuerta2/administrador/adminControl.dart';
import 'package:lapuerta2/administrador/adminPosts.dart';
import 'package:lapuerta2/administrador/adminPublicaciones.dart';
import 'package:lapuerta2/administrador/adminRecursos.dart';
import 'package:lapuerta2/administrador/adminUsuarios.dart';
import 'package:lapuerta2/administrador/admin_panel.dart';

class AdminhomeNav extends StatefulWidget{
  const AdminhomeNav({super.key});
  @override
  State<AdminhomeNav> createState() => _AdminhomeNavState();
}

class _AdminhomeNavState extends State<AdminhomeNav> with TickerProviderStateMixin {
  GlobalKey<NavigatorState> wishlistNavigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    return Navigator(
      
      key: wishlistNavigatorKey,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          
          settings: settings,
          builder: (BuildContext context) {
            
           
            if (settings.name == '/recursos') {
              //details page
              return Adminrecursos();
            }
            if (settings.name == '/clases') {
              //details page
              return Adminclases();
            }
            if (settings.name == '/publicaciones') {
              //details page
              return Adminpublicaciones();
            }
            if (settings.name == '/usuarios') {
              //details page
              return AdminUsuarios();
            }
            if (settings.name == '/control') {
              //details page
              return AdminControl();
            }
            if (settings.name == '/posts') {
              //details page
              return AdminPosts();
            }
            //main Page
            return AdminPanel();
          }
        );
      },
    );
  }

   
}
class SlideRoute extends PageRouteBuilder {
  final Widget page;
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