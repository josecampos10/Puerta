import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Adminrecursos extends StatefulWidget {
  const Adminrecursos({
    Key? key,
  }) : super(key: key);

  @override
  State<Adminrecursos> createState() => _AdminrecursosState();
}

class _AdminrecursosState extends State<Adminrecursos> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerdes = TextEditingController();
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
                    'Agregar Recursos',
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
          physics: NeverScrollableScrollPhysics(),
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
                      controller: controller,
                      onChanged: (value) => setState(() {
                        controller.text = value.toString();
                      }),
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary
                      ),
                      decoration: InputDecoration(
                        labelText: 'Nombre del recurso',
                        prefixIcon: Icon(Icons.add),
                        labelStyle:
                            TextStyle(fontSize: size.height*0.018, fontFamily: 'Impact',color: Theme.of(context).colorScheme.secondary),
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
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      controller: controllerdes,
                      onChanged: (value) => setState(() {
                        controllerdes.text = value.toString();
                      }),
                      cursorColor: Theme.of(context).colorScheme.secondary,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary
                      ),
                      decoration: InputDecoration(
                        labelText: 'Descripcion del recurso',
                        prefixIcon: Icon(Icons.add),
                        labelStyle:
                            TextStyle(fontSize: size.height*0.018, fontFamily: 'Impact', color: Theme.of(context).colorScheme.secondary),
                      ),
                    ),
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
                                  title: Text('Agregar un recurso'),
                                  content: Text(
                                      'Estás seguro que quieres añadir un recurso?'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance
                                              .collection('recursos')
                                              .doc(controller.text)
                                              .set({
                                            'Name': controller.text,
                                            'Descripcion': controllerdes.text
                                          });
                                          Navigator.of(context).pop();
                                          controller.clear();
                                          controllerdes.clear();
                                        },
                                        child: Text('Aceptar', style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.secondary),))
                                  ],
                                );
                              });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                width: 0,
                                color: const Color.fromARGB(0, 76, 175, 79)),
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
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.03,
            ),

            SingleChildScrollView(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('recursos')
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
                        //height: size.height * 0.4,
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
                                      borderRadius: BorderRadius.circular(10.0),
                                      onPressed: (context) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Eliminar recurso'),
                                                content: Text(
                                                    'Estás seguro que quieres borrar un recurso?'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'recursos')
                                                            .doc(snapshot.data!
                                                                    .docs[index]
                                                                ['Name'])
                                                            .delete();
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Aceptar', style: TextStyle(color: Theme.of(context).colorScheme.secondary),)),
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: Text('Cancelar', style: TextStyle(color: Theme.of(context).colorScheme.secondary),))
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
                                    
                                        side: BorderSide(width: 1, color: Theme.of(context).colorScheme.secondary),
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                    elevation: 50,
                                    shadowColor: Colors.black26,
                                    color: Color.fromRGBO(4, 99, 128, 0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(1),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    snap[index]['Name'],
                                                    style: TextStyle(
                                                      fontSize:
                                                          size.height * 0.022,
                                                      fontFamily: '',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context).colorScheme.secondary,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  if (snap[index]['Name'] ==
                                                      'Consejeria')
                                                    InkWell(
                                                      child: Icon(Icons
                                                          .family_restroom),
                                                    ),
                                                  if (snap[index]['Name'] ==
                                                      'Despensa')
                                                    InkWell(
                                                      child:
                                                          Icon(Icons.food_bank),
                                                    ),
                                                  if (snap[index]['Name'] ==
                                                      'Salud')
                                                    InkWell(
                                                      child: Icon(
                                                          Icons.local_hospital),
                                                    ),
                                                  if (snap[index]['Name'] ==
                                                      'Abogacia')
                                                    InkWell(
                                                      child: Icon(Icons.work),
                                                    ),
                                                    if (snap[index]['Name'] ==
                                                      'Comida')
                                                    InkWell(
                                                      child: Icon(Icons.food_bank),
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
            ),
          ]),
        ),
      ),
    );
  }
}
