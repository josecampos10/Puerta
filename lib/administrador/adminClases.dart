import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class Adminclases extends StatefulWidget {
  const Adminclases({
    super.key,
  });

  @override
  State<Adminclases> createState() => _AdminclasesState();
}

class _AdminclasesState extends State<Adminclases> {
  List<String> classNames = [];
  Map<String, dynamic> allClassData = {};
  String? selectedClass;
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerdes = TextEditingController();
  final TextEditingController controllersubtitulo = TextEditingController();
  final TextEditingController controllertime1 = TextEditingController();
  final TextEditingController controllertime2 = TextEditingController();
  final TextEditingController controllerday1 = TextEditingController();
  final TextEditingController controllerday2 = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  void loadClasses() async {
    var snapshot = await FirebaseFirestore.instance.collection('clases').get();
    setState(() {
      classNames = snapshot.docs.map((doc) => doc.id).toList();
      for (var doc in snapshot.docs) {
        allClassData[doc.id] = doc.data();
      }
    });
  }

  void actualizarClase() async {
    if (selectedClass == null) return;

    final currentData = allClassData[selectedClass];
    Map<String, dynamic> updates = {};

    if (controller.text.isNotEmpty && controller.text != currentData['Name']) {
      updates['Name'] = controller.text;
    }
    if (controllerdes.text.isNotEmpty &&
        controllerdes.text != currentData['Descripcion']) {
      updates['Descripcion'] = controllerdes.text;
    }
    if (controllersubtitulo.text.isNotEmpty &&
        controllersubtitulo.text != currentData['Subname']) {
      updates['Subname'] = controllersubtitulo.text;
    }
    if (controllerday1.text.isNotEmpty &&
        controllerday1.text != currentData['Days']) {
      updates['Days'] = controllerday1.text;
    }
    if (controllerday2.text.isNotEmpty &&
        controllerday2.text != currentData['Days 2']) {
      updates['Days 2'] = controllerday2.text;
    }
    if (controllertime1.text.isNotEmpty &&
        controllertime1.text != currentData['Time']) {
      updates['Time'] = controllertime1.text;
    }
    if (controllertime2.text.isNotEmpty &&
        controllertime2.text != currentData['Time 2']) {
      updates['Time 2'] = controllertime2.text;
    }

    if (updates.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('clases')
          .doc(selectedClass)
          .update(updates);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clase actualizada correctamente.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se realizaron cambios.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    loadClasses();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var selectedData =
        selectedClass != null ? allClassData[selectedClass] ?? {} : {};

    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
        child: SingleChildScrollView(
          primary: true,
          reverse: false,
          child: Column(children: [
            SizedBox(
              height: size.height * 0.015,
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  alignment: Alignment.center,
                  width: size.width * 0.18,
                  height: size.height * 0.055,
                  child: Text(
                    'Editar clases',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.bold,
                        fontSize: size.height * 0.02,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  children: [
                    SizedBox(height: size.height*0.02,),
                    Container(
                      padding: EdgeInsets.all(7),
                      height: size.height*0.06,
                      width: size.width*0.23,
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withAlpha(30),
                        borderRadius: BorderRadius.circular(20)),
                      
                      child: Center(
                        child: DropdownButton<String>(
                          isDense: false,
                          iconSize: size.height*0.04,
                          underline: null,
                          elevation: 5,
                          hint: Text('Selecciona una clase'),
                          value: selectedClass,
                          items: classNames.map((name) {
                            return DropdownMenuItem(
                              value: name,
                              child: Text(name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedClass = value;
                              selectedData = allClassData[selectedClass] ?? {};
                              controller.text = selectedData['Name'] ?? '';
                              controllersubtitulo.text = selectedData['Subname'] ?? {};
                              controllerdes.text = selectedData['Descripcion'] ?? {};
                              controllerday1.text = selectedData['Days'] ?? {};
                              controllerday2.text = selectedData['Days 2'] ?? {};
                              controllertime1.text = selectedData['Time'] ?? {};
                              controllertime2.text = selectedData['Time 2'] ?? {};
                            });
                          },
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: size.height,
                          width: size.width * 0.45,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: size.height * 0.047,
                                width: size.width * 0.4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 1.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withAlpha(30),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                  cursorHeight: size.height * 0.02,
                                  enableInteractiveSelection: true,
                                  onTapOutside: (event) {
                                    print('onTapOutside');
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  cursorColor:
                                      Theme.of(context).colorScheme.secondary,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  controller: controller,
                                  onChanged: (value) => setState(() {
                                    //controller.text = value.toString();
                                  }),
                                  decoration: InputDecoration(
                                      hint: Text(
                                        'Título de la clase',
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary
                                                .withAlpha(150)),
                                      ),
                                      suffix: Icon(Icons.edit),
                                      border: InputBorder.none),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: size.height * 0.047,
                                width: size.width * 0.4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 1.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withAlpha(30),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Theme(
                                  data: Theme.of(context).copyWith(
                                    textSelectionTheme: TextSelectionThemeData(
      selectionColor: Theme.of(context).colorScheme.tertiary.withAlpha(100),
    ),
                                  ),
                                  child: TextField(
                                    cursorHeight: size.height * 0.02,
                                    enableInteractiveSelection: true,
                                    onTapOutside: (event) {
                                      print('onTapOutside');
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                    },
                                    cursorColor:
                                        Theme.of(context).colorScheme.secondary,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.secondary,
                                    ),
                                     maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    controller: controllersubtitulo,
                                    onChanged: (value) => setState(() {
                                      //controllersubtitulo.text = value.toString();
                                    }),
                                    decoration: InputDecoration(
                                        hint: Text(
                                          'Subtítulo de la clase - Opcional',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withAlpha(150)),
                                        ),
                                        suffix: Icon(Icons.edit),
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                height: size.height * 0.4,
                                width: size.width * 0.4,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 1.0),
                                decoration: BoxDecoration(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary
                                        .withAlpha(30),
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                  cursorHeight: size.height * 0.02,
                                  enableInteractiveSelection: true,
                                  onTapOutside: (event) {
                                    print('onTapOutside');
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  cursorColor:
                                      Theme.of(context).colorScheme.secondary,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  controller: controllerdes,
                                  onChanged: (value) => setState(() {
                                    //controllerdes.text = value.toString();
                                  }),
                                  decoration: InputDecoration(
                                    hint: Text('Descripción',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary
                                              .withAlpha(150)),
                                    ),
                                    border: InputBorder.none,
                                    suffix: Icon(Icons.edit),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: size.height * 0.047,
                                    width: size.width * 0.2,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 1.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withAlpha(30),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextField(
                                      cursorHeight: size.height * 0.02,
                                      enableInteractiveSelection: true,
                                      onTapOutside: (event) {
                                        print('onTapOutside');
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      cursorColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      controller: controllerday1,
                                      onChanged: (value) => setState(() {
                                        //controllerday1.text = value.toString();
                                      }),
                                      decoration: InputDecoration(
                                        hint: Text(
                                          'Días - Principal',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withAlpha(150)),
                                        ),
                                        border: InputBorder.none,
                                        suffix: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: SizedBox(
                                                      height:
                                                          size.height * 0.12,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Utilice el siguiente formato si la clase ocurre más de un día a la semana',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.01,
                                                          ),
                                                          Text(
                                                            'Martes - Jueves',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    title: Icon(
                                                      Icons.info,
                                                      color: Colors.yellow,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.info,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            )),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: size.height * 0.047,
                                    width: size.width * 0.2,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 1.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withAlpha(30),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextField(
                                      cursorHeight: size.height * 0.02,
                                      enableInteractiveSelection: true,
                                      onTapOutside: (event) {
                                        print('onTapOutside');
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      cursorColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      controller: controllerday2,
                                      onChanged: (value) => setState(() {
                                        //controllerday2.text = value.toString();
                                      }),
                                      decoration: InputDecoration(
                                        hint: Text(
                                          'Días - Secundario',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withAlpha(150)),
                                        ),
                                        border: InputBorder.none,
                                        suffix: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: SizedBox(
                                                      height: size.height * 0.2,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Este campo es opcional, llénelo si la clase se ofrece en un grupo distinto al del horario principal. Utilice el siguiente formato si la clase ocurre más de un día a la semana',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.01,
                                                          ),
                                                          Text(
                                                            'Martes - Jueves',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    title: Icon(
                                                      Icons.info,
                                                      color: Colors.yellow,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.info,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: size.height * 0.047,
                                    width: size.width * 0.2,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 1.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withAlpha(30),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextField(
                                      cursorHeight: size.height * 0.02,
                                      enableInteractiveSelection: true,
                                      onTapOutside: (event) {
                                        print('onTapOutside');
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      cursorColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      controller: controllertime1,
                                      onChanged: (value) => setState(() {
                                        //controllertime1.text = value.toString();
                                      }),
                                      decoration: InputDecoration(
                                        hint: Text(
                                          'Horario - Principal',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withAlpha(150)),
                                        ),
                                        border: InputBorder.none,
                                        suffix: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: SizedBox(
                                                      height:
                                                          size.height * 0.12,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Utilice el siguiente formato para el horario principal',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.01,
                                                          ),
                                                          Text(
                                                            '17:30 - 19:30',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    title: Icon(
                                                      Icons.info,
                                                      color: Colors.yellow,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.info,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            )),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    height: size.height * 0.047,
                                    width: size.width * 0.2,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 1.0),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary
                                            .withAlpha(30),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: TextField(
                                      cursorHeight: size.height * 0.02,
                                      enableInteractiveSelection: true,
                                      onTapOutside: (event) {
                                        print('onTapOutside');
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      },
                                      cursorColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                      ),
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      textInputAction: TextInputAction.newline,
                                      controller: controllertime2,
                                      onChanged: (value) => setState(() {
                                        //controllertime2.text = value.toString();
                                      }),
                                      decoration: InputDecoration(
                                        hint: Text(
                                          'Horario - Secundario',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withAlpha(150)),
                                        ),
                                        border: InputBorder.none,
                                        suffix: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    content: SizedBox(
                                                      height:
                                                          size.height * 0.12,
                                                      child: Column(
                                                        children: [
                                                          Text(
                                                            'Este campo es opcional. Utilice el siguiente formato para el horario secundario',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.01,
                                                          ),
                                                          Text(
                                                            '10:00 - 12:00',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .secondary),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    title: Icon(
                                                      Icons.info,
                                                      color: Colors.yellow,
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                            icon: Icon(
                                              Icons.info,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary,
                                            )),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              SizedBox(
                                width: size.height * 0.35,
                                height: size.height * 0.06,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (controller.text == '') {
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Guardar cambios'),
                                              content: Text(
                                                  'Estás seguro que deseas guardar estos cambios?'),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('clases')
                                                          .doc(controller.text)
                                                          .update({
                                                        'Name': controller.text,
                                                        'Descripcion':
                                                            controllerdes.text,
                                                        'Subname':
                                                            controllersubtitulo
                                                                .text,
                                                        'Days':
                                                            controllerday1.text,
                                                        'Days 2':
                                                            controllerday2.text,
                                                        'Time': controllertime1
                                                            .text,
                                                        'Time 2':
                                                            controllertime2.text
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                      controller.clear();
                                                      controllerdes.clear();
                                                      controllerday1.clear();
                                                      controllerday2.clear();
                                                      controllertime1.clear();
                                                      controllertime2.clear();
                                                      controllersubtitulo
                                                          .clear();
                                                    },
                                                    child: Text(
                                                      'Aceptar',
                                                      style: TextStyle(
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary),
                                                    )),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text('Cancelar',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary)))
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      backgroundColor:
                                          Color.fromRGBO(4, 99, 128, 1),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 35, vertical: 10)),
                                  child: Text(
                                    'Confirmar',
                                    style: TextStyle(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        fontSize: size.height * 0.02,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ////////////////
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: size.height,
                          width: size.width * 0.4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          child: Column(
                            children: [
                              
                              SizedBox(
                                child: StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('clases')
                                        .snapshots(),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<QuerySnapshot> snapshot) {
                                      if (snapshot.hasData) {
                                        final snap = snapshot.data!.docs;
                                        return Container(
                                          constraints: BoxConstraints(
                                              minHeight: size.height * 0.8,
                                              maxHeight: size.height * 0.8),
                                          width: size.width * 0.3,
                                          // height: size.height * 0.27,
                                          child: GridView.builder(
                                            padding: EdgeInsets.zero,
                                            physics: ScrollPhysics(),
                                            scrollDirection: Axis.vertical,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 1,
                                                    childAspectRatio: 6),
                                            reverse: false,
                                            shrinkWrap: true,
                                            primary: false,
                                            itemCount: snap.length,
                                            cacheExtent: 1000.0,
                                            itemBuilder: (context, index) {
                                              return Slidable(
                                                endActionPane: ActionPane(
                                                    motion: StretchMotion(),
                                                    children: [
                                                      SlidableAction(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        onPressed: (context) {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return AlertDialog(
                                                                  title: Text(
                                                                      'Eliminar clase',
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .secondary)),
                                                                  content: Text(
                                                                      'Estás seguro que quieres eliminar esta clase?',
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .secondary)),
                                                                  actions: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          FirebaseFirestore
                                                                              .instance
                                                                              .collection('clases')
                                                                              .doc(snapshot.data!.docs[index]['Name'])
                                                                              .delete();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            'Aceptar',
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).colorScheme.secondary))),
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        child: Text(
                                                                            'Cancelar',
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).colorScheme.secondary)))
                                                                  ],
                                                                );
                                                              });
                                                        },
                                                        backgroundColor:
                                                            Colors.red,
                                                        icon: Icons.delete,
                                                        label: 'borrar',
                                                      ),
                                                      ///////////////
                                                      SlidableAction(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15.0),
                                                        onPressed: (context) {},
                                                        backgroundColor:
                                                            const Color
                                                                .fromARGB(255,
                                                                244, 158, 54),
                                                        icon: Icons.edit,
                                                        label: 'editar',
                                                      )
                                                    ]),
                                                child: SizedBox(
                                                  height: size.height * 0.07,
                                                  width: size.width,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      if(snap[index]['Name'] == 'GED'){
                                                        Navigator.pushNamed(context, '/profeGEDpm');
                                                      }
                                                      if(snap[index]['Name'] == 'Corte y Confección 1'){
                                                        Navigator.pushNamed(context, '/profeCorte1');
                                                      }
                                                      if(snap[index]['Name'] == 'Corte y Confección 2'){
                                                        Navigator.pushNamed(context, '/profeCorte2');
                                                      }
                                                      if(snap[index]['Name'] == 'Cosmetología'){
                                                        Navigator.pushNamed(context, '/profeCosmetologia');
                                                      }
                                                      if(snap[index]['Name'] == 'Costura básica'){
                                                        Navigator.pushNamed(context, '/profeCosturaAM');
                                                      }
                                                      if(snap[index]['Name'] == 'ESL Clifton'){
                                                        Navigator.pushNamed(context, '/profeESLclifton');
                                                      }
                                                      if(snap[index]['Name'] == 'GED AM'){
                                                        Navigator.pushNamed(context, '/profeGEDam');
                                                      }
                                                      if(snap[index]['Name'] == 'Ciudadanía'){
                                                        Navigator.pushNamed(context, '/profeCiudadania');
                                                      }
                                                      if(snap[index]['Name'] == 'ESL 2 pm'){
                                                        Navigator.pushNamed(context, '/profeESLpm2');
                                                      }
                                                      if(snap[index]['Name'] == 'ESL 1 pm'){
                                                        Navigator.pushNamed(context, '/profeESLpm');
                                                      }
                                                      if(snap[index]['Name'] == 'ESL 1 am'){
                                                        Navigator.pushNamed(context, '/profeESLam');
                                                      }
                                                      if(snap[index]['Name'] == 'ESL 2 AM'){
                                                        Navigator.pushNamed(context, '/profeESLam2');
                                                      }
                                                      if(snap[index]['Name'] == 'ESL Chick-fil-A'){
                                                        Navigator.pushNamed(context, '/profechick');
                                                      }
                                                    },
                                                    child: Card(
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 16,
                                                          vertical: 8),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              side: BorderSide
                                                                  .none,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0)),
                                                      elevation: 5,
                                                      //shadowColor: Colors.black26,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary
                                                          .withAlpha(150),
                                                      child: Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                  Text(
                                                                    snap[index][
                                                                        'Name'],
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          size.height *
                                                                              0.022,
                                                                      fontFamily:
                                                                          'Arial',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .colorScheme
                                                                          .secondary,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: 5,
                                                                  ),
                                                                ]),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    }),
                              ),
                              
                            ],
                          ),
                        ),
                      ],
                    ),
                    /////////////////
                  ],
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
