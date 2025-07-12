import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:lapuerta2/administrador/admin_widget_tree.dart';

import 'package:lapuerta2/guest/guest_mainwrapper.dart';
import 'package:lapuerta2/widget_tree.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPage();
}

class _OnboardingPage extends State<OnboardingPage>
    with TickerProviderStateMixin {
  final List element = [
    'assets/img/foto1.jpg',
    'assets/img/foto2.jpg',
    'assets/img/foto3.jpg',
    'assets/img/foto4.jpg',
    'assets/img/foto5.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Container(
        height: size.height,
        width: size.width,
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          image: DecorationImage(
              filterQuality: FilterQuality.low,
              image: AssetImage('assets/img/foto4.jpg'),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3), BlendMode.dstATop),
              fit: BoxFit.cover),
        ),
        child: Center(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.00,
              ),
              Hero(
                tag: 'logo',
                child: Container(
                  width: size.height * 0.17,
                  height: size.height * 0.17,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      scale: size.height * 0.0048,
                      alignment: Alignment(0, 0),
                      image: AssetImage('assets/img/logo.png'),
                      //fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Text(
                'Welcome to La Puerta',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.1,
                  fontFamily: "Personal",
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Empowering the Spanish-speaking community with life-changing resources',
                maxLines: 3,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.04,
                  fontFamily: "Calibri",
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Builder(
                builder: (context) {
                  return CarouselSlider(
                      items: element.map((element) {
                        return Builder(builder: (context) {
                          return ClipRRect(
                              borderRadius: BorderRadius.circular(26),
                              child: Image.asset(
                                element.toString(),
                                //cacheHeight: 500,
                                //cacheWidth: 600,
                                fit: BoxFit.cover,
                                width: size.width,
                                filterQuality: FilterQuality.low,
                              ));
                        });
                      }).toList(),
                      options: CarouselOptions(
                        //aspectRatio: 15.0,
                        height: size.height * .3,
                        enlargeCenterPage: true,
                        autoPlay: true,
                      ));
                },
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
              SizedBox(
                  width: size.width*0.5 ,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    
                    onPressed: () =>
                        //CHANGE THIS FOR ADMIN AND USER
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => WidgetTree())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      'Ingresar a La Puerta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: size.width * 0.037,
                      ),
                    ),
                  )),
              SizedBox(
                height: size.height * 0.06,
              ),
              InkWell(
                child: Text(
                  'Ingresar como invitado',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: size.width * 0.04),
                ),
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const GuestMainwrapper())),
              )
            ],
          ),
        )),
      ),
    );
  }
}
