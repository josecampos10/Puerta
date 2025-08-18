import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lapuerta2/Profe%20Clasess/Donantes_feed/Donantesfeed.dart';
import 'package:lapuerta2/administrador/adminClases.dart';
import 'package:lapuerta2/administrador/adminClases_nav.dart';
import 'package:lapuerta2/administrador/adminHome_nav.dart';
import 'package:lapuerta2/administrador/adminPerfil_nav.dart';
import 'package:lapuerta2/administrador/adminPosts.dart';
import 'package:lapuerta2/administrador/adminPublicaciones.dart';
import 'package:lapuerta2/administrador/adminUsuarios.dart';
import 'package:lapuerta2/administrador/admin_DonantesNav.dart';
import 'package:lapuerta2/administrador/admin_dashboard.dart';
import 'package:lapuerta2/administrador/admin_profileHome.dart';
import 'package:lapuerta2/administrador/admin_wishlist_nav.dart';

class AdminMainwrapper extends StatefulWidget {
  const AdminMainwrapper({super.key});
  @override
  State<AdminMainwrapper> createState() => _AdminMainWrapperState();
}

class _AdminMainWrapperState extends State<AdminMainwrapper> {
  int _selectedIndex = 0;
  Key _screenKey = UniqueKey();
  Uint8List? pickedImage;
  final currentUser = FirebaseAuth.instance.currentUser!;

  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return AdminhomeNav(key: _screenKey);
      case 1:
        return AdminclasesNav(key: _screenKey);
      case 2:
        return AdminUsuarios(key: _screenKey);
      case 3:
        return AdminPosts(key: _screenKey);
      case 4:
        return AdminDonantesNav(key: _screenKey);
      case 5:
        return AdminperfilNav(key: _screenKey);
      default:
        return AdminhomeNav(key: _screenKey);
    }
  }

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUser!.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      print('Profile Picture could not be found');
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex == index) {
        _screenKey = UniqueKey();
      }
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    getProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            
            width: size.width * 0.13,
            child: NavigationRail(
              
              minWidth: size.width * 0.05,
              unselectedLabelTextStyle:
                  TextStyle(color: Colors.white30, fontWeight: FontWeight.bold),
              selectedLabelTextStyle:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              indicatorColor: Theme.of(context).colorScheme.tertiary,
              leading: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: size.height * 0.1,
                      width: size.width * 0.11,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(40)),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: size.height * 0.084,
                            width: size.width * 0.08,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Color.fromRGBO(255, 255, 255, 0),
                                  width: size.height * 0.000,
                                ),
                                shape: BoxShape.rectangle,
                                image: pickedImage != null
                                    ? DecorationImage(
                                        fit: BoxFit.cover,
                                        image: Image.memory(
                                          pickedImage!,
                                          key: UniqueKey(),
                                        ).image)
                                    : null),
                          ),
                        ],
                      ),
                    ),
                    
                  ],
                ),
              ),
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              selectedIconTheme: IconThemeData(color: Colors.white, size: 32),
              unselectedIconTheme:
                  IconThemeData(color: Colors.white30, size: 28),
              labelType: NavigationRailLabelType
                  .none, // You can use .selected or .all if you want labels visible
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.dashboard_outlined),
                  selectedIcon: Icon(
                    Icons.dashboard,
                  ),
                  label: Text('Panel'),
                ),
                 NavigationRailDestination(
                  icon: Icon(Icons.school_outlined),
                  selectedIcon: Icon(
                    Icons.person,
                  ),
                  label: Text('Clases'),
                ),
                
                NavigationRailDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(
                    Icons.person,
                  ),
                  label: Text('Usuarios'),
                ),
                 NavigationRailDestination(
                  icon: Icon(Icons.feed_outlined),
                  selectedIcon: Icon(
                    Icons.feed,
                  ),
                  label: Text('Contenido'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.volunteer_activism_outlined),
                  selectedIcon: Icon(
                    Icons.volunteer_activism,
                  ),
                  label: Text('Donantes'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person_2_outlined),
                  selectedIcon: Icon(
                    Icons.person_2,
                  ),
                  label: Text('Perfil'),
                ),
              ],
              // Optional: Show text next to icon when expanded
              extended:
                  true, // Use this to show icons *with* labels side-by-side
            ),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
            color: Theme.of(context).colorScheme.tertiary,
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: _getScreen(_selectedIndex),
            ),
          ),
        ],
      ),
    );
  }
}
