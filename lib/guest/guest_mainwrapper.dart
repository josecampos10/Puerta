import 'package:flutter/material.dart';
import 'package:lapuerta2/guest/guest_donateHome.dart';
import 'package:lapuerta2/guest/guest_homePrincipal.dart';

class GuestMainwrapper extends StatefulWidget {
  const GuestMainwrapper({super.key});
  @override
  State<GuestMainwrapper> createState() => _GuestMainWrapperState();
}

class _GuestMainWrapperState extends State<GuestMainwrapper> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: SizedBox(
        //padding: EdgeInsets.only(top: 40),

        height: size.height * 0.09,
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedLabelStyle: TextStyle(fontSize: size.height * 0.001),
            selectedItemColor: Colors.white,
            unselectedItemColor: Color.fromRGBO(3, 67, 87, 1),
            //backgroundColor: Colors.green,
            //iconSize: size.height * 0.025,
            selectedIconTheme: IconThemeData(size: size.height*0.03),
            unselectedIconTheme: IconThemeData(size: size.height*0.025),
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
                
                
              });
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  label: ''),
              /*BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                  ),
                  backgroundColor: Color.fromRGBO(4, 99, 128, 1), label: ''),*/
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.map,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.tertiary, label: ''),
              
              /*BottomNavigationBarItem(
                  icon: Icon(
                    Icons.message,
                  ),
                  backgroundColor: Color.fromRGBO(4, 99, 128, 1), label: ''),*/
            ]),
      ),
      body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              GuesthomePrincipal(),
              GuestdonateHome(),
              //GuestMapHome()
              //Notifications(),
              //Wishlist(),
            ],
          )),
    );
  }
}
