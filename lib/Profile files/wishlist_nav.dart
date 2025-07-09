import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lapuerta2/Profile%20files/change_password_view.dart';
import 'package:lapuerta2/Profile%20files/details_wishlist_view.dart';
import 'package:lapuerta2/Profile%20files/payment.dart';
import 'package:lapuerta2/profileHome.dart';
import 'package:lapuerta2/scan_page.dart';

class Wishlist extends StatefulWidget{
  
  const Wishlist({Key? key,}): super(key: key);
  @override
  State<Wishlist> createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> with TickerProviderStateMixin {
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
            return Profilehome();
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