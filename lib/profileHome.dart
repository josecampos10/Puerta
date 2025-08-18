import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapuerta2/firebase_api.dart';
import 'package:lapuerta2/main.dart';
import 'package:lapuerta2/notification_services.dart';
import 'package:lapuerta2/onboarding.dart';
import 'package:lapuerta2/widget_tree.dart';
import 'package:url_launcher/url_launcher.dart';

class Profilehome extends StatefulWidget {
  const Profilehome({
    super.key,
  });

  @override
  State<Profilehome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<Profilehome> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final GlobalKey scrollKey = GlobalKey();
  bool isSwitched = false;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> base;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  bool isEnglish = false;
  final callable = FirebaseFunctions.instance.httpsCallable('deleteUserData');

  void requestNotificationPermission() async {
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      if (kDebugMode) {
        print('user granted permission');
      }
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      if (kDebugMode) {
        print('user granted provisional permission');
      }
    } else {
      //appsetting.AppSettings.openNotificationSettings();
      if (kDebugMode) {
        print('user denied permission');
      }
    }
  }

  Future<void> signOut() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // 🧽 1. Eliminar token de Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .update({'token': FieldValue.delete()});

        // 🔁 2. Borrar el token FCM del dispositivo
        await FirebaseMessaging.instance.deleteToken();
      }

      // 🔐 3. Cerrar sesión de Firebase
      await FirebaseAuth.instance.signOut();

      // 🚪 4. Redirigir al login o WidgetTree
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WidgetTree()),
      );
    } catch (e) {
      print('Error during sign out: $e');
    }
  }

  Future<void> resendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await user.reload(); // 🔄 Recarga datos del usuario desde Firebase
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser!.emailVerified) {
      setState(() {}); // 🔁 Actualiza la UI si es necesario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Tu correo ya está verificado'.tr()),
          backgroundColor: Colors.blue,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    try {
      await refreshedUser.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '📨 Correo de verificación enviado a ${refreshedUser.email}'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      if (e.code == 'too-many-requests') {
        message =
            'Has solicitado verificación demasiadas veces. Intenta más tarde.';
      } else if (e.code == 'network-request-failed') {
        message =
            'No hay conexión a internet. Revisa tu red e intenta de nuevo.';
      } else {
        message = 'Ocurrió un error al enviar el correo. Intenta de nuevo.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ $message'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Error inesperado: ${e.toString()}'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Future<void> loadUserLanguagePreference() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email)
        .get();

    final data = doc.data();
    final isSpanish = data?['spanish'] == 'true'; // viene como string

    setState(() {
      isEnglish = !isSpanish; // true = inglés activo
    });

    context.setLocale(Locale(isEnglish ? 'en' : 'es'));
  }

  Widget emailVerificationBadge() {
    Size size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    final isVerified = user?.emailVerified ?? false;

    return Container(
      width: size.height * 0.02,
      height: size.height * 0.02,
      decoration: BoxDecoration(
        color: isVerified ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        size: size.height * 0.016,
        color: Colors.white,
      ),
    );
  }

  Future<void> _checkUserValidity() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      await user?.reload();
      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser == null) {
        // Usuario eliminado de Authentication
        await FirebaseAuth.instance.signOut();
        _navigateToLogin();
        return;
      }

      await Future.delayed(const Duration(milliseconds: 500));

      final firestore = FirebaseFirestore.instance;

      // 1️⃣ Verificar si existe el documento en la colección 'users'
      final userDoc =
          await firestore.collection('users').doc(refreshedUser.email).get();

      if (!userDoc.exists) {
        await FirebaseAuth.instance.signOut();
        _navigateToLogin();
        return;
      }
    } catch (e) {
      print('❌ Error validando usuario o posts: $e');
      await FirebaseAuth.instance.signOut();
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
        (route) => false,
      );
    }
  }

  String push = '';
  Uint8List? pickedImage;
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    _checkUserValidity();
    getProfilePicture();
    base = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUsera.email) // 👈 Your document id change accordingly
        .snapshots();
    loadUserLanguagePreference();
  }

  @override
  Widget build(BuildContext context) {
    var isEnglish = context.locale.languageCode == 'en';
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.19,
        leadingWidth: size.width * 0.17,
        //leading:
        title: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            SizedBox(
              width: size.width * 0.64,
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: size.height * 0.0,
                      ),

                      StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: base,
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(children: [
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              SpinKitFadingCircle(
                                color: Color.fromRGBO(255, 255, 255, 1),
                                size: size.width * 0.03,
                              ),
                            ]);
                          }
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return (data['name']) != null
                              ? Text(
                                  data['name'],
                                  style: TextStyle(
                                      fontSize: size.height * 0.027,
                                      fontFamily: 'Arial',
                                      fontWeight: FontWeight.bold,
                                      color: const Color.fromARGB(
                                          255, 255, 255, 255)),
                                )
                              : Text(''); // 👈 your valid data here
                        },
                      ),

                      //SizedBox(
                      //    height: 24,
                      //    child: Image.asset("assets/images/verified.png")),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: size.width * 0.0,
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: base,
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(children: [
                                SizedBox(
                                  height: size.height * 0.01,
                                ),
                                SpinKitFadingCircle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  size: size.width * 0.03,
                                ),
                              ]);
                            }
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return (data['rol']) != null
                                ? Text(
                                    data['rol'].toString().tr(),
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        fontFamily: 'Arial',
                                        fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                  )
                                : Text(''); // 👈 your valid data here
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.005,
                  ),
                  Row(
                    children: [
                      (currentUser.email) != null
                          ? Text(currentUser.email.toString(),
                              style: TextStyle(
                                  fontSize: size.height * 0.018,
                                  fontFamily: 'Arial',
                                  fontWeight: FontWeight.bold,
                                  color:
                                      const Color.fromARGB(140, 255, 255, 255)))
                          : Text(''),
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      emailVerificationBadge(),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  if (!(FirebaseAuth.instance.currentUser?.emailVerified ??
                      false))
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.03,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: resendEmailVerification,
                              borderRadius: BorderRadius.circular(4),
                              splashColor:
                                  const Color.fromARGB(36, 255, 255, 255),
                              highlightColor: Colors.transparent,
                              child: Text(
                                'Verificar correo'.tr(),
                                style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 49, 183, 255),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                ],
              ),
            ),
            Hero(
              tag: 'perfil',
              child: Container(
                height: size.height * 0.12,
                width: size.height * 0.12,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    border: Border.all(
                      color: Color.fromRGBO(255, 255, 255, 0.295),
                      width: size.height * 0.005,
                    ),
                    shape: BoxShape.circle,
                    image: pickedImage != null
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.memory(
                              pickedImage!,
                            ).image)
                        : null),
              ),
            ),
          ]),
        ]),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/puntos2.png'),
              fit: BoxFit.fill,
              colorFilter: (Theme.of(context).colorScheme.tertiary !=
                      Color.fromRGBO(4, 99, 128, 1))
                  ? ColorFilter.mode(
                      const Color.fromARGB(255, 68, 68, 68), BlendMode.color)
                  : ColorFilter.mode(
                      const Color.fromARGB(0, 255, 29, 29), BlendMode.color),
            ),
          ),
        ),
        actions: [],
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height * 0.9,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Cuenta'.tr(),
                    style: TextStyle(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        fontSize: size.height * 0.022,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial'),
                  ),
                  Expanded(child: SizedBox()),
                  Container(
                    width: size.width * 0.27,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Theme.of(context).colorScheme.tertiary),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ES',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.015,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: size.width * 0.00,
                        ),
                        SizedBox(
                          height: size.height * 0.045,
                          child: Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              trackOutlineColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                      (Set<WidgetState> states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.transparent;
                                }
                                return Colors
                                    .transparent; // Use the default color.
                              }),
                              thumbColor:
                                  WidgetStateProperty.resolveWith<Color>(
                                      (Set<WidgetState> states) {
                                if (states.contains(WidgetState.disabled)) {
                                  return Colors.orange.withOpacity(.48);
                                }
                                return Theme.of(context).colorScheme.tertiary;
                              }),
                              inactiveThumbColor: Colors.white,
                              activeTrackColor: Colors.white,
                              //activeTrackColor: const Color.fromARGB(0, 255, 255, 255),
                              activeColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              inactiveTrackColor:
                                  Color.fromRGBO(255, 255, 255, 1),
                              value: isEnglish,
                              onChanged: (value) async {
                                bool activo = value;
                                if (activo == true) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.email)
                                      .update({'spanish': 'false'});
                                } else {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(currentUser.email)
                                      .update({'spanish': 'true'});
                                }
                                setState(() {
                                  isEnglish = value;
                                });

                                context.setLocale(Locale(value ? 'en' : 'es'));
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.0,
                        ),
                        Text(
                          'EN',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.015,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: size.width * 0.03,
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.height * 0.01,
                  ),
                  Container(
                    width: size.width - 20,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/detailsWishlist'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Editar perfil'.tr(),
                            style: TextStyle(
                                fontSize: size.height * 0.024,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial'),
                          ),
                          Icon(
                            color: Color.fromRGBO(255, 255, 255, 1),
                            Icons.arrow_forward_ios_outlined,
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.height * 0.01,
                  ),
                  Container(
                    width: size.width - 20,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/changePassword'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cambiar contraseña'.tr(),
                            style: TextStyle(
                                fontSize: size.height * 0.024,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial'),
                          ),
                          Icon(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.height * 0.01,
                  ),
                  Container(
                    width: size.width - 20,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                content: Container(
                                  color: Theme.of(context).colorScheme.primary,
                                  height: size.height * 0.6,
                                  width: size.width,
                                  child: SingleChildScrollView(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'Política de Privacidad'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.014,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'Última actualización: 6/2/2025'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.012,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'La presente Política de Privacidad describe cómo la aplicación móvil de La Puerta Waco recopila, utiliza y protege la información personal de sus usuarios. Al utilizar esta aplicación, usted acepta los términos aquí establecidos.'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.013,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '1. Uso de la Aplicación'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.014,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'La aplicación de La Puerta Waco ha sido desarrollada exclusivamente con fines educativos e informativos. Su propósito es servir como un canal de comunicación y formación interna para los miembros de nuestra comunidad.'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.013,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '2. Información Recopilada'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.014,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'Durante el proceso de registro, solicitamos a los usuarios los siguientes datos: Nombre completo, Correo electrónico, Contraseña. El número de teléfono es un dato que puede ser proporcionado por el usuario dentro de la aplicación (elegida por el usuario). Esta información es almacenada de forma segura en la plataforma Firebase de Google, la cual cuenta con estándares de seguridad reconocidos a nivel mundial.'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.013,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '3. Acceso a la Información'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.014,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'El acceso a los datos personales está restringido exclusivamente a los administradores del sistema, quienes los utilizarán únicamente para fines internos de la organización y para el correcto funcionamiento de la app.'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.013,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '4. Seguriad y Privacidad'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.014,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'Nos comprometemos a proteger la privacidad de nuestros usuarios. La información almacenada se encuentra resguardada mediante los protocolos de seguridad proporcionados por Firebase, incluyendo cifrado y control de acceso.'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.013,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '5. Consentimiento del Usuario'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.014,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'Al registrarse en la aplicación, usted acepta los términos y condiciones de uso, incluyendo:'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.013,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '•	El almacenamiento de su nombre, correo y contraseña en nuestra base de datos.'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.013,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '•	El uso exclusivo de esta información para el funcionamiento de la app y los fines internos de La Puerta Waco.'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.013,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '6. Cambios a esta Politica'.tr(),
                                                  style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.014,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                  width: size.width * 0.6,
                                                  child: Linkify(
                                                    linkStyle: TextStyle(
                                                        decoration:
                                                            TextDecoration.none,
                                                        fontSize:
                                                            size.height * 0.013,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    text:
                                                        'Nos reservamos el derecho de actualizar esta Política de Privacidad en cualquier momento. Le notificaremos sobre cualquier cambio importante a través de la aplicación o de nuestro sitio web oficial: www.lapuertawaco.com'.tr(),
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.013,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    onOpen: (link) async {
                                                      if (!await launchUrl(
                                                          Uri.parse(
                                                              link.url))) {
                                                        throw Exception(
                                                            'Could not launch ${link.url}');
                                                      }
                                                    },
                                                  )),
                                            ],
                                          ),
                                        ],
                                      )),
                                ),
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Seguridad y privacidad'.tr(),
                            style: TextStyle(
                                fontSize: size.height * 0.024,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial'),
                          ),
                          Icon(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.height * 0.01,
                  ),
                  Container(
                    width: size.width - 20,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/payment'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Hacer un pago'.tr(),
                            style: TextStyle(
                                fontSize: size.height * 0.024,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial'),
                          ),
                          Icon(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Notificaciones'.tr(),
                    style: TextStyle(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        fontSize: size.height * 0.022,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial'),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.height * 0.01,
                  ),
                  Container(
                    width: size.width - 20,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Notificaciones'.tr(),
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                content: Text(
                                  'Para cambiar los ajustes de Notificaciones vaya a los ajustes de su teléfono'
                                      .tr(),
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        //AppSettings.openAppSettings(type: AppSettingsType.notification);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancelar'.tr(),
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      )),
                                  TextButton(
                                      onPressed: () =>
                                          AppSettings.openAppSettings(
                                              type:
                                                  AppSettingsType.notification),
                                      //Navigator.of(context).pop();

                                      child: Text(
                                        'Ir a Ajustes'.tr(),
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      )),
                                ],
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Ajustes'.tr(),
                            style: TextStyle(
                                fontSize: size.height * 0.024,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial'),
                          ),
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(currentUser
                                    .email) // 👈 Your document id change accordingly
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return const Text('Something went wrong');
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Text("");
                              }
                              Map<String, dynamic> data =
                                  snapshot.data!.data() as Map<String, dynamic>;
                              if (data['Push Notifications'].toString() ==
                                  'enabled') {
                                return Text('');
                              } else {
                                return Text(''); // 👈 your valid data here
                              }
                            },
                          ),
                          Icon(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              Icons.arrow_forward_ios_outlined)
                          /*Switch(
                                  value: _notificationEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      _notificationEnabled = value;
                                      //notificationServices.requestNotificationPermission();
                                      if (value) {
                                        _checkNotificationPermission();
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(currentUser.email)
                                            .update({
                                          'Push Notifications': 'enabled'
                                        });
                                      } else {
                                        _requestNotificationPermission();
                                        _checkNotificationPermission();
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(currentUser.email)
                                            .update({
                                          'Push Notifications': 'disabled'
                                        });
                                      }
                                    });
                                  })*/
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.height * 0.02,
                  ),
                  Text(
                    'Cerrar sesión'.tr(),
                    style: TextStyle(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        fontSize: size.height * 0.022,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Arial'),
                  )
                ],
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: size.width - 20,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(-4, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Salir'.tr(),
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                content: Text(
                                    'Estás seguro que deseas cerrar sesión?'
                                        .tr(),
                                    style: TextStyle(
                                        fontFamily: 'Arial',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancelar'.tr(),
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        signOut();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Aceptar'.tr(),
                                          style: TextStyle(
                                              fontFamily: 'Arial',
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary))),
                                ],
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Salir'.tr(),
                            style: TextStyle(
                                fontSize: size.height * 0.024,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial'),
                          ),
                          Icon(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size.width - 230,
                    height: size.height * 0.04,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(131, 80, 71, 1),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: Offset(-4, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(
                                  'Eliminar cuenta'.tr(),
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                content: Text(
                                  'Estás seguro que deseas eliminar tu cuenta? Todos tus datos serán borrados'.tr(),
                                  style: TextStyle(
                                      fontFamily: 'Arial',
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancelar'.tr(),
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontFamily: 'Arial'),
                                      )),
                                  TextButton(
                                    onPressed: () async {
                                      final currentUser =
                                          FirebaseAuth.instance.currentUser;
                                      final userEmail = currentUser?.email;

                                      // 1. Cerrar sesión visualmente y navegar al onboarding
                                      await Future.delayed(
                                          const Duration(milliseconds: 300));

                                      if (navigatorKey.currentState?.mounted ??
                                          false) {
                                        navigatorKey.currentState
                                            ?.pushAndRemoveUntil(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const OnboardingPage()),
                                          (route) => false,
                                        );
                                      }

                                      // 2. Esperar navegación
                                      await Future.delayed(
                                          const Duration(milliseconds: 300));

                                      try {
                                        if (userEmail != null) {
                                          // 3. Eliminar posts del usuario
                                          final postsSnapshot =
                                              await FirebaseFirestore.instance
                                                  .collection('posts')
                                                  .where('UserEmail',
                                                      isEqualTo: userEmail)
                                                  .get();

                                          for (final doc
                                              in postsSnapshot.docs) {
                                            await doc.reference.delete();
                                          }

                                          // 4. Eliminar imagen de perfil
                                          try {
                                            await FirebaseStorage.instance
                                                .ref(userEmail)
                                                .delete();
                                          } catch (_) {
                                            print(
                                                '⚠️ No hay imagen de perfil para eliminar.');
                                          }

                                          // 5. Eliminar cuenta de Firebase Auth
                                          await currentUser?.delete();

                                          // 6. Esperar cierre de sesión
                                          await FirebaseAuth.instance.signOut();

                                          // 7. Eliminar documento del usuario
                                          final callable = FirebaseFunctions
                                              .instance
                                              .httpsCallable('deleteUserData');
                                          final result = await callable
                                              .call({'email': userEmail});
                                          print(
                                              '✅ Resultado función: ${result.data}');
                                        }
                                      } catch (e) {
                                        print(
                                            '❌ Error al eliminar cuenta o documento: $e');
                                      }
                                    },
                                    child: Text(
                                      'Aceptar'.tr(),
                                      style: TextStyle(
                                        fontFamily: 'Arial',
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Eliminar cuenta'.tr(),
                            style: TextStyle(
                                fontSize: size.height * 0.015,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Arial'),
                          ),
                          Icon(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              Icons.arrow_forward_ios_outlined)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onProfileTapped() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUser.email.toString());
    final imageBytes = await image.readAsBytes();
    await imageRef.putData(imageBytes);

    setState(() => pickedImage = imageBytes);
  }

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUser.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      print('Profile Picture could not be found');
    }
  }
}

class editProfile extends StatefulWidget {
  const editProfile({super.key});
  @override
  State<editProfile> createState() => _editProfile();
}

class _editProfile extends State<editProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('EDIT'),
      ),
    );
  }
}
