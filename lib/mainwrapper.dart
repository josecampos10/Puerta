import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lapuerta2/Profile%20files/wishlist_nav.dart';
import 'package:lapuerta2/UserhomePrincipal.dart';

import 'package:lapuerta2/scan_page.dart';
import 'package:lapuerta2/Students%20Clases/studentClases_nav.dart';

class Mainwrapper extends StatefulWidget {
  const Mainwrapper({super.key});
  @override
  State<Mainwrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<Mainwrapper> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  int _selectedIndex = 0;
  int _notificationCount = 0; // Count of new notifications

  PageController? _pageController;

  Key _screenKey = UniqueKey();

  @override
  void initState() {
    super.initState();

    _listenForNewPosts();
    FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser?.email)
        .update({'token': FirebaseMessaging.instance.getToken()});
    setState(() {
      imageCache.clear();
      imageCache.clearLiveImages();
    });
    _pageController = PageController(initialPage: 1, keepPage: false);
  }

  /// Listens for new posts in Firestore and updates the notification count
  void _listenForNewPosts() {
    FirebaseFirestore.instance
        .collection('posts')
        .snapshots()
        .listen((querySnapshot) {
          /*querySnapshot.docChanges.forEach((change){
            _notificationCount += querySnapshot.docChanges.length;
          });*/
      if (querySnapshot.docChanges.isNotEmpty) {
        setState(() {
          _notificationCount += querySnapshot.docChanges.length; // Increase count
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Handles navigation bar taps
  void _onItemTapped(int index) {
    setState(() {
      imageCache.clear();
      imageCache.clearLiveImages();
      _selectedIndex = index;
      if (index == 3) {
        // Notifications tab index
        _notificationCount = 0; // Reset notification count when opened
      }
    });
  }

  void _tapped(int index) {
    setState(() {
      _selectedIndex = index;
      _pageController!.animateToPage(index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return UserhomePrincipal(key: _screenKey);
      case 1:
        return StudentclasesNav(key: _screenKey);
      case 2:
        return Notifications(key: _screenKey);
      case 3:
        return Wishlist(key: _screenKey);
      default:
        return UserhomePrincipal(key: _screenKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: Container(
        height: size.height * 0.065,
        child: BottomNavigationBar(
            type: BottomNavigationBarType.shifting,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedLabelStyle: TextStyle(fontSize: size.height * 0.001),
            selectedItemColor: Colors.white,
            unselectedItemColor: Color.fromRGBO(44, 44, 44, 1),
            selectedIconTheme: IconThemeData(size: size.height * 0.03),
            unselectedIconTheme: IconThemeData(size: size.height * 0.025),
            currentIndex: _selectedIndex,
            onTap: (index) {
              imageCache.clear();
              imageCache.clearLiveImages();
              setState(() {
                _selectedIndex = index;
                if (index == 2) {
                  _notificationCount = 0;
                }
               if (index == 0) {
                  _notificationCount;
                }
                if (_selectedIndex == index) {
                  // Fuerza la reconstrucción si se toca el mismo tab
                  _screenKey = UniqueKey();
                } else {
                  _selectedIndex = index;
                  _screenKey = UniqueKey();
                }
              });
            },
            items: [
              BottomNavigationBarItem(
                  //key: homescreen,
                  icon: Icon(
                    Icons.home,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  label: ''),
              BottomNavigationBarItem(
                  //key: _reminderDetailsKey,
                  icon: Icon(
                    Icons.class_,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  label: ''),
              BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      Icon(
                        Icons.notifications,
                        //color: const Color.fromRGBO(3, 67, 87, 1),
                      ),
                      if (_notificationCount >
                          0) // Show badge only if there are new notifications
                        Positioned(
                          right: size.width * 0.01,
                          top: 0,
                          bottom: size.width * 0.02,
                          child: Container(
                            padding: EdgeInsets.only(),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                                maxHeight: size.width * 0.018,
                                maxWidth: size.width * 0.018,
                                minWidth: size.width * 0.018,
                                minHeight: size.width * 0.018),
                            child: Text(
                              '$_notificationCount',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: size.width * 0.0,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  label: ''),
            ]),
      ),

      /*NavigationBar(
        labelPadding: EdgeInsets.only(bottom: 0),
          height: size.height*0.08,
          backgroundColor: const Color.fromARGB(255, 4, 99, 128),
          indicatorColor: Colors.transparent,
          shadowColor: Colors.transparent,
          selectedIndex: _selectedIndex,
          surfaceTintColor: Colors.transparent,
          onDestinationSelected: _onItemTapped,
          destinations: <NavigationDestination>[
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.home,
                  color: Colors.white,
                  size: size.width * 0.06,
                ),
                icon: Icon(
                  Icons.home_outlined,
                  color: Colors.white30,
                  size: size.width * 0.06,
                ),
                label: ''),
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.chat,
                  color: Colors.white,
                  size: size.width * 0.06,
                ),
                icon: Icon(
                  Icons.chat_outlined,
                  color: Colors.white30,
                  size: size.width * 0.06,
                ),
                label: ''),
            NavigationDestination(
                selectedIcon: Icon(
                  Icons.class_,
                  color: Colors.white,
                  size: size.width * 0.06,
                ),
                icon: Icon(
                  Icons.class_outlined,
                  color: Colors.white30,
                  size: size.width * 0.06,
                ),
                label: ''),
            NavigationDestination(
                selectedIcon: Icon(Icons.notifications,
                    color: Colors.white, size: size.width * 0.06),
                icon: Stack(
                  children: [
                    Icon(Icons.notifications_outlined,
                        color: Colors.white30, size: size.width * 0.06),
                    if (_notificationCount >
                        0) // Show badge only if there are new notifications
                      Positioned(
                        right: size.width*0.02,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          padding: EdgeInsets.only(),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          constraints: BoxConstraints(
                            maxHeight: size.width*0.01,
                            maxWidth: size.width*0.005,
                             minWidth: size.width*0.005,
                            minHeight: size.width*0.005
                          ),
                          child: Text(
                            '$_notificationCount',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontSize: size.width*0.03,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
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
                label: '')
          ]),*/

      body: Scaffold(
        //top: false,
        body: _getScreen(_selectedIndex),

        /*IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            Navigator(
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => UserhomePrincipal(),
              ),
            ),
            Navigator(
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => StudentclasesNav(),
              ),
            ),
            Navigator(
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => Notifications(),
              ),
            ),
            Navigator(
              onGenerateRoute: (route) => MaterialPageRoute(
                settings: route,
                builder: (context) => Wishlist(),
              ),
            ),
          ],
        ),*/

        /*IndexedStack(
            index: _selectedIndex,
            children: [
              UserhomePrincipal(),
              //UserchatHome(),
              StudentclasesNav(),
              Notifications(),
              Wishlist(),
            ],
          )*/
      ),
    );
  }
}
