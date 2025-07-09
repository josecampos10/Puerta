import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageDetallesHomeSlider extends StatelessWidget {
  final DocumentSnapshot sliderImage;
  const ImageDetallesHomeSlider({Key? key, required this.sliderImage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 0, 1).withOpacity(0.8),
      body: Container(
        height: size.height,
        width: size.width,
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/foto4.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2), BlendMode.dstATop),
          ),
        ),*/
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              width: size.width,
              height: size.height * 0.2,
              
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
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  
                  Hero(
                    tag: sliderImage,
                    child: PinchZoom(
                      maxScale: 25,
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: size.height*0.65,
                          minHeight: size.height*0.5
                        ),
                        //height: size.height * 0.35,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(0, 158, 158, 158),
                          border: Border.all(
                            color: Color.fromRGBO(4, 99, 128, 0),
                            width: size.height * 0.0,
                          ),
                          //shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fitWidth,
                              image: Image.network(
                                sliderImage['Image']!,
                              ).image),
                        ),
                      ),
                    ),
                  ),
                  
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
  final Uri _url = Uri.parse(
      "https://www.lapuertawaco.com/educacion"); // Replace with your YouTube video URL

  if (!await launchUrl(_url)) {
    throw Exception("Could not launch $_url");
  }
}
