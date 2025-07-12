import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetallesHome extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetallesHome({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 99, 128, 1).withOpacity(0.8),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/foto4.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: size.width,
              height: size.height * 0.32,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 7,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  //color: Colors.green,
                  image: DecorationImage(
                      image: AssetImage('assets/img/foto5.jpg'),
                      fit: BoxFit.cover,
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.7), BlendMode.darken)),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(130),
                      bottomRight: Radius.circular(130))),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.08,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: size.width * 0.12,
                          width: size.width * 0.12,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.grey.withOpacity(0.5)),
                          child: Icon(Icons.close,
                              color: const Color.fromARGB(255, 179, 179, 179)),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.04,
                      )
                    ],
                  ),
                  //SizedBox( height: size.height * 0.1 ),
                  Text(
                    documentSnapshot['Name'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.16,
                        fontFamily: 'Arial'),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    'Descripción',
                    style: TextStyle(
                        fontSize: size.width * 0.055,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(
                    height: size.height * 0.006,
                  ),
                  SizedBox(
                    width: size.width - 20,
                    height: size.height * 0.48,
                    child: Text(
                      documentSnapshot['Descripcion'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.037,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.055,
                    width: size.width * 0.55,
                    child: ElevatedButton(
                      onPressed: _launchUrlclass,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(size.width * 0.025))),
                      child: Text(
                        'Inscribirse',
                        style: TextStyle(
                            fontSize: size.width * 0.04, color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}


Future _launchUrlclass() async {
  final Uri url = Uri.parse(
      "https://www.lapuertawaco.com/educacion"); // Replace with your YouTube video URL

  if (!await launchUrl(url)) {
    throw Exception("Could not launch $url");
  }
}
