import 'package:flutter/material.dart';
import 'package:lapuerta2/Profile%20files/change_password_view.dart';
import 'package:lapuerta2/Profile%20files/details_wishlist_view.dart';
import 'package:lapuerta2/Profile%20files/payment.dart';
import 'package:lapuerta2/administrador/admin_change_password_view.dart';
import 'package:lapuerta2/administrador/admin_details_wishlist_view.dart';
import 'package:lapuerta2/administrador/admin_payment.dart';
import 'package:lapuerta2/administrador/admin_profileHome.dart';
import 'package:lapuerta2/scan_page.dart';

class AdminWishlist extends StatefulWidget{
  const AdminWishlist({super.key});
  @override
  State<AdminWishlist> createState() => _AdminWishlistState();
}

class _AdminWishlistState extends State<AdminWishlist> with TickerProviderStateMixin {
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
              return DetailsWishlistView();
            }
            if (settings.name == '/changePassword') {
              //details page
              return changePasswordView();
            }
            if (settings.name == '/notifications') {
              //details page
              return Notifications();
            }
            if (settings.name == '/payment') {
              //details page
              return Payment();
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