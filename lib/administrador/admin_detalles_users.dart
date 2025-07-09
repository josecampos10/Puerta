import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lapuerta2/main.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AdminDetallesHome extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const AdminDetallesHome({Key? key, required this.documentSnapshot})
      : super(key: key);

  @override
  State<AdminDetallesHome> createState() => _AdminDetallesHomeState();
}

class _AdminDetallesHomeState extends State<AdminDetallesHome> {
  bool statuseslpm = false;
  bool statuseslam = false;
  bool statusgedpm = false;
  bool statusgedam = false;
  bool statusciudadania = false;
  bool statuscosmetologia = false;
   bool statuscostura = false;

  @override
  void initState() {
    super.initState();
    ////////////ESL P,
    if (widget.documentSnapshot['ESLpm'] == '') {
      statuseslpm = false;
    } else {
      statuseslpm = true;
    }
    /////////////////ESL AM
    if (widget.documentSnapshot['ESLam'] == '') {
      statuseslam = false;
    } else {
      statuseslam = true;
    }
    ///////////////GED PM
    if (widget.documentSnapshot['GEDpm'] == '') {
      statusgedpm = false;
    } else {
      statusgedpm = true;
    }
    ///////////////GED AM
    if (widget.documentSnapshot['GEDam'] == '') {
      statusgedam = false;
    } else {
      statusgedam = true;
    }
    ///////////////Ciudadnia
    if (widget.documentSnapshot['ciudadania'] == '') {
      statusciudadania = false;
    } else {
      statusciudadania = true;
    }
    ///////////////Cosmetologia
    if (widget.documentSnapshot['cosmetologia'] == '') {
      statuscosmetologia = false;
    } else {
      statuscosmetologia = true;
    }
    ///////////////Cosmetologia
    if (widget.documentSnapshot['costuraAM'] == '') {
      statuscostura = false;
    } else {
      statuscostura = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    return Scaffold(
      backgroundColor: Colors.transparent,
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
              width: size.width - 30,
              height: size.height * 0.6,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromRGBO(212, 129, 4, 0.705)),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    width: size.width - 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Color.fromRGBO(4, 99, 128, 1)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          'La Puerta Waco',
                          style: TextStyle(
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.normal,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontFamily: 'Coolvetica'),
                        )),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Container(
                                  width: size.width * 0.92,
                                  color: const Color.fromARGB(0, 76, 175, 79),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.documentSnapshot['name'],
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: size.height * 0.028,
                                              fontFamily: 'Coolvetica'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )),
                              Container(
                                  width: size.width * 0.45,
                                  color: const Color.fromARGB(0, 76, 175, 79),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.documentSnapshot['email'],
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 197, 197, 197),
                                              fontSize: size.height * 0.015,
                                              fontFamily: 'Coolvetica'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )),
                              Container(
                                  width: size.width * 0.45,
                                  color: const Color.fromARGB(0, 76, 175, 79),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.documentSnapshot['rol'],
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 197, 197, 197),
                                              fontSize: size.height * 0.015,
                                              fontFamily: 'Coolvetica'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Container(
                                height: size.height * 0.025,
                                width: size.width - 20,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(4, 99, 128, 1)),
                                child: Text(
                                  'Registro',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.015,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text('ESL PM',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.017,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                width: size.width * 0.2,
                                height: size.height * 0.04,
                                color: const Color.fromARGB(0, 255, 235, 59),
                                child: Transform.scale(
                                  scale: 1.1,
                                  child: CupertinoSwitch(
                                      inactiveTrackColor: Colors.grey,
                                      value: statuseslpm,
                                      onChanged: (value) {
                                        setState(() {
                                          statuseslpm = value;
                                        });
                                        if (statuseslpm == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLpm': 'inscrito'});
                                        }
                                        if (statuseslpm == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLpm': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text('GEDpm',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.017,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                width: size.width * 0.2,
                                height: size.height * 0.04,
                                color: const Color.fromARGB(0, 255, 235, 59),
                                child: Transform.scale(
                                  scale: 1.1,
                                  child: CupertinoSwitch(
                                      inactiveTrackColor: Colors.grey,
                                      value: statusgedpm,
                                      onChanged: (value) {
                                        setState(() {
                                          statusgedpm = value;
                                        });
                                        if (statusgedpm == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'GEDpm': 'inscrito'});
                                        }
                                        if (statusgedpm == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'GEDpm': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text('Ciudadania',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.017,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                width: size.width * 0.2,
                                height: size.height * 0.04,
                                color: const Color.fromARGB(0, 255, 235, 59),
                                child: Transform.scale(
                                  scale: 1.1,
                                  child: CupertinoSwitch(
                                      inactiveTrackColor: Colors.grey,
                                      value: statusciudadania,
                                      onChanged: (value) {
                                        setState(() {
                                          statusciudadania = value;
                                        });
                                        if (statusciudadania == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ciudadania': 'inscrito'});
                                        }
                                        if (statusciudadania == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ciudadania': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text('Costura',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.017,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                width: size.width * 0.2,
                                height: size.height * 0.04,
                                color: const Color.fromARGB(0, 255, 235, 59),
                                child: Transform.scale(
                                  scale: 1.1,
                                  child: CupertinoSwitch(
                                      inactiveTrackColor: Colors.grey,
                                      value: statuscostura,
                                      onChanged: (value) {
                                        setState(() {
                                          statuscostura = value;
                                        });
                                        if (statuscostura == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'costuraAM': 'inscrito'});
                                        }
                                        if (statuscostura == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'costuraAM': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              )
                            ],
                          ),
                          SizedBox(
                            width: size.width * 0.1,
                          ),
                          Column(
                            children: [
                              Text('ESL AM',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.017,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                width: size.width * 0.2,
                                height: size.height * 0.04,
                                color: const Color.fromARGB(0, 255, 235, 59),
                                child: Transform.scale(
                                  scale: 1.1,
                                  child: CupertinoSwitch(
                                      inactiveTrackColor: Colors.grey,
                                      value: statuseslam,
                                      onChanged: (value) {
                                        setState(() {
                                          statuseslam = value;
                                        });
                                        if (statuseslam == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLam': 'inscrito'});
                                        }
                                        if (statuseslam == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLam': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text('GED AM',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.017,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                width: size.width * 0.2,
                                height: size.height * 0.04,
                                color: const Color.fromARGB(0, 255, 235, 59),
                                child: Transform.scale(
                                  scale: 1.1,
                                  child: CupertinoSwitch(
                                      inactiveTrackColor: Colors.grey,
                                      value: statusgedam,
                                      onChanged: (value) {
                                        setState(() {
                                          statusgedam = value;
                                        });
                                        if (statusgedam == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'GEDam': 'inscrito'});
                                        }
                                        if (statusgedam == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'GEDam': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Text('Cosmetología',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.017,
                                      fontWeight: FontWeight.bold)),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                width: size.width * 0.2,
                                height: size.height * 0.04,
                                color: const Color.fromARGB(0, 255, 235, 59),
                                child: Transform.scale(
                                  scale: 1.1,
                                  child: CupertinoSwitch(
                                      inactiveTrackColor: Colors.grey,
                                      value: statuscosmetologia,
                                      onChanged: (value) {
                                        setState(() {
                                          statuscosmetologia = value;
                                        });
                                        if (statuscosmetologia == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'cosmetologia': 'inscrito'});
                                        }
                                        if (statuscosmetologia == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'cosmetologia': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                width: size.width * 0.2,
                                height: size.height * 0.068,
                                color: const Color.fromARGB(0, 255, 235, 59),
                                
                              ),
                              SizedBox(
                                height: size.height * 0.01,
                              )
                            ],
                          )
                        ],
                      )
                    ],
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
