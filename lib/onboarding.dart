import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:easy_localization/easy_localization.dart' as ez;
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
  void initState() {
    super.initState();
    Future.delayed(
      Duration(),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
  }

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
                  width: size.width * 0.35,
                  height: size.height * 0.15,
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
                  width: size.width*0.8 ,
                  height: size.height * 0.06,
                  child: ElevatedButton(
                    
                    onPressed: () =>
                        //CHANGE THIS FOR ADMIN AND USER
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => WidgetTree())),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      ez.tr('Ingresar a La Puerta'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize: size.height * 0.02,
                      ),
                    ),
                  )),
              SizedBox(
                height: size.height * 0.06,
              ),
              InkWell(
                child: Text(
                  ez.tr('Ingresar como invitado'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.018),
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
