import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lapuerta2/main.dart';

class AdminDetallesHome extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const AdminDetallesHome({super.key, required this.documentSnapshot});

  @override
  State<AdminDetallesHome> createState() => _AdminDetallesHomeState();
}

class _AdminDetallesHomeState extends State<AdminDetallesHome> {
  bool statuseslpm = false;
  bool statuseslpm2 = false;
  bool statuseslam = false;
  bool statuseslam2 = false;
  bool statusgedpm = false;
   bool statusgedpm2 = false;
  bool statusgedam = false;
  bool statusgedam2 = false;
  bool statusciudadania = false;
  bool statuscosmetologia = false;
  bool statuscostura = false;
  bool statuscorte = false;
  bool statuscorte2 = false;
  bool statuschick = false;
  bool statusvolunteer = false;
  bool statusclifton = false;
  bool statusfeed = false;

  @override
  void initState() {
    super.initState();
    ////////////ESL P,
    if (widget.documentSnapshot['ESLpm'] == '') {
      statuseslpm = false;
    } else {
      statuseslpm = true;
    }
    ////////////ESL PM 2,
    if (widget.documentSnapshot['ESLpm2'] == '') {
      statuseslpm2 = false;
    } else {
      statuseslpm2 = true;
    }
    /////////////////ESL AM
    if (widget.documentSnapshot['ESLam'] == '') {
      statuseslam = false;
    } else {
      statuseslam = true;
    }
    /////////////////ESL AM 2
    if (widget.documentSnapshot['ESLam2'] == '') {
      statuseslam2 = false;
    } else {
      statuseslam2 = true;
    }
    ///////////////GED PM
    if (widget.documentSnapshot['GEDpm'] == '') {
      statusgedpm = false;
    } else {
      statusgedpm = true;
    }
    ///////////////GED PM 2
    if (widget.documentSnapshot['GEDpm2'] == '') {
      statusgedpm2 = false;
    } else {
      statusgedpm2 = true;
    }
    ///////////////GED AM
    if (widget.documentSnapshot['GEDam'] == '') {
      statusgedam = false;
    } else {
      statusgedam = true;
    }
    ///////////////GED AM 2
    if (widget.documentSnapshot['GEDam2'] == '') {
      statusgedam2 = false;
    } else {
      statusgedam2 = true;
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
    ///////////////Chickfila
    if (widget.documentSnapshot['ESLchick'] == '') {
      statuschick = false;
    } else {
      statuschick = true;
    }
     ///////////////Corte 1
    if (widget.documentSnapshot['Corte1'] == '') {
      statuscorte = false;
    } else {
      statuscorte = true;
    }
     ///////////////Corte 2
    if (widget.documentSnapshot['Corte2'] == '') {
      statuscorte2 = false;
    } else {
      statuscorte2 = true;
    }
     ///////////////Volunteer
    if (widget.documentSnapshot['Volunteer'] == '') {
      statusvolunteer = false;
    } else {
      statusvolunteer = true;
    }
     ///////////////ESL Clifton
    if (widget.documentSnapshot['ESLclifton'] == '') {
      statusclifton = false;
    } else {
      statusclifton = true;
    }
     ///////////////FEED / DONANTES
    if (widget.documentSnapshot['feed'] == '') {
      statusfeed = false;
    } else {
      statusfeed = true;
    }
  }

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
                    'Gestión de usuarios',
                    style: TextStyle(
                        fontSize: size.height * 0.025,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
        toolbarHeight: size.height*0.09,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SizedBox(
        height: size.height,
        width: size.width,
        
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: size.height*0.06,
            ),
            Container(
              width: size.width*0.8,
              height: size.height * 0.75,
              decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 183, 95, 19).withAlpha(200),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                children: [
                  Container(
                    height: size.height*0.05,
                    width: size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Theme.of(context).colorScheme.tertiary),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                            child: Text(
                          'La Puerta Waco',
                          style: TextStyle(
                              fontSize: size.height * 0.018,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              fontFamily: 'Arial'),
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
                                  //width: size.width * 0.92,
                                  color: const Color.fromARGB(0, 76, 175, 79),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(
                                          widget.documentSnapshot['name'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: size.height * 0.028,
                                              fontFamily: 'Arial'),
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
                                            fontWeight: FontWeight.bold,
                                              color: Colors.white60,
                                              fontSize: size.height * 0.017,
                                              fontFamily: 'Arial'),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  )),
                                  // pasa el email del doc en 'users/{email}'
                              SizedBox(height: size.height*0.01,),
                              Container(
                                //height: size.height*0.02,
                                  width: size.width * 0.2,
                                  color: const Color.fromARGB(0, 76, 175, 79),
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        RoleSelector(userEmail: widget.documentSnapshot['email']), 
                                        /*Text(
                                          widget.documentSnapshot['rol'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                              color: Colors.white60,
                                              fontSize: size.height * 0.017,
                                              fontFamily: 'Arial'),
                                          textAlign: TextAlign.center,
                                        ),*/
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
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              height: size.height * 0.01,
                              width: size.width,
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  
                                ],
                              )),
                        ],
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          
                          Column(
                            children: [
                              SizedBox(height: size.height*0.02,),
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
                                height: size.height * 0.03,
                              ),
                              Text('ESL PM 2',
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
                                      value: statuseslpm2,
                                      onChanged: (value) {
                                        setState(() {
                                          statuseslpm2 = value;
                                        });
                                        if (statuseslpm2 == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLpm2': 'inscrito'});
                                        }
                                        if (statuseslpm2 == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLpm2': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Text('GED Pm - A',
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
                                height: size.height * 0.03,
                              ),
                              Text('GED Am - A',
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
                                height: size.height * 0.03,
                              ),
                              Text('ESL Clifton',
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
                                      value: statusclifton,
                                      onChanged: (value) {
                                        setState(() {
                                          statusclifton = value;
                                        });
                                        if (statusclifton == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLclifton': 'inscrito'});
                                        }
                                        if (statusclifton == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLclifton': ''});
                                        }
                                      }),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: size.height*0.02,),
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
                                height: size.height * 0.03,
                              ),
                              Text('Corte y Confección 1',
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
                                      value: statuscorte,
                                      onChanged: (value) {
                                        setState(() {
                                          statuscorte = value;
                                        });
                                        if (statuscorte == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'Corte1': 'inscrito'});
                                        }
                                        if (statuscorte == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'Corte1': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Text('Voluntarios',
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
                                      value: statusvolunteer,
                                      onChanged: (value) {
                                        setState(() {
                                          statusvolunteer = value;
                                        });
                                        if (statusvolunteer == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'Volunteer': 'inscrito'});
                                        }
                                        if (statusvolunteer == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'Volunteer': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
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
                                height: size.height * 0.03,
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
                            ],
                          ),
                          
                          Column(
                            children: [
                              SizedBox(height: size.height*0.02,),
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
                                height: size.height * 0.03,
                              ),
                              Text('ESL AM 2',
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
                                      value: statuseslam2,
                                      onChanged: (value) {
                                        setState(() {
                                          statuseslam2 = value;
                                        });
                                        if (statuseslam2 == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLam2': 'inscrito'});
                                        }
                                        if (statuseslam2 == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLam2': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Text('ESL Chick-fil-A',
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
                                      value: statuschick,
                                      onChanged: (value) {
                                        setState(() {
                                          statuschick = value;
                                        });
                                        if (statuschick == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLchick': 'inscrito'});
                                        }
                                        if (statuschick == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'ESLchick': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Text('Corte y Confección 2',
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
                                      value: statuscorte2,
                                      onChanged: (value) {
                                        setState(() {
                                          statuscorte2 = value;
                                        });
                                        if (statuscorte2 == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'Corte2': 'inscrito'});
                                        }
                                        if (statuscorte2 == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'Corte2': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Text('Publicar en La Puerta/ Donantes',
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
                                      value: statusfeed,
                                      onChanged: (value) {
                                        setState(() {
                                          statusfeed = value;
                                        });
                                        if (statusfeed == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'feed': 'inscrito'});
                                        }
                                        if (statusfeed == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'feed': ''});
                                        }
                                      }),
                                ),
                              ),
                              
                            ],
                          ),
                          Column(
                            children: [
                              SizedBox(height: size.height*0.02,),
                              Text('GED Am - B',
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
                                      value: statusgedam2,
                                      onChanged: (value) {
                                        setState(() {
                                          statusgedam2 = value;
                                        });
                                        if (statusgedam2 == true) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'GEDam2': 'inscrito'});
                                        }
                                        if (statusgedam2 == false) {
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(widget
                                                  .documentSnapshot['email'])
                                              .update({'GEDam2': ''});
                                        }
                                      }),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              
                              
                          Text('GED Pm - B',
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
                                  value: statusgedpm2,
                                  onChanged: (value) {
                                    setState(() {
                                      statusgedpm2 = value;
                                    });
                                    if (statusgedpm2 == true) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget
                                              .documentSnapshot['email'])
                                          .update({'GEDpm2': 'inscrito'});
                                    }
                                    if (statusgedpm2 == false) {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(widget
                                              .documentSnapshot['email'])
                                          .update({'GEDpm2': ''});
                                    }
                                  }),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.03,
                          )
                            ],
                          ),
                          
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

