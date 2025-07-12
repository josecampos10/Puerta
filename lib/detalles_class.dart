import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetallesClassHome extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;
  const DetallesClassHome({super.key, required this.documentSnapshot});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 99, 128, 1),
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/back.png'),
            fit: BoxFit.fitHeight,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.dstATop),
          ),
        ),
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
                    image: AssetImage('assets/img/foto4.jpg'),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.79), BlendMode.darken)),
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
                            color: const Color.fromARGB(132, 158, 158, 158)),
                        child: Icon(Icons.close, color: Colors.black),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.04,
                    )
                  ],
                ),
                //SizedBox(height: size.height * 0.008),
                Text(
                  documentSnapshot['Name'],
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.14,
                      fontFamily: 'Arial'),
                ),
              ],
            ),
          ),
          SizedBox(
            width: size.width * 0.9,
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Horario',
                      style: TextStyle(
                          fontFamily: 'Arial',
                          fontSize: size.width * 0.056,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.004,
                ),
                Text(
                  documentSnapshot['Days'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: Colors.white,
                      fontSize: size.width * 0.05),
                ),
                Text(
                  documentSnapshot['Time'],
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: const Color.fromARGB(255, 204, 204, 204),
                      fontSize: size.width * 0.045),
                ),
                SizedBox(
                  height: size.height * 0.006,
                ),
                documentSnapshot['Days 2'] != '' &&
                        documentSnapshot['Time 2'] != ''
                    ? Column(
                        children: [
                          Text(
                            documentSnapshot['Days 2'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: 'Arial',
                                color: Colors.white,
                                fontSize: size.width * 0.05),
                          ),
                          Text(
                            documentSnapshot['Time 2'],
                            style: TextStyle(
                                fontFamily: 'Arial',
                                color: const Color.fromARGB(255, 204, 204, 204),
                                fontSize: size.width * 0.045),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: size.height * 0.006,
                      ),
                SizedBox(
                  height: size.height * 0.004,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Descripción',
                      style: TextStyle(
                          fontSize: size.width * 0.055,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.006,
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: size.height * 0.26),
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        color: const Color.fromARGB(143, 255, 255, 255)),
                    child: SingleChildScrollView(
                      reverse: false,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Text(
                            documentSnapshot['Descripcion'],
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: 'Arial',
                              color: const Color.fromARGB(255, 0, 0, 0),
                              fontSize: size.width * 0.04,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                SizedBox(
                  height: size.height * 0.055,
                  width: size.width * 0.9,
                  child: ElevatedButton(
                    onPressed: _launchUrlclass,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 211, 146, 6),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(size.width * 0.035))),
                    child: Text(
                      'Enviar Solicitud',
                      style: TextStyle(
                          fontSize: size.width * 0.045,
                          color: const Color.fromARGB(255, 255, 255, 255),
                          fontFamily: 'Arial'),
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
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
