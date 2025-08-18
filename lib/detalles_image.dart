import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:lapuerta2/main.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageDetallesHome extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const ImageDetallesHome({super.key, required this.documentSnapshot});

  @override
  State<ImageDetallesHome> createState() => _ImageDetallesHomeState();
}

class _ImageDetallesHomeState extends State<ImageDetallesHome> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  Uint8List? pickedImage;
  bool showInfo = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 1),
      body: GestureDetector(
        onTap: () {
          setState(() {
            showInfo = !showInfo;
          });
        },
        child: Stack(
          children: [
            // Imagen en pantalla completa con zoom
            Positioned.fill(
              child: PinchZoom(
                maxScale: 5.0,
                child: Hero(
                  tag: widget.documentSnapshot,
                  flightShuttleBuilder: (
                    flightContext,
                    animation,
                    flightDirection,
                    fromHeroContext,
                    toHeroContext,
                  ) {
                    return FadeTransition(
                      opacity: animation.drive(
                          Tween(begin: size.height, end: 1.0)
                              .chain(CurveTween(curve: Curves.easeInOut))),
                      child: toHeroContext.widget,
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.documentSnapshot['postUrl'],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(
                      child: Text(
                        'No se pudo cargar la imagen',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Botón de cerrar en la parte superior derecha
            Positioned(
              top: size.height * 0.07,
              right: 20,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: showInfo ? 1.0 : 0.0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ),

            // Información del usuario en la parte inferior
            Positioned(
              left: 0,
              right: 0,
              bottom: size.height * 0.04,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 300),
                opacity: showInfo ? 1.0 : 0.0,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.black
                        .withOpacity(0.2), // sombreado oscuro con opacidad
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.003,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: size.width * 0.014,
                          ),
                          CircleAvatar(
                            radius: size.height * 0.018,
                            backgroundImage:
                                NetworkImage(widget.documentSnapshot['Image']),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      (widget.documentSnapshot['Name'] !=
                                                  null &&
                                              widget.documentSnapshot['Name']
                                                  .toString()
                                                  .trim()
                                                  .isNotEmpty)
                                          ? widget.documentSnapshot['Name']
                                          : widget.documentSnapshot['User'],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: size.height * 0.017,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      widget.documentSnapshot['Date'],
                                      style: TextStyle(
                                        color: Colors.grey[300],
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Text(
                            widget.documentSnapshot['Time'],
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: size.height * 0.016,
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.014,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.018,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
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

Future _launchUrlclass() async {
  final Uri url = Uri.parse(
      "https://www.lapuertawaco.com/educacion"); // Replace with your YouTube video URL

  if (!await launchUrl(url)) {
    throw Exception("Could not launch $url");
  }
}
