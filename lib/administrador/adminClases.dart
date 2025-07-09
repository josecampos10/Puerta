import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Adminclases extends StatefulWidget {
  const Adminclases({
    Key? key,
  }) : super(key: key);

  @override
  State<Adminclases> createState() => _AdminclasesState();
}

class _AdminclasesState extends State<Adminclases> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerdes = TextEditingController();
  final TextEditingController controllersubtitulo = TextEditingController();
  final TextEditingController controllertime1 = TextEditingController();
  final TextEditingController controllertime2 = TextEditingController();
  final TextEditingController controllerday1 = TextEditingController();
  final TextEditingController controllerday2 = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        centerTitle: true,
        title: Text(
                    'Agregar Clase',
                    style: TextStyle(
                        fontSize: size.width * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
        toolbarHeight: size.height*0.09,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        
      ),
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      body: Container(
        height: size.height * 0.93,
        width: size.width,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/foto4.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),*/
        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          reverse: false,
          child: Column(children: [
            
            Container(
              child: Column(
                children: [
                 
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      controller: controller,
                      onChanged: (value) => setState(() {
                        controller.text = value.toString();
                      }),
                      decoration: InputDecoration(
                        labelText: 'Título de la clase',
                        prefixIcon: Icon(Icons.add),
                        labelStyle: TextStyle(
                            fontSize: size.height * 0.018,
                            fontFamily: 'Impact',
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      controller: controllersubtitulo,
                      onChanged: (value) => setState(() {
                        controllersubtitulo.text = value.toString();
                      }),
                      decoration: InputDecoration(
                        labelText: 'Subtítulo de la clase - Opcional',
                        prefixIcon: Icon(Icons.add),
                        labelStyle: TextStyle(
                            fontSize: size.height * 0.018,
                            fontFamily: 'Impact',
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 1.0),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: controllerdes,
                      onChanged: (value) => setState(() {
                        controllerdes.text = value.toString();
                      }),
                      decoration: InputDecoration(
                        labelText: 'Descripcion de la clase',
                        prefixIcon: Icon(Icons.add),
                        labelStyle: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Impact',
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.43,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 1.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: controllerday1,
                          onChanged: (value) => setState(() {
                            controllerday1.text = value.toString();
                          }),
                          decoration: InputDecoration(
                            hintText: 'Martes - Jueves',
                            hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 175, 175, 175),
                                fontSize: size.height * 0.018),
                            suffix: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          height: size.height * 0.12,
                                          child: Column(
                                            children: [
                                              Text(
                                                'Utilice el siguiente formato si la clase ocurre más de un día a la semana',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              ),
                                              SizedBox(
                                                height: size.height * 0.01,
                                              ),
                                              Text(
                                                'Martes - Jueves',
                                                style: TextStyle(
                                                    color: Theme.of(context)
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
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                            labelText: 'Días - Principal',
                            labelStyle: TextStyle(
                                fontSize: size.height * 0.018,
                                fontFamily: 'Impact',
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.43,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 1.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: controllerday2,
                          onChanged: (value) => setState(() {
                            controllerday2.text = value.toString();
                          }),
                          decoration: InputDecoration(
                            hintText: 'Martes - Jueves',
                            hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 175, 175, 175),
                                fontSize: size.height * 0.018),
                            suffix: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          height: size.height * 0.2,
                                          child: Column(
                                            children: [
                                              Text(
                                                'Este campo es opcional, llénelo si la clase se ofrece en un grupo distinto al del horario principal. Utilice el siguiente formato si la clase ocurre más de un día a la semana',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              ),
                                              SizedBox(
                                                height: size.height * 0.01,
                                              ),
                                              Text(
                                                'Martes - Jueves',
                                                style: TextStyle(
                                                    color: Theme.of(context)
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
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                            labelText: 'Días - Secundario',
                            labelStyle: TextStyle(
                                fontSize: size.height * 0.018,
                                fontFamily: 'Impact',
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: size.width * 0.43,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 1.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: controllertime1,
                          onChanged: (value) => setState(() {
                            controllertime1.text = value.toString();
                          }),
                          decoration: InputDecoration(
                            hintText: '17:30 - 19:30',
                            hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 175, 175, 175),
                                fontSize: size.height * 0.018),
                            suffix: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          height: size.height * 0.12,
                                          child: Column(
                                            children: [
                                              Text(
                                                'Utilice el siguiente formato para el horario principal',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              ),
                                              SizedBox(
                                                height: size.height * 0.01,
                                              ),
                                              Text(
                                                '17:30 - 19:30',
                                                style: TextStyle(
                                                    color: Theme.of(context)
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
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                            labelText: 'Horario - Principal',
                            labelStyle: TextStyle(
                                fontSize: size.height * 0.018,
                                fontFamily: 'Impact',
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.43,
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 1.0),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          cursorColor: Theme.of(context).colorScheme.secondary,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          controller: controllertime2,
                          onChanged: (value) => setState(() {
                            controllertime2.text = value.toString();
                          }),
                          decoration: InputDecoration(
                            hintText: '10:00 - 12:00',
                            hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 175, 175, 175),
                                fontSize: size.height * 0.018),
                            suffix: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          height: size.height * 0.12,
                                          child: Column(
                                            children: [
                                              Text(
                                                'Este campo es opcional. Utilice el siguiente formato para el horario secundario',
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              ),
                                              SizedBox(
                                                height: size.height * 0.01,
                                              ),
                                              Text(
                                                '10:00 - 12:00',
                                                style: TextStyle(
                                                    color: Theme.of(context)
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
                                  color: Theme.of(context).colorScheme.tertiary,
                                )),
                            labelText: 'Horario - Secundario',
                            labelStyle: TextStyle(
                                fontSize: size.height * 0.018,
                                fontFamily: 'Impact',
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  SizedBox(
                    height: size.height * 0.05,
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
                                  title: Text('Agregar una clase'),
                                  content: Text(
                                      'Estás seguro que quieres añadir una clase?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('clases')
                                              .doc(controller.text)
                                              .set({
                                            'Name': controller.text,
                                            'Descripcion': controllerdes.text,
                                            'Subname': controllersubtitulo.text,
                                            'Days': controllerday1.text,
                                            'Days 2': controllerday2.text,
                                            'Time': controllertime1.text,
                                            'Time 2': controllertime2.text
                                          });
                                          Navigator.of(context).pop();
                                          controller.clear();
                                          controllerdes.clear();
                                          controllerday1.clear();
                                          controllerday2.clear();
                                          controllertime1.clear();
                                          controllertime2.clear();
                                          controllersubtitulo.clear();
                                        },
                                        child: Text(
                                          'Aceptar',
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary),
                                        )),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancelar',
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
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Color.fromRGBO(4, 99, 128, 1),
                          padding: EdgeInsets.symmetric(
                              horizontal: 35, vertical: 10)),
                      child: Text(
                        'Confirmar',
                        style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: size.width * 0.044,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height*0.03,
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('clases')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          final snap = snapshot.data!.docs;
                          return Container(
                            constraints: BoxConstraints(
                                minHeight: size.height * 0.4,
                                maxHeight: size.height * 0.5),
                            width: size.width - 30,
                            // height: size.height * 0.27,
                            child: GridView.builder(
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1, childAspectRatio: 6),
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
                                              BorderRadius.circular(15.0),
                                          onPressed: (context) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Eliminar clase',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary)),
                                                    content: Text(
                                                        'Estás seguro que quieres eliminar esta clase?',
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary)),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'clases')
                                                                .doc(snapshot
                                                                        .data!
                                                                        .docs[
                                                                    index]['Name'])
                                                                .delete();
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text('Aceptar',
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary))),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child: Text(
                                                              'Cancelar',
                                                              style: TextStyle(
                                                                  color: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .secondary)))
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
                                    height: size.height * 0.07,
                                    width: size.width,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                width: 1,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary),
                                            borderRadius:
                                                BorderRadius.circular(15.0)),
                                        elevation: 50,
                                        shadowColor: Colors.black26,
                                        color: Color.fromRGBO(199, 228, 241, 0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(7),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                        snap[index]['Name'],
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.022,
                                                          fontFamily: '',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
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
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
