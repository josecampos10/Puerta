import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AdminUserslist extends StatefulWidget {
  AdminUserslist({Key? key}) : super(key: key);
  @override
  State<AdminUserslist> createState() => _AdminUserslistState();

}




class _AdminUserslistState extends State<AdminUserslist> {
  final adminService = AdminService();

  
    final currentUser = FirebaseAuth.instance.currentUser!;
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
          padding: EdgeInsets.all(size.width * 0.015),
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
              'Lista de usuarios',
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
          physics: NeverScrollableScrollPhysics(),
          primary: false,
          reverse: false,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.01,
              ),
              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(children: [
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              SpinKitFadingCircle(
                                color: Color.fromRGBO(4, 99, 128, 1),
                                size: size.width * 0.1,
                              ),
                            ]);
                          }
                          if (snapshot.hasData) {
                            final snap = snapshot.data!.docs;
                            return RefreshIndicator(
                              color: Color.fromRGBO(3, 69, 88, 1),
                              backgroundColor: Colors.white,
                              displacement: 1,
                              strokeWidth: 3,
                              onRefresh: () async {},
                              child: SizedBox(
                                height: size.height * 0.787,
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: MasonryGridView.builder(
                                    padding: EdgeInsets.zero,
                                    gridDelegate:
                                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 1),
                                    mainAxisSpacing: 1,
                                    crossAxisSpacing: 1,
                                    physics: ScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    primary: true,
                                    itemCount: snap.length,
                                    cacheExtent: 1000.0,
                                    itemBuilder: (context, index) {
                                     final doc = snapshot.data!.docs[index];
                                     final email = doc['email'];
                                      // final DocumentSnapshot documentSnapshot =
                                      //  snapshot.data!.docs[index];
                                      return AnimationConfiguration
                                          .staggeredList(
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
                                                          BorderRadius.circular(
                                                              10.0),
                                                      onPressed: (context) {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Eliminar recurso'),
                                                                content: Text(
                                                                    'Estás seguro que quieres borrar un recurso?'),
                                                                actions: [
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        FirebaseFirestore
                                                                            .instance
                                                                            .collection('users')
                                                                            .doc(snapshot.data!.docs[index]['email'])
                                                                            .delete();
                                                                            adminService.deleteUserByEmail(email);
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                          'Aceptar')),
                                                                  TextButton(
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      child: Text(
                                                                          'Cancelar'))
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      backgroundColor:
                                                          Colors.red,
                                                      icon: Icons.delete,
                                                      label: 'borrar',
                                                    )
                                                  ]),
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              size.width *
                                                                  0.04)),
                                                  elevation: size.height * 0.01,
                                                  shadowColor: Colors.black,
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 1),
                                                  child: Container(
                                                    //constraints: const BoxConstraints(minHeight: ),
                                                    //width: 180,
                                                    //height: 20,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          size.width * 0.03),
                                                      child: Column(
                                                        children: [
                                                          Row(children: [
                                                            CircleAvatar(
                                                              minRadius:
                                                                  size.height *
                                                                      0.015,
                                                              maxRadius:
                                                                  size.height *
                                                                      0.015,
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      94,
                                                                      64,
                                                                      112),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02,
                                                            ),
                                                            Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                snap[index]
                                                                    ['name'],
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      size.height *
                                                                          0.019,
                                                                  fontFamily:
                                                                      'JosefinSans',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          0,
                                                                          0,
                                                                          0)
                                                                      .withOpacity(
                                                                          0.9),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02,
                                                            ),
                                                          ]),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              snap[index]
                                                                  ['email'],
                                                              style: TextStyle(
                                                                fontSize:
                                                                    size.height *
                                                                        0.0162,
                                                                fontFamily:
                                                                    'Impact',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal,
                                                                color: Color
                                                                        .fromRGBO(
                                                                            0,
                                                                            0,
                                                                            0,
                                                                            1)
                                                                    .withOpacity(
                                                                        0.9),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        })
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AdminService {
  Future<void> deleteUserByEmail(String email) async {
    try {
      final callable = FirebaseFunctions.instance.httpsCallable('deleteUser');
      final result = await callable.call({'email': email});
      print(result.data['message']);
    } on FirebaseFunctionsException catch (e) {
      print('FirebaseFunctionsException: ${e.message}');
    } catch (e) {
      print('Unknown error: $e');
    }
  }
}