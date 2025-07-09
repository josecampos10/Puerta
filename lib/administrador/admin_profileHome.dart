import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapuerta2/administrador/admin_widget_tree.dart';
import 'package:lapuerta2/firebase_api.dart';
import 'package:lapuerta2/notification_services.dart';
import 'package:lapuerta2/onboarding.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminProfilehome extends StatefulWidget {
  const AdminProfilehome({Key? key}) : super(key: key);

  @override
  State<AdminProfilehome> createState() => _AdminProfileHomeState();
}

class _AdminProfileHomeState extends State<AdminProfilehome> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final GlobalKey scrollKey = GlobalKey();
  bool isSwitched = false;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> base;
  final currentUsera = FirebaseAuth.instance.currentUser!;

  void requestNotificationPermissiones() async {
    await FirebaseApi().initNotifications();
  }

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

  signOut() async {
    await auth.signOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => AdminWidgetTree()));
  }

  String push = '';

  Uint8List? pickedImage;

  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    getProfilePicture();
    base = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUsera.email) // 👈 Your document id change accordingly
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        toolbarHeight: size.width * 0.17,
        leadingWidth: size.width * 0.17,
        leading: Container(
          padding: EdgeInsets.all(6),
          width: size.width * 0.2,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(0, 240, 195, 195),
            child: Image.asset(
              'assets/img/logo.png',
              fit: BoxFit.scaleDown,
              scale: size.height * 0.008,
              color: Colors.white,
            ),
          ),
        ),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.03),
            child: Text(
              'Perfil',
            )),
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
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
              Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start, 
                  children: [
                  SizedBox(
                    width: size.width * 0.64,
                    child: Column(
                      children: [

                        Row(
                          children: [
                            SizedBox(
                              width: size.height * 0.02,
                            ),

                            StreamBuilder<
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
                                Map<String, dynamic> data = snapshot.data!
                                    .data() as Map<String, dynamic>;
                                return (data['name']) != null
                                    ? Text(
                                        data['name'],
                                        style: TextStyle(
                                            fontSize: size.height * 0.027,
                                            fontFamily: 'Coolvetica',
                                            //fontWeight: FontWeight.bold,
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
                          height: size.height * 0.0,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.035,
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
                                  Map<String, dynamic> data = snapshot.data!
                                      .data() as Map<String, dynamic>;
                                  return (data['rol']) != null
                                      ? Text(
                                          data['rol'],
                                          style: TextStyle(
                                              fontSize: size.height * 0.018,
                                              fontFamily: 'Coolvetica',
                                              fontWeight: FontWeight.w500,
                                              color: const Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        )
                                      : Text(''); // 👈 your valid data here
                                },
                              ),
                            ),
                          ],
                        ),
                        
                        Row(
                          children: [
                            SizedBox(
                              width: size.width * 0.035,
                            ),
                            (currentUser.email) != null
                                ? Text(currentUser.email.toString(),
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        fontFamily: 'Coolvetica',
                                        fontWeight: FontWeight.w500,
                                        color: const Color.fromARGB(
                                            140, 255, 255, 255)))
                                : Text('')
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Cuenta',
                    style: TextStyle(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        fontSize: size.height * 0.025,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Coolvetica'),
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
                            '    Editar Perfil',
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Coolvetica'),
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
                      onPressed: () =>
                          Navigator.pushNamed(context, '/changePassword'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '    Cambiar contraseña',
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Coolvetica'),
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'Política de Privacidad',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'Última actualización: 6/2/2025',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'La presente Política de Privacidad describe cómo la aplicación móvil de La Puerta Waco recopila, utiliza y protege la información personal de sus usuarios. Al utilizar esta aplicación, usted acepta los términos aquí establecidos.',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '1. Uso de la Aplicación',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'La aplicación de La Puerta Waco ha sido desarrollada exclusivamente con fines educativos e informativos. Su propósito es servir como un canal de comunicación y formación interna para los miembros de nuestra comunidad.',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '1. Información Recopilada',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'Durante el proceso de registro, solicitamos a los usuarios los siguientes datos: Nombre completo, Correo electrónico, Contraseña. El número de teléfono es un dato que puede ser proporcionado por el usuario dentro de la aplicación (elegida por el usuario). Esta información es almacenada de forma segura en la plataforma Firebase de Google, la cual cuenta con estándares de seguridad reconocidos a nivel mundial.',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '3. Acceso a la Información',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'El acceso a los datos personales está restringido exclusivamente a los administradores del sistema, quienes los utilizarán únicamente para fines internos de la organización y para el correcto funcionamiento de la app.',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '4. Seguriad y Privacidad',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'Nos comprometemos a proteger la privacidad de nuestros usuarios. La información almacenada se encuentra resguardada mediante los protocolos de seguridad proporcionados por Firebase, incluyendo cifrado y control de acceso.',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '5. Consentimiento del Usuario',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  'Al registrarse en la aplicación, usted acepta los términos y condiciones de uso, incluyendo:',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '•	El almacenamiento de su nombre, correo y contraseña en nuestra base de datos.',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '•	El uso exclusivo de esta información para el funcionamiento de la app y los fines internos de La Puerta Waco.',
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
                                              Container(
                                                width: size.width * 0.6,
                                                child: Text(
                                                  '6. Cambios a esta Politica',
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
                                              Container(
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
                                                        'Nos reservamos el derecho de actualizar esta Política de Privacidad en cualquier momento. Le notificaremos sobre cualquier cambio importante a través de la aplicación o de nuestro sitio web oficial: www.lapuertawaco.com',
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
                            '    Seguridad y Privacidad',
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Coolvetica'),
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
                            '    Hacer un pago',
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Coolvetica'),
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
                    'Notificaciones',
                    style: TextStyle(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        fontSize: size.height * 0.025,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Coolvetica'),
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
                                title: Text('Notificaciones'),
                                content: Text(
                                    'Para cambiar los ajustes de Notificaciones vaya a los ajustes de su teléfono'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        //AppSettings.openAppSettings(type: AppSettingsType.notification);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancelar',
                                        style: TextStyle(
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
                                        'Ir a Ajustes',
                                        style: TextStyle(
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
                            '    Ajustes',
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Coolvetica'),
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
                    'Cerrar sesión',
                    style: TextStyle(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        fontSize: size.height * 0.025,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Coolvetica'),
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
                                title: Text('Salir'),
                                content: Text(
                                    'Estás seguro que deseas cerrar sesión?',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'Cancelar',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                      )),
                                  TextButton(
                                      onPressed: () {
                                        signOut();
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Aceptar',
                                          style: TextStyle(
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
                            '    Salir',
                            style: TextStyle(
                                fontSize: size.height * 0.025,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Coolvetica'),
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
                height: size.height * 0.035,
              ),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  
                  Text(
                    'Borrar datos',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 0, 0, 0)
                            .withOpacity(0.5),
                        fontSize: size.height * 0.02,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Coolvetica'),
                  )
                ],
              ),*/
              SizedBox(
                height: size.height * 0.02,
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
                                title: Text('Eliminar cuenta'),
                                content: Text(
                                    'Estás seguro que deseas eliminar tu cuenta? Todos tus datos serán borrados'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cancelar')),
                                  TextButton(
                                      onPressed: () async {
                                        //delete user info in the database
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(currentUser.email)
                                            .delete();

                                        //delete user
                                        currentUser.delete();
                                        FirebaseAuth.instance.signOut();
                                        //(FirebaseStorage.instance.ref().child(currentUser.email.toString()).g)
                                        FirebaseStorage.instance
                                            .ref()
                                            .child(currentUser.email.toString())
                                            .delete();

                                        //go to sign up log in page
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OnboardingPage()));
                                      },
                                      child: Text('Aceptar')),
                                ],
                              );
                            });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '    Eliminar cuenta',
                            style: TextStyle(
                                fontSize: size.height * 0.015,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Coolvetica'),
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
  const editProfile({Key? key}) : super(key: key);
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
