import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Studenteslfilesam extends StatefulWidget {
  const Studenteslfilesam({super.key});
  @override
  State<Studenteslfilesam> createState() => _StudenteslfilesamState();
}

class _StudenteslfilesamState extends State<Studenteslfilesam> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  CollectionReference users = FirebaseFirestore.instance.collection('postsESLam');
  late Future<List<Reference>> futureFiles;
  PlatformFile? pickedFile;
  List<PlatformFile>? selectedFiles;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showFab = true;
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  UploadTask? uploadTask;
  late Future<DocumentSnapshot> futureUserDoc;

  Future<void> uploadFile() async {
    Size size = MediaQuery.of(context).size;
    final folderRef = FirebaseStorage.instance.ref().child('ESLfilesam');
    final originalName = pickedFile!.name;
    final file = File(pickedFile!.path!);

    String nameWithoutExtension = originalName.split('.').first;
    String extension = originalName.split('.').last;
    String finalName = originalName;
    int count = 1;

    // 1. Obtener lista de archivos existentes
    final existingFiles = await folderRef.listAll();
    final existingNames = existingFiles.items.map((e) => e.name).toList();

    // 2. Buscar nombre disponible
    while (existingNames.contains(finalName)) {
      count++;
      finalName = '$nameWithoutExtension ($count).$extension';
    }

    // 3. Subir archivo con el nuevo nombre
    final path = 'ESLfilesam/$finalName';
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

    // 4. Mostrar mensaje si quieres
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Archivo subido, refresque la lista de archivos',
          style: TextStyle(
              fontFamily: 'Arial',
              color: Colors.white,
              fontSize: size.height * 0.015),
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  Future<List<Reference>> obtenerArchivosOrdenados() async {
    final result = await FirebaseStorage.instance.ref('/ESLfilesam').listAll();
    final archivos = result.items;

    // Obtener los metadatos de cada archivo
    final archivosConFecha = await Future.wait(
      archivos.map((archivo) async {
        final metadata = await archivo.getMetadata();
        return {
          'ref': archivo,
          'fecha': metadata.timeCreated ?? DateTime(1970),
        };
      }),
    );

    // Ordenar por fecha descendente (más reciente primero)
    archivosConFecha.sort(
      (a, b) => (b['fecha'] as DateTime).compareTo(a['fecha'] as DateTime),
    );

    // Devolver solo las referencias ya ordenadas
    return archivosConFecha.map((e) => e['ref'] as Reference).toList();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      futureFiles = obtenerArchivosOrdenados();
    });
  }

  @override
  void initState() {
    super.initState();
    futureFiles = obtenerArchivosOrdenados();
    getProfilePicture();
    futureUserDoc =
        FirebaseFirestore.instance.collection('clases').doc('esl 1 am').get();
    //uploadTask = null;
    //selectFile();
  }

  @override
  void dispose() {
    super.dispose();
    getProfilePicture();
    futureFiles = obtenerArchivosOrdenados();
    //pickedFile = null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      
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
                  fontWeight: FontWeight.bold,
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
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.087),
                topRight: Radius.circular(size.width * 0.087))),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: futureUserDoc,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: size.height * 0.2,
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Theme.of(context).colorScheme.tertiary,
                          size: size.width * 0.055,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Container(
                      height: size.height * 0.2,
                      child: Center(child: Text('No hay datos del usuario')),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          filterQuality: FilterQuality.low,
                          image: AssetImage('assets/img/ESLam.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(size.width * 0.087)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['Name'] ?? 'Nombre clase',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.06,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['Subname'] ?? 'Descripción',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.02,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['Days'] ?? 'Días',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.017,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['Time'] ?? 'Horario',
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
                  );
                },
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              
              SizedBox(
                height: size.width * 0.0,
              ),
              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    FutureBuilder<List<Reference>>(
                      future: futureFiles,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Text('Something went wrong');
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Column(children: [
                            SpinKitFadingCircle(
                              color: Theme.of(context).colorScheme.tertiary,
                              size: size.width * 0.055,
                            ),
                          ]);
                        }
                        if (snapshot.hasData) {
                          final files = snapshot.data!;
                          if (files.isEmpty) {
                            return SizedBox(
                              height: size.height * 0.515,
                              child: RefreshIndicator(
                                elevation: 0,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                color: Theme.of(context).colorScheme.tertiary,
                                onRefresh: _refresh,
                                child: ListView(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10.0),
                                      child: Center(
                                        child: Text(
                                          'Sin archivos',
                                          style: TextStyle(
                                            fontSize: size.height * 0.018,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                          return SizedBox(
                            width: size.width,
                            height: size.height * 0.515,
                            child: NotificationListener<UserScrollNotification>(
                              onNotification: (notification) {
                                final ScrollDirection direction =
                                    notification.direction;
                                setState(() {
                                  if (direction == ScrollDirection.reverse) {
                                    _showFab = false;
                                  } else if (direction ==
                                      ScrollDirection.forward) {
                                    _showFab = true;
                                  }
                                });
                                return true;
                              },
                              child: RefreshIndicator(
                                elevation: 0,
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                color: Theme.of(context).colorScheme.tertiary,
                                onRefresh: _refresh,
                                child: ListView.builder(
                                    itemCount: files.length,
                                    itemBuilder: (context, index) {
                                      final file = files[index];
                                      return AnimationConfiguration
                                          .staggeredList(
                                        position: index,
                                        child: ScaleAnimation(
                                          duration: Duration(milliseconds: 300),
                                          child: FadeInAnimation(
                                              child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 1.1,
                                                          color: const Color
                                                              .fromARGB(148,
                                                              163, 163, 163)))),
                                              child: ListTile(
                                                leading: SizedBox(
                                                    width: size.width * 0.11,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () =>
                                                                downloadFileIOS(
                                                                    file),
                                                            icon: Icon(
                                                                Icons.download,
                                                                size:
                                                                    size.height *
                                                                        0.03)),
                                                      ],
                                                    )),
                                                title: Text(file.name,
                                                    style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.018,
                                                        fontFamily: 'Arial',
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary)),
                                              ),
                                            ),
                                          
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
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
    Size size = MediaQuery.of(context).size;
    final Directory dir = Directory('/storage/emulated/0/Download');
    final file = File('${dir.path}/${ref.name}');
    await ref.writeToFile(file);
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
        content: Text(
          'Descargado',
          style: TextStyle(
              fontFamily: 'Arial',
              color: Colors.white,
              fontSize: size.height * 0.015),
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),);
  }

  Future<void> downloadFileIOS(Reference ref) async {
    Size size = MediaQuery.of(context).size;
    final dir = await getApplicationDocumentsDirectory();
    final path = '${dir.path}/${ref.name}';
    final file = File(path);

    try {
      await ref.writeToFile(file);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(
             SnackBar(
        content: Text(
          'Descargado',
          style: TextStyle(
              fontFamily: 'Arial',
              color: Colors.white,
              fontSize: size.height * 0.015),
        ),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ));

      await OpenFile.open(path); // ← Esto abre el archivo con la app adecuada
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}
