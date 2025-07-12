import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminDetailsWishlistView extends StatefulWidget {
  const AdminDetailsWishlistView({super.key});

  @override
  State<AdminDetailsWishlistView> createState() => _AdminDetailsWishlistViewState();
}

class _AdminDetailsWishlistViewState extends State<AdminDetailsWishlistView> {
  Uint8List? pickedImage;

  @override
  void initState() {
    super.initState();
    getProfilePicture();
  }



  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _controllerName = TextEditingController();
  final GlobalKey scrollKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 99, 128, 1),
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
          backgroundColor: Color.fromRGBO(4, 99, 128, 1),
          actions: [],
        ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        //color: Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
          child: Column(
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
                          height: size.height * 0.05,
                        ),
                        Text(
                          'Editar perfil',
                          style: TextStyle(
                              color: const Color.fromARGB(255, 0, 0, 0)
                                  .withOpacity(0.5),
                              fontSize: size.height * 0.03,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: size.height * 0.04,
                        ),
                        GestureDetector(
                          onTap: onProfileTapped,
                          child: Container(
                            height: size.height * 0.35,
                            width: size.height * 0.35,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              border: Border.all(
                                color: Color.fromRGBO(4, 99, 128, 1),
                                width: size.height * 0.01,
                              ),
                              shape: BoxShape.circle,
                              image: pickedImage != null
                                  ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.memory(
                                        pickedImage!,
                                      ).image)
                                  : null,
                            ),
                            child: Align(
                              alignment: Alignment.bottomRight * .89,
                              child: Icon(
                                CupertinoIcons.camera_fill,
                                color: Colors.black,
                                size: size.height * 0.06,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Column(
                          children: [
                            Center(
                              child: Container(
                                width: size.width - 40,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                                child: SizedBox(
                                  width: size.height * 0.01,
                                  child: TextField(
                                    controller: _controllerName,
                                    onChanged: (value) => setState(() {
                                      _controllerName.text = value.toString();
                                    }),
                                    decoration: InputDecoration(
                                        hintText: 'Editar nombre',
                                        hintStyle:
                                            TextStyle(color: Colors.black45),
                                        suffixIcon: Icon(Icons.edit),
                                        contentPadding:
                                            EdgeInsets.only(left: 20, top: 12),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        SizedBox(
                          width: size.height * 0.35,
                          height: size.height * 0.06,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_controllerName.text == '') {
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Editar tu perfil'),
                                        content: Text(
                                            'Estás seguro que desas cambiar tu perfil?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(currentUser.email)
                                                    .update({
                                                  'name': _controllerName.text
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Aceptar')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancelar'))
                                        ],
                                      );
                                    });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(4, 99, 128, 1),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 10)),
                            child: Text(
                              'Confirmar',
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                  fontSize: size.width * 0.037),
                            ),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Ir atrás',
                              style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize: size.width * 0.04),
                            ))
                      ],
                    )),
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
