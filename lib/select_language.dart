import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lapuerta2/guest/guest_mainwrapper.dart';
import 'package:lapuerta2/onboarding.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguage();
}

class _SelectLanguage extends State<SelectLanguage> {




  @override
  void initState() {
    super.initState();
  
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(4, 99, 128, 1),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          image: DecorationImage(
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
              Animate(
                effects: [FadeEffect(duration: 600.ms, curve: Curves.easeIn)],
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
                      scale: size.height * 0.0044,
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
              
              SizedBox(
                height: size.height * 0.05,
              ),
              Text(
                'Seleccionar Idioma',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.06,
                  fontFamily: "compact",
                  fontWeight: FontWeight.w600,
                ),
              ),
              
              SizedBox(
                height: size.height * 0.05,
              ),
              SizedBox(
                width: size.height * 0.35,
                height: size.height * 0.06,
                child: ElevatedButton(
                  onPressed: () =>
                      //CHANGE THIS FOR ADMIN AND USER
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OnboardingPage())),
                  style: ElevatedButton.styleFrom(
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
                ).animate().fade(
                    delay: 1800.ms, duration: 1400.ms, curve: Curves.easeIn),
              ),
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
              ).animate().fade(
                  delay: 1800.ms, duration: 1400.ms, curve: Curves.easeIn),
            ],
          ),
        )),
      ),
    );
  }
}
