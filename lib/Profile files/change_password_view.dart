import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class changePasswordView extends StatefulWidget {
  const changePasswordView({super.key});

  @override
  State<changePasswordView> createState() => _changePasswordViewState();
}

class _changePasswordViewState extends State<changePasswordView> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser!;
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerNameConfirm = TextEditingController();
  final TextEditingController _controllerCurrent = TextEditingController();
  final GlobalKey scrollKey = GlobalKey();
  Uint8List? pickedImage;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> stream;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
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
              'Cambiar contraseña',
              style: TextStyle(
                  //fontWeight: FontWeight.w500,
                  fontSize: size.width * 0.055,
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
              Container(
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
                          ).image)
                      : null),
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
          child: Column(
            children: [
              SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  key: scrollKey,
                  reverse: false,
                  primary: true,
                  child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: stream,
                    builder: (BuildContext context,
                        AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Column(children: [
                          SpinKitFadingCircle(
                            color: Theme.of(context).colorScheme.tertiary,
                            size: size.width * 0.1,
                          ),
                        ]);
                      }

                      Map<String, dynamic> data =
                          snapshot.data!.data() as Map<String, dynamic>;
                      String current = _controllerCurrent.text;
                      _controllerCurrent.text = data['password'];
                      String newpassword = data['email'];
                      String confirmpassword = data['phone'];

                      return Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Container(
                            height: size.height * 0.2,
                            width: size.height * 0.2,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 5.0,
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 60,
                              backgroundColor: Color.fromRGBO(255, 255, 255, 0.404),
                              backgroundImage:
                                  ExactAssetImage('assets/img/lock.png'),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.05,
                          ),
                          Column(
                            children: [
                              SizedBox(
                                width: size.width * 0.9,
                                child: Row(
                                  children: [
                                    Text(
                                      'Contraseña actual',
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontFamily: 'Arial',
                                          fontSize: size.height * 0.02),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Center(
                                child: Container(
                                  width: size.width - 40,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
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
                                      onTapOutside: (event) {
                                    print('onTapOutside');
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                      readOnly: true,
                                      obscureText: _isObscure,
                                      controller: _controllerCurrent,
                                      onChanged: (value) => setState(() {
                                        _controllerCurrent.text =
                                            value.toString();
                                      }),
                                      decoration: InputDecoration(
                                          suffix: IconButton(
                                            padding: const EdgeInsets.all(0),
                                            iconSize: 20.0,
                                            icon: _isObscure
                                                ? const Icon(
                                                    Icons.visibility_off,
                                                    color: Colors.grey,
                                                  )
                                                : const Icon(
                                                    Icons.visibility,
                                                    color: Colors.black,
                                                  ),
                                            onPressed: () {
                                              setState(() {
                                                _isObscure = !_isObscure;
                                              });
                                            },
                                          ),
                                          hintText: _controllerCurrent.text,
                                          hintStyle:
                                              TextStyle(color: Colors.black45),
                                          contentPadding:
                                              EdgeInsets.only(left: 20),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.017,
                              ),
                              SizedBox(
                                width: size.width * 0.9,
                                child: Row(
                                  children: [
                                    Text(
                                      'Contraseña nueva',
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontFamily: 'Arial',
                                          fontSize: size.height * 0.02),
                                    ),
                                    IconButton(
                                      onPressed: (){
                                        showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor: Theme.of(context).colorScheme.primary,
                                                  icon:
                                                      Icon(Icons.info_rounded),
                                                  iconColor: const Color.fromARGB(255, 255, 131, 59),
                                                  content: Text(
                                                      'Asegúrese de utilizar una contraseña con un mínimo de 8 caracteres'),
                                                );
                                              });
                                      }, 
                                      icon: Icon(Icons.info_rounded))
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.0,
                              ),
                              Center(
                                child: Container(
                                  width: size.width - 40,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
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
                                    child: TextFormField(
                                      onTapOutside: (event) {
                                    print('onTapOutside');
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                      validator: (value) {
                                        return value!.length < 8 ? 'Minimo de caracteres 8' : null;
                                      },
                                      controller: _controllerName,
                                      onChanged: (value) => setState(() {
                                        _controllerName.text = value.toString();
                                      }),
                                      decoration: InputDecoration(
                                          hintText: 'Contraseña nueva',
                                          hintStyle:
                                              TextStyle(color: const Color.fromARGB(255, 153, 153, 153)),
                                          contentPadding:
                                              EdgeInsets.only(left: 20,right: 10),
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              SizedBox(
                                width: size.width * 0.9,
                               // height: size.height*0.02,
                                child: Row(
                                  children: [
                                    Text(
                                      'Confirmar contraseña',
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontFamily: 'Arial',
                                          fontSize: size.height * 0.02),
                                    ),
                                    SizedBox(width: size.width*0.05,),
                                    
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Center(
                                child: Container(
                                  width: size.width - 40,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary,
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
                                      onTapOutside: (event) {
                                    print('onTapOutside');
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                      controller: _controllerNameConfirm,
                                      onChanged: (value) => setState(() {
                                        _controllerNameConfirm.text =
                                            value.toString();
                                      }),
                                      decoration: InputDecoration(
                                        suffix: (_controllerName.text == _controllerNameConfirm.text) ?
                                        Icon(Icons.check_circle, color: Colors.green,): 
                                        Icon(CupertinoIcons.xmark_circle_fill, color: Colors.red,),
                                        
                                          hintText: 'Confirmar contraseña',
                                          hintStyle:
                                              TextStyle(color: const Color.fromARGB(255, 153, 153, 153)),
                                          contentPadding:
                                              EdgeInsets.only(left: 20, right: 10),
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
                            width: size.width * 0.9,
                            height: size.height * 0.06,
                            child: ElevatedButton(
                              onPressed: () {
                                //String comparador = ;
                                (_controllerName.text == null) ?
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Cambiar Contraseña'),
                                        content: Text(
                                            'Está seguro que desea cambiar su contraseña?'),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                if (_controllerName.text ==
                                                    _controllerNameConfirm
                                                        .text) {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(currentUser.email)
                                                      .update({
                                                    'password':
                                                        _controllerNameConfirm
                                                            .text
                                                  });
                                                  Navigator.of(context).pop();
                                                  _controllerName.clear();
                                                  _controllerNameConfirm
                                                      .clear();
                                                } else {
                                                  Navigator.of(context).pop();
                                                  var snackBar = SnackBar(
                                                      content: Text(
                                                          'Las contraseñas no coinciden'));
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(snackBar);
                                                }
                                              },
                                              child: Text('Aceptar', style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.secondary),))
                                        ],
                                      );
                                    }): showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Icon(Icons.info, color: Colors.yellow,),
                                        content: Text('Porfavor ingrese una contraseña nueva', style: TextStyle(color: Theme.of(context).colorScheme.secondary),),
                                        actions: [
                                          TextButton(
                                            onPressed: (){
                                              Navigator.pop(context);
                                            }, 
                                            child: Text('Cerrar'))
                                        ],
                                      );
                                    });
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.tertiary,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 10)),
                              child: Text(
                                'Confirmar',
                                style: TextStyle(
                                    fontFamily: 'Arial',
                                    color: Colors.white,
                                    fontSize: size.height * 0.02),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  )),
            ],
          ),
        ),
      ),
    );
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
