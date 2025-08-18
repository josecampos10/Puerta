import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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
  const AdminProfilehome({super.key});

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

  Future<void> resendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    await user.reload(); // 🔄 Recarga datos del usuario desde Firebase
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser!.emailVerified) {
      setState(() {}); // 🔁 Actualiza la UI si es necesario
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Tu correo ya está verificado'),
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

  Widget emailVerificationBadge() {
    Size size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;
    final isVerified = user?.emailVerified ?? false;

    return Container(
      width: size.height*0.02,
      height: size.height*0.02,
      decoration: BoxDecoration(
        color: isVerified ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.check,
        size: size.height*0.016,
        color: Colors.white,
      ),
    );
  }

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
                                    data['rol'],
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
            ),
        height: size.height * 0.9,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.04,
              ),
              
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
                        fontSize: size.height * 0.02,
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
                    width: size.width*0.85,
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
                    width: size.width*0.85,
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
                    width: size.width*0.85,
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                                              SizedBox(
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
                    width: size.width*0.85,
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
                    'Notificaciones',
                    style: TextStyle(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        fontSize: size.height * 0.02,
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
                    width: size.width*0.85,
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
                    'Cerrar sesión',
                    style: TextStyle(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        fontSize: size.height * 0.02,
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
                    width: size.width*0.85,
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
  onPressed: () async {
    await FirebaseAuth.instance.signOut();
    if (context.mounted) Navigator.of(context).pop();
  },
  child: Text('Aceptar',
      style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
),
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
