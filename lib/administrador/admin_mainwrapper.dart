import 'package:flutter/material.dart';
import 'package:lapuerta2/administrador/adminHome_nav.dart';
import 'package:lapuerta2/administrador/admin_profileHome.dart';
import 'package:lapuerta2/administrador/admin_wishlist_nav.dart';

class AdminMainwrapper extends StatefulWidget {
  const AdminMainwrapper({super.key});
  @override
  State<AdminMainwrapper> createState() => _AdminMainWrapperState();
}

class _AdminMainWrapperState extends State<AdminMainwrapper> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: NavigationBar(
          height: size.width * 0.15,
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          indicatorColor: Colors.transparent,
          shadowColor: Colors.transparent,
          selectedIndex: _selectedIndex,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          destinations: <NavigationDestination>[
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.home_max,
                  color: Colors.white,
                  size: size.width * 0.06,
                ),
                icon: Icon(
                  Icons.home_max_outlined,
                  color: Colors.white30,
                  size: size.width * 0.06,
                ),
                label: ''),
            
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: size.width * 0.06,
                ),
                icon: Icon(
                  Icons.person_outline,
                  color: Colors.white30,
                  size: size.width * 0.06,
                ),
                label: ''),
            /*NavigationDestination(
            selectedIcon: Icon(Icons.map),
            icon: Icon(Icons.map_outlined), 
            label: ''
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.notifications),
            icon: Icon(Icons.notifications_outlined), 
            label: ''
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline), 
            label: ''
          )*/
          ]),
      body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              AdminhomeNav(),
              
              AdminWishlist(),
              /*ChatPageNav(),
            Donate(),
            Notifications(),
            Wishlist(),*/
            ],
          )),
    );
  }
}
