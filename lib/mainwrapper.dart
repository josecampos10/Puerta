import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lapuerta2/Profile%20files/wishlist_nav.dart';
import 'package:lapuerta2/UserhomePrincipal.dart';
import 'package:lapuerta2/onboarding.dart';

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
  String userRole = '';

  PageController? _pageController;

  Key _screenKey = UniqueKey();

  void _saveTokenToFirestore() async {
  final token = await FirebaseMessaging.instance.getToken(); // ✅ Espera el token
  final email = currentUser?.email;
  if (email != null && token != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .update({'token': token});
  }
}
  

    Future<void> getUserRole() async {
    final email = FirebaseAuth.instance.currentUser?.email;
    if (email == null) return;

    final doc = await FirebaseFirestore.instance.collection('users').doc(email).get();
    if (doc.exists) {
      setState(() {
        userRole = doc.data()?['rol'] ?? '';
      });
    }
  }
  
  @override
  void initState() {
    super.initState();
    _listenForNewPosts();
    _saveTokenToFirestore();
    setState(() {
      imageCache.clear();
      imageCache.clearLiveImages();
    });
    _pageController = PageController(initialPage: 1, keepPage: false);
    getUserRole();
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
      bottomNavigationBar: SizedBox(
        height: size.height * 0.09,
        child: BottomNavigationBar(
          //enableFeedback: false,
          //iconSize: 19,
            type: BottomNavigationBarType.shifting,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedLabelStyle: TextStyle(fontSize: size.height * 0.001),
            selectedItemColor: Colors.white,
            unselectedItemColor: Color.fromRGBO(143, 143, 143, 0.526),
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
                     userRole == 'Donante' ? Icons.volunteer_activism : Icons.class_,
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


      body: Scaffold(
        //top: false,
        body: _getScreen(_selectedIndex),
      ),
    );
  }
}
