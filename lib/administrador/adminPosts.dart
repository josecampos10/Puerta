import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminPosts extends StatefulWidget {
  const AdminPosts({
    Key? key,
  }) : super(key: key);

  @override
  State<AdminPosts> createState() => _AdminclasesState();
}

class _AdminclasesState extends State<AdminPosts> {
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerdes = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  late String imageUrl;
  final storage = FirebaseStorage.instance;
  final String time = '';

  @override
  void initState() {
    super.initState();
    imageUrl = '';
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Administrar publicaciones',
          style: TextStyle(
              fontSize: size.width * 0.045,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        toolbarHeight: size.height * 0.09,
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
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          reverse: false,
          child: Column(children: [
            SizedBox(
              height: size.height * 0.02,
            ),
            SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(children: [
                        SizedBox(
                          height: size.height * 0.005,
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
                        color: Theme.of(context).colorScheme.tertiary,
                        backgroundColor: Colors.white,
                        displacement: 1,
                        strokeWidth: 3,
                        onRefresh: () async {},
                        child: Container(
                          height: size.height * 0.793,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(size.width * 0.25),
                                  topRight:
                                      Radius.circular(size.width * 0.25))),
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
                                // final DocumentSnapshot documentSnapshot =
                                //  snapshot.data!.docs[index];
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
                                                                  FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'posts')
                                                                      .doc(snapshot
                                                                          .data!
                                                                          .docs[
                                                                              index]
                                                                          .id)
                                                                      .delete();
                                                                  FirebaseStorage
                                                                      .instance
                                                                      .refFromURL(
                                                                          snap[index]
                                                                              [
                                                                              'postUrl'])
                                                                      .delete();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Aceptar',
                                                                    style: TextStyle(
                                                                        color: Theme.of(context)
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
                                                                        color: Theme.of(context)
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
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      size.width * 0.04)),
                                          elevation: size.height * 0.01,
                                          shadowColor: Colors.black,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
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
                                                      backgroundImage:
                                                          NetworkImage(
                                                              snap[index]
                                                                  ['Image']),
                                                      minRadius:
                                                          size.height * 0.015,
                                                      maxRadius:
                                                          size.height * 0.015,
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiary,
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Text(
                                                        snap[index]['User'],
                                                        style: TextStyle(
                                                          fontSize:
                                                              size.height *
                                                                  0.019,
                                                          fontFamily:
                                                              'JosefinSans',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .secondary,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    Text(
                                                      snap[index]['Date'],
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.014,
                                                        fontFamily:
                                                            'JosefinSans',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 167, 167, 167),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.02,
                                                    ),
                                                    Text(
                                                      snap[index]['Time'],
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.014,
                                                        fontFamily:
                                                            'JosefinSans',
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 167, 167, 167),
                                                      ),
                                                    ),
                                                  ]),
                                                  Align(
                                                      alignment:
                                                          Alignment.topLeft,
                                                      child: Linkify(
                                                        linkStyle: TextStyle(
                                                            decoration:
                                                                TextDecoration
                                                                    .none,
                                                            fontSize:
                                                                size.height *
                                                                    0.0162,
                                                            fontFamily:
                                                                'Impact',
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color
                                                                .fromARGB(255,
                                                                94, 145, 255)),
                                                        style: TextStyle(
                                                            fontSize:
                                                                size.height *
                                                                    0.0162,
                                                            fontFamily:
                                                                'Impact',
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                        text: snap[index]
                                                            ['Comment'],
                                                        onOpen: (link) async {
                                                          if (!await launchUrl(
                                                              Uri.parse(
                                                                  link.url))) {
                                                            throw Exception(
                                                                'Could not launch ${link.url}');
                                                          }
                                                        },
                                                      )),
                                                  SizedBox(
                                                    height: size.height * 0.01,
                                                  ),
                                                  snap[index]['postUrl'] !=
                                                          'no imagen'
                                                      ? Container(
                                                          height: size.height *
                                                              0.35,
                                                          width: size.height,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: const Color
                                                                .fromARGB(0,
                                                                158, 158, 158),
                                                            border: Border.all(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      4,
                                                                      99,
                                                                      128,
                                                                      0),
                                                              width:
                                                                  size.height *
                                                                      0.0,
                                                            ),
                                                            //shape: BoxShape.circle,
                                                            image:
                                                                DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image: Image
                                                                        .network(
                                                                      snap[index]
                                                                          [
                                                                          'postUrl']!,
                                                                    ).image),
                                                          ),
                                                        )
                                                      : Container(
                                                          height:
                                                              size.height * 0.0,
                                                          width: size.height,
                                                        ),
                                                ],
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
                  }),
            )
          ]),
        ),
      ),
    );
  }
}
