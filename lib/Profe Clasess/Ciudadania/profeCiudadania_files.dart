import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';


class ProfeCiudadaniafiles extends StatefulWidget {
  const ProfeCiudadaniafiles({super.key});
  @override
  State<ProfeCiudadaniafiles> createState() => _ProfeCiudadaniafilesState();
}

class _ProfeCiudadaniafilesState extends State<ProfeCiudadaniafiles> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('postsCiudadania');
  late Future<ListResult> futureFiles;
    Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;

    PlatformFile? pickedFile;
      UploadTask? uploadTask;
  
  Future uploadFile() async {
    final path = 'Ciudadaniafiles/${pickedFile!.name}';
    final file = File(pickedFile!.path!);
    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('Download Link: $urlDownload');
    setState(() {
      uploadTask = null;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseStorage.instance.ref('/Ciudadaniafiles').listAll();
    getProfilePicture();
  }

  @override
  void dispose() {
    super.dispose();
    getProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          shape: CircleBorder(),
          backgroundColor: const Color.fromARGB(122, 4, 99, 128),
          child: Icon(
            Icons.add,
            color: const Color.fromARGB(155, 255, 255, 255),
          ),
          onPressed: () {
            selectFile();
          }),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
              'Mis clases',
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
        backgroundColor: const Color.fromRGBO(4, 99, 128, 1),
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
                  color: Color.fromRGBO(4, 99, 128, 1),
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
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: size.width,
                  height: size.height * 0.2,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          filterQuality: FilterQuality.low,
                          image: AssetImage('assets/img/Ciudadaniaback.png'),
                          fit: BoxFit.cover),
                      //color: Color.fromARGB(155, 255, 102, 0),
                      borderRadius: BorderRadius.all(Radius.circular(31))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                        'Ciudadanía',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.06,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Clase de Ciudadanía',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.02,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Martes y Jueves',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.017,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '5:30 pm - 7:30 pm',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.017,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.width * 0.015,
              ),

              if (pickedFile != null)
                Container(
                    width: size.width * 0.95,
                    height: size.height * 0.06,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 2,
                            color: const Color.fromARGB(255, 134, 134, 134)),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: const Color.fromARGB(0, 255, 193, 7)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.01,
                                    ),
                                    Icon(Icons.file_copy_rounded),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 6),
                                      child: Text(
                                        'Archivo seleccionado',
                                        style: TextStyle(
                                            fontFamily: 'Arial',
                                            fontSize: size.height * 0.02,
                                            color: Theme.of(context).colorScheme.secondary),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      child: CircleAvatar(
                                        backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                                        child: Icon(
                                          Icons.delete_rounded,
                                          color: const Color.fromARGB(
                                              255, 245, 66, 53),
                                        ),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          pickedFile = null;
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: size.width * 0.02,
                                    ),
                                    GestureDetector(
                                        child: CircleAvatar(
                                          backgroundColor: const Color.fromARGB(0, 0, 0, 0),
                                          child: Icon(
                                            Icons.upload,
                                            color: const Color.fromARGB(255, 77, 185, 81),
                                          ),
                                        ),
                                        onTap: () {
                                          uploadFile();
                                          pickedFile = null;
                                          uploadTask = null;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Archivo subido'),
                                            duration: Duration(seconds: 3),
                                          ));
                                        }),
                                    SizedBox(
                                      width: size.width * 0.01,
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )),

              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    FutureBuilder<ListResult>(
                      future:
                          FirebaseStorage.instance.ref('/Ciudadaniafiles').listAll(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final files = snapshot.data!.items;
                          return SizedBox(
                            width: size.width,
                            height: size.height * 0.571,
                            child: ListView.builder(
                                itemCount: files.length,
                                itemBuilder: (context, index) {
                                  final file = files[index];
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    child: ScaleAnimation(
                                      duration: Duration(milliseconds: 300),
                                      child: FadeInAnimation(
                                          child: Slidable(
                                        endActionPane: ActionPane(
                                            motion: StretchMotion(),
                                            children: [
                                              SlidableAction(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                onPressed: (context) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          title: Text(
                                                              'Eliminar actividad'),
                                                          content: Text(
                                                              'Estás seguro que quieres borrar esta actividad?'),
                                                          actions: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  FirebaseStorage
                                                                      .instance
                                                                      .ref(
                                                                          '/Ciudadaniafiles')
                                                                      .listAll();
                                                                  setState(() {
                                                                    FirebaseStorage
                                                                        .instance
                                                                        .ref()
                                                                        .child(
                                                                            'Ciudadaniafiles/${file.name}')
                                                                        .delete();
                                                                  });
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(
                                                                          SnackBar(
                                                                    content: Text(
                                                                        'Archivo borrado'),
                                                                    duration: Duration(
                                                                        seconds:
                                                                            3),
                                                                  ));

                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Aceptar')),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Cancelar'))
                                                          ],
                                                        );
                                                      });
                                                },
                                                backgroundColor: Colors.red,
                                                icon: Icons.delete,
                                                label: 'borrar',
                                              )
                                            ]),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border(
                                                  bottom:
                                                      BorderSide(width: 1.1, color: const Color.fromARGB(148, 163, 163, 163)))),
                                          child: ListTile(
                                            leading: SizedBox(
                                                width: size.width * 0.2,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    IconButton(
                                                        onPressed: () =>
                                                            downloadFileIOS(file),
                                                        icon: Icon(
                                                            Icons.download,
                                                            size: size.height *
                                                                0.03)),
                                                    Icon(Icons.file_present,
                                                        size:
                                                            size.height * 0.03),
                                                  ],
                                                )),
                                            title: Text(file.name,
                                                style: TextStyle(
                                                    fontSize:
                                                        size.height * 0.02,
                                                    fontFamily: 'Arial')),
                                          ),
                                        ),
                                      )),
                                    ),
                                  );
                                }),
                          );
                        } else if (snapshot.hasError) {
                          return Text('error');
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
   Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUsera.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      print('Profile Picture could not be found');
    }
  }
  Future downloadFile(Reference ref) async {
    final Directory dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/${ref.name}');
    await ref.writeToFile(file);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${ref.name} descargado'))
    );
  }
  Future<void> downloadFileIOS(Reference ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final path = '${dir.path}/${ref.name}';
  final file = File(path);

  try {
    await ref.writeToFile(file);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Archivo descargado')));

    await OpenFile.open(path);  // ← Esto abre el archivo con la app adecuada
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}
}
