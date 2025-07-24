import 'package:flutter/material.dart';
import 'package:lapuerta2/administrador/adminHome_nav.dart';
import 'package:lapuerta2/administrador/admin_wishlist_nav.dart';

class AdminMainwrapper extends StatefulWidget {
  const AdminMainwrapper({super.key});
  @override
  State<AdminMainwrapper> createState() => _AdminMainWrapperState();
}

class _AdminMainWrapperState extends State<AdminMainwrapper> {
  int _selectedIndex = 0;
  Key _screenKey = UniqueKey();

  /// Devuelve el widget según el índice seleccionado
  Widget _getScreen(int index) {
    switch (index) {
      case 0:
        return AdminhomeNav(key: _screenKey);
      case 1:
        return AdminWishlist(key: _screenKey);
      default:
        return AdminhomeNav(key: _screenKey);
    }
  }

  /// Maneja la selección del tab
  void _onItemTapped(int index) {
    setState(() {
      if (_selectedIndex == index) {
        // Si se toca el mismo tab, se fuerza la reconstrucción
        _screenKey = UniqueKey();
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: NavigationBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        indicatorColor: Colors.transparent,
        shadowColor: Colors.transparent,
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home_max,
              color: Colors.white,
              size: size.height * 0.05,
            ),
            icon: Icon(
              Icons.home_max_outlined,
              color: Colors.white30,
              size: size.height * 0.04,
            ),
            label: '',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.person,
              color: Colors.white,
              size: size.height * 0.05,
            ),
            icon: Icon(
              Icons.person_outline,
              color: Colors.white30,
              size: size.height * 0.04,
            ),
            label: '',
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: _getScreen(_selectedIndex),
      ),
    );
  }
}

