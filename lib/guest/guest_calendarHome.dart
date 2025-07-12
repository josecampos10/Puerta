import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GuestcalendarHome extends StatefulWidget {
  const GuestcalendarHome({super.key});
  @override
  State<GuestcalendarHome> createState() => _GuestcalendarHomeState();
}

class _GuestcalendarHomeState extends State<GuestcalendarHome> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  String selectedClient = "";
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection('lapuertausers');
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          bottomOpacity: 0.0,
          toolbarHeight: size.height * 0.1,
          leadingWidth: size.height * 0.113,
          leading: CircleAvatar(
            backgroundColor: const Color.fromARGB(0, 240, 195, 195),
            child: Image.asset(
              'assets/img/logo.png',
              color: Colors.white,
              fit: BoxFit.scaleDown,
              scale: size.height * 0.008,
            ),
          ),
          title: Container(
              padding: EdgeInsets.only(top: size.height*0.03),
              child: Text(
                'Mensajes',
              )),
          centerTitle: true,
          titleTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.height * 0.023,
              color: Colors.white),
          backgroundColor: Color.fromRGBO(4, 99, 128, 1),
        ),
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.0,
                    ),

                    /*ElevatedButton(
                      onPressed: () => NotiService.showNotification(
                          tittle: "Tittle", body: "Celular", payload: 'Samira'),
                      child: const Text('Send Notification'),
                    ),*/

                    Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          //offset: Offset(5, 5),
                          color: const Color.fromARGB(255, 255, 255, 255),
                          //blurRadius: 0.0,
                          //blurStyle: BlurStyle.inner
                        )
                      ]),
                      alignment: Alignment.topCenter,
                      height: size.height * 0.766,
                      width: size.width,
                      child: Text('')

                      /*StreamBuilder<QuerySnapshot>(
                        stream: users.snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              'Cargando',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            );
                          }

                          return ListView(
                            //physics: NeverScrollableScrollPhysics(),
                            clipBehavior: Clip.hardEdge,
                            padding: EdgeInsets.only(top: 0, bottom: 0),
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                                  //Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                              return Card(
                                borderOnForeground: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0)),
                                elevation: 0,
                                shadowColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                color: Color.fromRGBO(255, 255, 255, 1),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: size.height * 0.0,
                                      bottom: size.height * 0.0,
                                      left: 5,
                                      right: 5),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                        //top: BorderSide(color: const Color.fromARGB(255, 167, 167, 167)),
                                        bottom: BorderSide(color: const Color.fromARGB(255, 216, 216, 216))
                                      )
                                    ),
                                    height: size.height * 0.073,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: ListTile(
                                        
                                        leading: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CircleAvatar(
                                              foregroundImage: AssetImage(
                                                  'assets/img/logo2.png'),
                                              //backgroundImage: AssetImage('assets/icon/logo2.png'),
                                              backgroundColor:
                                                  Colors.yellow.shade800,
                                              radius: size.height * 0.0311,
                                            ),
                                          ],
                                        ),
                                        onTap: () =>
                                        Navigator.pushNamed(context, '/chatpage'),
                                        //leading: Icon(Icons.notifications_rounded),
                                        contentPadding: EdgeInsets.only(
                                            bottom: size.height * 0.0000,
                                            right: 5,
                                            left: 5,
                                            top: 0),
                                        iconColor: const Color.fromARGB(
                                            255, 221, 125, 0),
                                        titleAlignment:
                                            ListTileTitleAlignment.center,
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              textAlign: TextAlign.start,
                                              document['Name'],
                                              style: TextStyle(
                                                  fontSize: size.height * 0.025,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ), */
                    ),
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