class RoleSelector extends StatefulWidget {
  final String userEmail; // users/{email}
  const RoleSelector({super.key, required this.userEmail});

  @override
  State<RoleSelector> createState() => _RoleSelectorState();
}

class _RoleSelectorState extends State<RoleSelector> {
  static const List<String> roles = [
    'Estudiante',
    'Profesor',
    'Staff',
    'Voluntario',
    'Donante',
  ];

  bool _saving = false;

  Future<void> _saveRole(String newRole) async {
    try {
      setState(() => _saving = true);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userEmail)
          .set({'rol': newRole}, SetOptions(merge: true));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Rol actualizado a $newRole')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userEmail)
          .snapshots(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }
        if (!snap.hasData || !snap.data!.exists) {
          return const Text('Usuario no encontrado');
        }

        final data = snap.data!.data() ?? {};
        final currentRole = data['rol'] as String?;
        final value = roles.contains(currentRole) ? currentRole : null;

        return Container(
          height: size.height*0.06,
          width: size.width*0.3,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(12)
          ),
          child: InputDecorator(
            
            decoration: InputDecoration(
              
              labelText: 'Rol',
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.white), // borde blanco por defecto
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.white, width: 1.5), // borde blanco habilitado
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.white, width: 2), // borde blanco al enfocar
  ),
              suffixIcon: _saving
                  ? Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: size.width*0.1,
                        height: size.height*0.04,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                iconEnabledColor: Colors.white,
                iconSize: size.height*0.03,
                dropdownColor: Theme.of(context).colorScheme.tertiary,
                value: value,
                hint: const Text('Selecciona un rol'),
                isExpanded: true,
                items: roles
                    .map((r) => DropdownMenuItem(value: r, child: Center(child: Text(r, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: size.height*0.017),))))
                    .toList(),
                onChanged: _saving
                    ? null
                    : (newVal) {
                        if (newVal == null) return;
                        _saveRole(newVal);
                      },
              ),
            ),
          ),
        );
      },
    );
  }
}

