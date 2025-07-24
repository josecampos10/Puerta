import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';

class DetailsWishlistView extends StatefulWidget {
  const DetailsWishlistView({super.key});

  @override
  State<DetailsWishlistView> createState() => _DetailsWishlistViewState();
}

class _DetailsWishlistViewState extends State<DetailsWishlistView> {
  Uint8List? pickedImage;

  late Stream<DocumentSnapshot<Map<String, dynamic>>> stream;

  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final GlobalKey scrollKey = GlobalKey();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> reauthenticateUser(String currentPassword) async {
    final user = FirebaseAuth.instance.currentUser!;
    final cred = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(cred);
  }

  Future<void> signOut() async {
    try {
      // Eliminar token de Firestore si el usuario está logueado
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .update({'token': FieldValue.delete()});

        // También borra el token local
        await FirebaseMessaging.instance.deleteToken();
      }

      // Finalmente, cerrar sesión
      await _firebaseAuth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );

    getProfilePicture();
    stream = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.email) // 👈 Your document id change accordingly
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        iconTheme: CupertinoIconThemeData(
          color: Colors.white,
          size: size.height * 0.035,
        ),
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.13,
        //leading:
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.0),
            child: Text(
              'Editar perfil'.tr(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * 0.024,
                  color: Colors.white,
                  fontFamily: ''),
            )),
        centerTitle: false,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/puntos.png'),
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
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'perfil',
                child: Container(
                  height: size.height * 0.065,
                  width: size.height * 0.065,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      border: Border.all(
                        color: Color.fromRGBO(255, 255, 255, 0.174),
                        width: size.height * 0.003,
                      ),
                      shape: BoxShape.circle,
                      image: pickedImage != null
                          ? DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.memory(
                                pickedImage!,
                                key: UniqueKey(),
                              ).image)
                          : null),
                ),
              ),
              SizedBox(
                width: size.width * 0.03,
              )
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        //color: Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: stream,
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(children: [
                SpinKitFadingCircle(
                  color: Color.fromRGBO(4, 99, 128, 1),
                  size: size.width * 0.1,
                ),
              ]);
            }
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String name = data['name'];
            String email = data['email'];
            String phone = data['phone'];

            return Column(
              children: [
                Container(
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      key: scrollKey,
                      reverse: true,
                      primary: true,
                      child: Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.03,
                          ),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: Text(
                                      'Seleccione',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text(
                                          'Cámara',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                        onPressed: () {
                                          onProfileTappedCamera();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text(
                                          'Galería',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        ),
                                        onPressed: () {
                                          onProfileTappedGallery();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                    actionsAlignment: MainAxisAlignment.center,
                                  );
                                },
                              );
                            },
                            child: Container(
                              height: size.height * 0.2,
                              width: size.height * 0.2,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  border: Border.all(
                                    color: Color.fromRGBO(255, 255, 255, 0.307),
                                    width: size.height * 0.01,
                                  ),
                                  shape: BoxShape.circle,
                                  image: pickedImage != null
                                      ? DecorationImage(
                                          fit: BoxFit.cover,
                                          image: Image.memory(
                                            pickedImage!,
                                          ).image)
                                      : null),
                              child: Align(
                                alignment: Alignment.bottomRight * .99,
                                child: CircleAvatar(
                                  backgroundColor:
                                      Color.fromRGBO(255, 255, 255, 0.555),
                                  minRadius: size.height * 0.024,
                                  maxRadius: size.height * 0.024,
                                  child: Icon(
                                    CupertinoIcons.camera_fill,
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    size: size.height * 0.025,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Text(
                            data['name'],
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: size.height * 0.022,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['email'],
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: size.height * 0.015,
                                fontWeight: FontWeight.normal),
                          ),
                          SizedBox(
                            height: size.height*0.04,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: size.width * 0.9,
                                child: Row(
                                  children: [
                                    Text(
                                      'Nombre'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Arial',
                                          fontSize: size.height * 0.018),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Center(
                                child: Container(
                                  width: size.width * 0.9,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: Offset(-1, 1),
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    width: size.height * 0.01,
                                    child: TextField(
                                      cursorColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onTapOutside: (event) {
                                        print('onTapOutside');
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontFamily: 'Arial',
                                          fontSize: size.height * 0.02,
                                          fontWeight: FontWeight.normal),
                                      controller: _controllerName,
                                      onChanged: (value) => setState(() {}),
                                      decoration: InputDecoration(
                                          hintText: name,
                                          hintStyle: TextStyle(
                                              color: const Color.fromARGB(
                                                  193, 167, 167, 167),
                                              fontFamily: 'Arial'),
                                          contentPadding:
                                              EdgeInsets.only(left: 20),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                              
                             
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              SizedBox(
                                width: size.width * 0.9,
                                child: Row(
                                  children: [
                                    Text(
                                      'Número de teléfono'.tr(),
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontFamily: 'Arial',
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.height * 0.018),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                  icon:
                                                      Icon(Icons.check_circle),
                                                  iconColor: Colors.green,
                                                  content: Text(
                                                    'Asegúrese de utilizar un número de teléfono al que tenga acceso'.tr(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(
                                          Icons.info,
                                          size: size.height * 0.022,
                                        ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Center(
                                child: Container(
                                  width: size.width * 0.9,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(20.0),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: Offset(-1, 1),
                                      ),
                                    ],
                                  ),
                                  child: SizedBox(
                                    width: size.height * 0.01,
                                    child: TextField(
                                      cursorColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      onTapOutside: (event) {
                                        print('onTapOutside');
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontFamily: 'Arial',
                                          fontSize: size.height * 0.02,
                                          fontWeight: FontWeight.w500),
                                      keyboardType: TextInputType.phone,
                                      autocorrect: false,
                                      controller: _controllerPhone,
                                      onChanged: (value) => setState(() {}),
                                      decoration: InputDecoration(
                                          hintText: phone,
                                          hintStyle: TextStyle(
                                            color: const Color.fromARGB(
                                                193, 167, 167, 167),
                                          ),
                                          contentPadding:
                                              EdgeInsets.only(left: 20),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          SizedBox(
                            width: size.width * 0.9,
                            height: size.height * 0.06,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_controllerName.text == '') {
                                  _controllerName.text = data['name'];
                                }
                                if (_controllerEmail.text == '') {
                                  _controllerEmail.text = data['email'];
                                }
                                if (_controllerPhone.text == '') {
                                  _controllerPhone.text = data['phone'];
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            'Editar su perfil',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                          ),
                                          content: Text(
                                            '¿Está seguro que desea hacer estos cambios?',
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                          ),
                                          actions: [
                                            TextButton(
                                                onPressed: () async {
                                                  final newName =
                                                      _controllerName
                                                              .text.isEmpty
                                                          ? data['name']
                                                          : _controllerName
                                                              .text;
                                                  final newEmail =
                                                      _controllerEmail
                                                              .text.isEmpty
                                                          ? data['email']
                                                          : _controllerEmail
                                                              .text;
                                                  final newPhone =
                                                      _controllerPhone
                                                              .text.isEmpty
                                                          ? data['phone']
                                                          : _controllerPhone
                                                              .text;
                                                  final currentUser =
                                                      FirebaseAuth.instance
                                                          .currentUser!;

                                                  if (newEmail !=
                                                      currentUser.email) {
                                                    // Pide contraseña para reautenticación
                                                    String password = '';
                                                    await showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        final controller =
                                                            TextEditingController();
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Confirma tu contraseña'.tr()),
                                                          content: TextField(
                                                            cursorColor:
                                                                Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary,
                                                            controller:
                                                                controller,
                                                            obscureText: true,
                                                            decoration:
                                                                InputDecoration(
                                                                    labelText:
                                                                        'Contraseña'.tr()),
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: () {
                                                                password =
                                                                    controller
                                                                        .text;
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                'Confirmar',
                                                                style: TextStyle(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .secondary),
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      },
                                                    );

                                                    try {
                                                      // Reautenticación
                                                      final cred =
                                                          EmailAuthProvider
                                                              .credential(
                                                        email:
                                                            currentUser.email!,
                                                        password: password,
                                                      );
                                                      await currentUser
                                                          .reauthenticateWithCredential(
                                                              cred);

                                                      // Envía verificación y actualiza email en Auth
                                                      await currentUser
                                                          .verifyBeforeUpdateEmail(
                                                              newEmail);

                                                      // Guarda datos en Firestore temporalmente
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                              'pendingEmailChanges')
                                                          .doc(currentUser.uid)
                                                          .set({
                                                        'newEmail': newEmail,
                                                        'name': newName,
                                                        'phone': newPhone,
                                                      });

                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            'Revisa tu nuevo correo y haz clic en el enlace para completar el cambio.',
                                                          ),
                                                        ),
                                                      );

                                                      // Cierra sesión
                                                      await FirebaseAuth
                                                          .instance
                                                          .signOut();
                                                      Navigator.of(context)
                                                          .pushNamedAndRemoveUntil(
                                                              '/',
                                                              (route) =>
                                                                  false); // O usa WidgetTree()
                                                    } on FirebaseAuthException catch (e) {
                                                      print(
                                                          '❌ Error al actualizar email: $e');
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                'No se pudo actualizar el correo: ${e.message}')),
                                                      );
                                                    }
                                                  } else {
                                                    // Solo actualiza nombre y teléfono
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(currentUser.email)
                                                        .update({
                                                      'name': newName,
                                                      'phone': newPhone,
                                                    });

                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                          content: Text(
                                                              'Perfil actualizado')),
                                                    );
                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                child: Text('Aceptar'.tr(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary))),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Cancelar'.tr(),
                                                    style: TextStyle(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary)))
                                          ],
                                        );
                                      });
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 10)),
                              child: Text(
                                'Guardar cambios'.tr(),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Arial',
                                    color: Colors.white,
                                    fontSize: size.height * 0.02),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ],
            );
          },
        )),
      ),
    );
  }

  Future<void> onProfileTappedGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUser.email.toString());
    final imageBytes = await image.readAsBytes();
    await imageRef.putData(imageBytes);

    setState(() => pickedImage = imageBytes);
  }

  Future<void> onProfileTappedCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
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
