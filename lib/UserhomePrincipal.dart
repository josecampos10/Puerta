import 'dart:typed_data';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lapuerta2/detalles_image.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:lapuerta2/detalles_image_slider.dart';
import 'package:lapuerta2/theme.dart';
import 'package:url_launcher/url_launcher.dart';

final gridItems = [
  'Noticias',
  'Clases',
  'Servicios',
];

class UserhomePrincipal extends StatefulWidget {
  @override
  State<UserhomePrincipal> createState() => _UserhomePrincipalState();

  const UserhomePrincipal({Key? key}) : super(key: key);
}

class _UserhomePrincipalState extends State<UserhomePrincipal> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late Stream<QuerySnapshot> imageStream;
  late Stream<QuerySnapshot> imageESLstream;
  late Stream<QuerySnapshot> imageRecursoStream;
  late Stream<QuerySnapshot> feedStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> imagenes;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> usuario;
  int currentSlideIndex = 0;
  CarouselSliderController carouselController = CarouselSliderController();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;
  bool _showFab = true;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  Uint8List? pickedImage;
  final Uri _urlfacebook = Uri.parse('https://www.facebook.com/puertawaco');
  int selectedIndex = 0;

  Future<void> _launchUrlfacebook() async {
    if (!await launchUrl(_urlfacebook)) {
      throw Exception('Could not launch $_urlfacebook');
    }
  }

  final Uri _urlinstagram =
      Uri.parse('https://www.instagram.com/lapuertawaco/');

  Future<void> _launchUrlinstagram() async {
    if (!await launchUrl(_urlinstagram)) {
      throw Exception('Could not launch $_urlinstagram');
    }
  }

  final Uri _urlx = Uri.parse('https://twitter.com/lapuertawaco');

  Future<void> _launchUrlx() async {
    if (!await launchUrl(_urlx)) {
      throw Exception('Could not launch $_urlx');
    }
  }

  Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri _phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      if (await canLaunch(_phoneUri.toString()))
        await launch(_phoneUri.toString());
    } catch (error) {
      throw ("Cannot dial");
    }
  }

  Future<void> send(emailAddress) async {
    final Email email = Email(
      body: _bodyController.text,
      subject: _subjectController.text,
      recipients: ['ppjjosejair@gmail.com'],
      //attachmentPaths: attachments,
      isHTML: false,
    );

    // ignore: unused_local_variable
    String platformResponse;

    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }

    if (!mounted) return;

    /*ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );*/
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      imageCache.clear();
      imageCache.clearLiveImages();
    });

    getProfilePicture();
    pickedImage;
    var firebase = FirebaseFirestore.instance;
    imageStream = firebase.collection("Image_Slider").snapshots();
    imageESLstream = firebase.collection("Image_Slider_ESL").snapshots();
    imageRecursoStream =
        firebase.collection("Image_Slider_Recurso").snapshots();
    var feed = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
    feedStream = feed;
    imagenes = FirebaseFirestore.instance
        .collection('users')
        .doc(currentUsera.email) // 👈 Your document id change accordingly
        .snapshots();
    usuario = FirebaseFirestore.instance
        .collection('posts')
        .doc() // 👈 Your document id change accordingly
        .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
    setState(() {
      imageCache.clear();
      imageCache.clearLiveImages();
    });
    getProfilePicture();
    var firebase = FirebaseFirestore.instance;
    imageStream = firebase.collection("Image_Slider").snapshots();
    var feed = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('Time', descending: true)
        .snapshots();
    feedStream = feed;

    /*FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.email)
          .update({'token': FirebaseMessaging.instance.getToken()});*/
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      floatingActionButton: AnimatedSlide(
        duration: Duration(milliseconds: 300),
        offset: _showFab ? Offset.zero : Offset(0, 2),
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 300),
          opacity: _showFab ? 1 : 0,
          child: FloatingActionButton(
            backgroundColor: const Color.fromARGB(255, 96, 146, 255),
            shape: CircleBorder(),
            child: Icon(
              Icons.email_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  builder: (context) => Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        width: size.width,
                        child: Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: size.height * 0.005,
                            ),
                            Center(
                              child: Container(
                                width: size.width * 0.2,
                                height: size.height * 0.01,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color.fromARGB(
                                        255, 195, 195, 195)),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.009,
                            ),
                            Center(
                              child: Text(
                                'Contáctanos',
                                style: TextStyle(
                                    fontSize: size.height * 0.035,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Coolvetica'),
                              ),
                            ),
                            Center(
                              child: Container(
                                //color: Theme.of(context).colorScheme.primary,
                                width: size.width * 0.9,
                                height: size.height * 0.06,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 110, 110, 110),
                                            width: 1),
                                        bottom: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 110, 110, 110),
                                            width: 1),
                                        left: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 110, 110, 110),
                                            width: 1),
                                        right: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 110, 110, 110),
                                            width: 1)),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                  style: TextStyle(
                                    fontSize: size.height * 0.022,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  cursorHeight: size.height * 0.023,
                                  controller: _subjectController,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    labelText: 'Asunto',
                                    prefixIcon: Icon(Icons.short_text_rounded,
                                        color: const Color.fromARGB(
                                            255, 155, 155, 155)),
                                    labelStyle: TextStyle(
                                        fontSize: size.height * 0.02,
                                        fontFamily: 'Coolvetica',
                                        color: const Color.fromARGB(
                                            255, 155, 155, 155)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Center(
                              child: Container(
                                width: size.width * 0.9,
                                height: size.height * 0.2,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0),
                                decoration: BoxDecoration(
                                    border: Border(
                                        top: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 110, 110, 110),
                                            width: 1),
                                        bottom: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 110, 110, 110),
                                            width: 1),
                                        left: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 110, 110, 110),
                                            width: 1),
                                        right: BorderSide(
                                            color: const Color.fromARGB(
                                                255, 110, 110, 110),
                                            width: 1)),
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(10)),
                                child: TextField(
                                  autofocus: false,
                                  minLines: 1,
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  textInputAction: TextInputAction.newline,
                                  style: TextStyle(
                                    fontSize: size.height * 0.022,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  cursorHeight: size.height * 0.023,
                                  controller: _bodyController,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.transparent)),
                                    labelText: 'Mensaje',
                                    prefixIcon: Icon(Icons.message,
                                        color: const Color.fromARGB(
                                            255, 155, 155, 155)),
                                    labelStyle: TextStyle(
                                        fontSize: size.height * 0.02,
                                        fontFamily: 'Coolvetica',
                                        color: const Color.fromARGB(
                                            255, 155, 155, 155)),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Container(
                              width: size.width * 0.9,
                              height: size.height * 0.07,
                              child: ElevatedButton(
                                  onPressed: () {
                                    send(currentUser!.email);
                                    Navigator.pop(context);
                                    _bodyController.clear();
                                    _subjectController.clear();
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromARGB(
                                          255, 96, 146, 255),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                    child: Text(
                                      'Enviar',
                                      style: TextStyle(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          fontSize: size.height * 0.021,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Coolvetica'),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            /*Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '500 Clay Ave',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: size.height * 0.015,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),*/
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.call,
                                  size: size.height * 0.02,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                SizedBox(
                                  width: size.width * 0.008,
                                ),
                                InkWell(
                                  onTap: () {
                                    launchPhoneDialer('2547543503');
                                  },
                                  child: Text('(254) 754-3503',
                                      style: TextStyle(
                                          color: const Color.fromARGB(239, 38, 130, 236),
                                          fontSize: size.height * 0.017,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Coolvetica')),
                                )
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.01,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                    onTap: () => _launchUrlfacebook(),
                                    child: Icon(FontAwesomeIcons.facebook)),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                GestureDetector(
                                    onTap: () => _launchUrlinstagram(),
                                    child: Icon(FontAwesomeIcons.instagram)),
                                SizedBox(
                                  width: size.width * 0.02,
                                ),
                                GestureDetector(
                                    onTap: () => _launchUrlx(),
                                    child: Icon(FontAwesomeIcons.twitter))
                              ],
                            ),
                            SizedBox(
                              height: size.height * 0.02,
                            )
                          ],
                        ),
                      )),
                  context: context);
            },
          ),
        ),
      ),
      appBar: AppBar(
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.0,
        leading: Text(''),
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.03),
            child: Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hola,',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.018),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: imagenes,
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Column(children: [
                                SpinKitFadingCircle(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                  size: size.width * 0.055,
                                ),
                              ]);
                            }
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            return (data['name']) != null
                                ? Text(
                                    data['name'],
                                    style: TextStyle(
                                        fontSize: size.height * 0.027,
                                        fontFamily: 'Coolvetica',
                                        //fontWeight: FontWeight.bold,
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255)),
                                  )
                                : Text(''); // 👈 your valid data here
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
        centerTitle: false,
        //titleTextStyle: ,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/img/puntos.png'),
                fit: BoxFit.fill,
                colorFilter: (Theme.of(context).colorScheme.tertiary !=
                        Color.fromRGBO(4, 99, 128, 1))
                    ? ColorFilter.mode(
                        const Color.fromARGB(255, 68, 68, 68), BlendMode.color)
                    : ColorFilter.mode(
                        const Color.fromARGB(0, 255, 29, 29), BlendMode.color),
                alignment: Alignment.topCenter,
                scale: 27.0),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height * 0.065,
                width: size.height * 0.065,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  border: Border.all(
                    color: Color.fromRGBO(255, 255, 255, 0.174),
                    width: size.height * 0.003,
                  ),
                  shape: BoxShape.circle,
                  image: pickedImage != null
                      ? 
                      DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.memory(
                            pickedImage!,
                            key: UniqueKey(),
                          ).image)
                      : null),
              ),
              SizedBox(
                width: size.width * 0.03,
              )
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),

        height: size.height,
        width: size.width,
        //color: Color.fromRGBO(255, 255, 255, 1),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          primary: false,
          reverse: false,
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.008,
              ),
              Center(
                child: Container(
                  width: size.width * 0.92,
                  height: size.height * 0.04,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 2),
                          blurRadius: 12,
                          color: Color.fromRGBO(0, 0, 0, 0),
                        )
                      ],
                      shape: BoxShape.rectangle,
                      color: const Color.fromARGB(0, 255, 255, 255),
                      border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 0.5)),
                      borderRadius: BorderRadius.circular(size.width * 0.0)),

                  //color: Colors.red,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(size.width * 0.001),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          height: size.height * 0.04,
                          child: GridView.builder(
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    childAspectRatio: size.width * 0.0008),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: gridItems.length,
                            cacheExtent: 1000.0,
                            itemBuilder: (BuildContext context, int position) {
                              return AnimationConfiguration.staggeredGrid(
                                position: 1,
                                columnCount: 1,
                                child: ScaleAnimation(
                                  duration: Duration(milliseconds: 400),
                                  child: FadeInAnimation(
                                    child: InkWell(
                                      onTap: () => setState(
                                          () => selectedIndex = position),
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                size.width * 0.03)),
                                        elevation: size.height * 0.9,
                                        //shadowColor: Colors.black26,
                                        color: (selectedIndex == position)
                                            ? Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                            : Color.fromRGBO(238, 135, 1, 0),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.all(size.width * 0.0),
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
                                                      width: size.width * 0.0,
                                                    ),
                                                    Text(
                                                      gridItems[position],
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize:
                                                            size.height * 0.017,
                                                        fontFamily:
                                                            'Coolvetica',
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: (selectedIndex ==
                                                                position)
                                                            ? Color.fromARGB(
                                                                255,
                                                                255,
                                                                255,
                                                                255)
                                                            : Color.fromRGBO(
                                                                143,
                                                                143,
                                                                143,
                                                                1),
                                                      ),
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
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              SingleChildScrollView(
                reverse: true,
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    //color: const Color.fromARGB(0, 0, 0, 0),
                  ),
                  height: size.height * 0.14,
                  width: double.infinity,
                  child: Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                        stream: imageStream,
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(children: [
                              SizedBox(
                                height: size.height * 0.01,
                              ),
                              SpinKitFadingCircle(
                                color: Color.fromRGBO(4, 99, 128, 1),
                                size: size.width * 0.1,
                              ),
                            ]);
                          }
                          if (snapshot.hasData &&
                              snapshot.data!.docs.length > 1 &&
                              selectedIndex == 0) {
                            return CarouselSlider.builder(
                                carouselController: carouselController,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (_, index, __) {
                                  DocumentSnapshot sliderImage =
                                      snapshot.data!.docs[index];
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageDetallesHomeSlider(
                                                        sliderImage:
                                                            sliderImage)));
                                      },
                                      child: Hero(
                                        tag: sliderImage,
                                        child: Container(
                                          width: size.width * 0.85,
                                          // height: size.height * 0.2,
                                          child: Image.network(
                                            sliderImage['Image'],
                                            filterQuality: FilterQuality.low,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                    aspectRatio: size.height * 0.0045,
                                    viewportFraction: size.height * 0.00045,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    autoPlayInterval: Duration(seconds: 10),
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    onPageChanged: (index, _) {
                                      setState(() {
                                        currentSlideIndex = index;
                                      });
                                    }));
                          } else {
                            return Container();
                          }
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: imageESLstream,
                        builder: (_, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.length > 1 &&
                              selectedIndex == 1) {
                            return CarouselSlider.builder(
                                carouselController: carouselController,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (_, index, __) {
                                  DocumentSnapshot sliderImage =
                                      snapshot.data!.docs[index];
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageDetallesHomeSlider(
                                                        sliderImage:
                                                            sliderImage)));
                                      },
                                      child: Hero(
                                        tag: sliderImage,
                                        child: Container(
                                          width: size.width * 0.8,
                                          child: Image.network(
                                            sliderImage['Image'],
                                            filterQuality: FilterQuality.low,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                    aspectRatio: size.height * 0.0045,
                                    viewportFraction: size.height * 0.00045,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    autoPlayInterval: Duration(seconds: 10),
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    onPageChanged: (index, _) {
                                      setState(() {
                                        currentSlideIndex = index;
                                      });
                                    }));
                          } else {
                            return Container();
                          }
                        },
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: imageRecursoStream,
                        builder: (_, snapshot) {
                          if (snapshot.hasData &&
                              snapshot.data!.docs.length > 1 &&
                              selectedIndex == 2) {
                            return CarouselSlider.builder(
                                carouselController: carouselController,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (_, index, __) {
                                  DocumentSnapshot sliderImage =
                                      snapshot.data!.docs[index];
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ImageDetallesHomeSlider(
                                                        sliderImage:
                                                            sliderImage)));
                                      },
                                      child: Hero(
                                        tag: sliderImage,
                                        child: Container(
                                          width: size.width * 0.8,
                                          child: Image.network(
                                            sliderImage['Image'],
                                            filterQuality: FilterQuality.low,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                options: CarouselOptions(
                                    aspectRatio: size.height * 0.0045,
                                    viewportFraction: size.height * 0.00045,
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    autoPlayInterval: Duration(seconds: 10),
                                    autoPlay: true,
                                    enlargeCenterPage: true,
                                    onPageChanged: (index, _) {
                                      setState(() {
                                        currentSlideIndex = index;
                                      });
                                    }));
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SingleChildScrollView(
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: feedStream,
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
                              onRefresh: () async {
                                setState(() {});
                              },
                              child: SizedBox(
                                height: size.height * 0.591,
                                width: size.width,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: NotificationListener<
                                      UserScrollNotification>(
                                    onNotification: (notification) {
                                      final ScrollDirection direction =
                                          notification.direction;
                                      setState(() {
                                        if (direction ==
                                            ScrollDirection.reverse) {
                                          _showFab = false;
                                        } else if (direction ==
                                            ScrollDirection.forward) {
                                          _showFab = true;
                                        }
                                      });
                                      return true;
                                    },
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
                                        DocumentSnapshot documentSnapshot =
                                            snapshot.data!.docs[index];

                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          child: ScaleAnimation(
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: FadeInAnimation(
                                              child: GestureDetector(
                                                onTap: () {},
                                                child: Card(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              size.width *
                                                                  0.0)),
                                                  elevation: size.height * 0.0,
                                                  shadowColor: Colors.black,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        border: Border(
                                                            top: BorderSide(
                                                                color: const Color
                                                                    .fromARGB(
                                                                    87,
                                                                    128,
                                                                    127,
                                                                    127),
                                                                width: 1)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    size.width *
                                                                        0.0)),
                                                    //constraints: const BoxConstraints(minHeight: ),
                                                    //width: 180,
                                                    //height: 20,
                                                    child: Padding(
                                                      padding: EdgeInsets.all(
                                                          size.width * 0.02),
                                                      child: Column(
                                                        children: [
                                                          Row(children: [
                                                            CircleAvatar(
                                                              backgroundImage:
                                                                  NetworkImage(snap[
                                                                          index]
                                                                      [
                                                                      'Image']),
                                                              minRadius:
                                                                  size.height *
                                                                      0.023,
                                                              maxRadius:
                                                                  size.height *
                                                                      0.023,
                                                              backgroundColor:
                                                                  const Color
                                                                      .fromARGB(
                                                                      36,
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
                                                                    ['User'],
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        size.height *
                                                                            0.019,
                                                                    fontFamily:
                                                                        'Coolvetica',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .secondary),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.02,
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Text(
                                                                snap[index]
                                                                    ['Time'],
                                                                style: TextStyle(
                                                                    fontSize: size
                                                                            .height *
                                                                        0.0125,
                                                                    fontFamily:
                                                                        '',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: const Color
                                                                        .fromARGB(
                                                                        255,
                                                                        160,
                                                                        160,
                                                                        160)),
                                                              ),
                                                            ),
                                                          ]),
                                                          Row(
                                                            children: [
                                                              SizedBox(
                                                                width:
                                                                    size.width *
                                                                        0.121,
                                                              ),
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Text(
                                                                  snap[index]
                                                                      ['Date'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          size.height *
                                                                              0.011,
                                                                      fontFamily:
                                                                          '',
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: const Color
                                                                          .fromARGB(
                                                                          255,
                                                                          160,
                                                                          160,
                                                                          160)),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.003,
                                                          ),
                                                          Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Linkify(
                                                              linkStyle: TextStyle(
                                                                  decoration:
                                                                      TextDecoration
                                                                          .none,
                                                                  fontSize: size
                                                                          .height *
                                                                      0.0162,
                                                                  fontFamily:
                                                                      'Impact',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color: const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      94,
                                                                      145,
                                                                      255)),
                                                              style: TextStyle(
                                                                  fontSize: size
                                                                          .height *
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
                                                              onOpen:
                                                                  (link) async {
                                                                if (!await launchUrl(
                                                                    Uri.parse(link
                                                                        .url))) {
                                                                  throw Exception(
                                                                      'Could not launch ${link.url}');
                                                                }
                                                              },
                                                            )),
                                                          SizedBox(
                                                            height:
                                                                size.height *
                                                                    0.01,
                                                          ),
                                                          snap[index]['postUrl'] !=
                                                                  'no imagen'
                                                              ? GestureDetector(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ImageDetallesHome(documentSnapshot: documentSnapshot)));
                                                                  },
                                                                  child: Hero(
                                                                    tag:
                                                                        documentSnapshot,
                                                                    child:
                                                                        Container(
                                                                      height: size
                                                                              .height *
                                                                          0.35,
                                                                      width: size
                                                                          .height,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: const Color
                                                                            .fromARGB(
                                                                            0,
                                                                            158,
                                                                            158,
                                                                            158),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        border:
                                                                            Border.all(
                                                                          color: Color.fromRGBO(
                                                                              4,
                                                                              99,
                                                                              128,
                                                                              0),
                                                                          width:
                                                                              size.height * 0.0,
                                                                        ),
                                                                        //shape: BoxShape.circle,
                                                                        image: DecorationImage(
                                                                            fit: BoxFit.cover,
                                                                            image: Image.network(
                                                                              snap[index]['postUrl']!,
                                                                            ).image),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                )
                                                              : Container(
                                                                  height:
                                                                      size.height *
                                                                          0.0,
                                                                  width: size
                                                                      .height,
                                                                )
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

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUser!.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      print('Profile Picture could not be found');
    }
  }
}
