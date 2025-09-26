
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lapuerta2/detalles_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart' as ez;

class Studenteslpm extends StatefulWidget {
  const Studenteslpm({super.key});
  @override
  State<Studenteslpm> createState() => _StudenteslpmState();
}

class _StudenteslpmState extends State<Studenteslpm> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final usuario =
      FirebaseFirestore.instance.collection('users').doc().snapshots();

  CollectionReference users = FirebaseFirestore.instance.collection('postsESL');
  final controller = TextEditingController();
  final streaming = FirebaseFirestore.instance
      .collection('postsESL')
      .orderBy('createdAt', descending: true)
      .snapshots();
  Uint8List? pickedImage;
  final currentUsera = FirebaseAuth.instance.currentUser!;
  late Stream<QuerySnapshot> feedStream;
  late Future<DocumentSnapshot> futureUserDoc;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
    getProfilePicture();
    futureUserDoc =
        FirebaseFirestore.instance.collection('clases').doc('esl 1').get();

    //final streaming;
  }

  @override
  void dispose() {
    super.dispose();
    getProfilePicture();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        iconTheme: CupertinoIconThemeData(
          color: Colors.white,
          size: size.height * 0.035,
        ),
        bottomOpacity: 0.0,
        toolbarHeight: size.height * 0.12,
        leadingWidth: size.width * 0.13,
        //leading:
        title: Container(
            padding: EdgeInsets.only(top: size.height * 0.0),
            child: Text(
              'Mis clases'.tr(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: size.height * 0.024,
                  color: Colors.white,
                  fontFamily: ''),
            )),
        centerTitle: false,
        titleTextStyle: TextStyle(
            fontFamily: '',
            fontWeight: FontWeight.bold,
            fontSize: size.height * 0.023,
            color: const Color.fromARGB(255, 255, 255, 255)),
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
            ),
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
                        ? DecorationImage(
                            fit: BoxFit.cover,
                            image: Image.memory(
                              pickedImage!,
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
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.087),
                topRight: Radius.circular(size.width * 0.087))),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: futureUserDoc,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: size.height * 0.2,
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Theme.of(context).colorScheme.tertiary,
                          size: size.width * 0.055,
                        ),
                      ),
                    );
                  }

                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return Container(
                      height: size.height * 0.2,
                      child: Center(child: Text('No hay datos del usuario')),
                    );
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;

                  return Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          filterQuality: FilterQuality.low,
                          image: AssetImage('assets/img/ESL back.png'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(size.width * 0.087)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            data['Name'] ?? 'Nombre clase',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.06,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['Subname'] ?? 'Descripción',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.02,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['Days'] ?? 'Días',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.017,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            data['Time'] ?? 'Horario',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.017,
                                fontFamily: 'Arial',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              
              Container(
                height: size.height * 0.05,
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    border: Border(
                        bottom: BorderSide(
                            width: 1,
                            color: const Color.fromARGB(148, 163, 163, 163)))),
                child: TextButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/studentESLpm_files'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Icon(
                          Icons.folder,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        SizedBox(
                          width: size.width * 0.01,
                        ),
                        Text(
                          'Archivos'.tr(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: size.height * 0.018,
                              fontFamily: 'Arial',
                              //fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                      ],
                    )),
              ),
              
              SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                reverse: false,
                padding: EdgeInsets.all(size.width * 0.001),
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: streaming,
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Text('Something went wrong');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Column(children: [
                              SizedBox(
                                height: size.height * 0.02,
                              ),
                              SpinKitFadingCircle(
                                color: Theme.of(context).colorScheme.tertiary,
                                size: size.width * 0.1,
                              ),
                            ]);
                          }
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return RefreshIndicator(
                                color: Theme.of(context).colorScheme.tertiary,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                elevation: 0,
                                onRefresh:
                                    () async {}, // o tu función de refresco
                                child: SizedBox(
                                  height: size.height * 0.345,
                                  child: ListView(
                                    physics:
                                        AlwaysScrollableScrollPhysics(), // necesario para pull-to-refresh
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.05),
                                        child: Center(
                                          child: Text(
                                            'Aún no hay publicaciones'.tr(),
                                            style: TextStyle(
                                              fontSize: size.height * 0.018,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            final snap = snapshot.data!.docs;
                            return RefreshIndicator(
                              elevation: 0,
                              color: Theme.of(context).colorScheme.tertiary,
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              displacement: 1,
                              strokeWidth: 3,
                              onRefresh: () async {},
                              child: SizedBox(
                                height: size.height * 0.465,
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
                                      
  final doc = snap[index];
  final Map<String, dynamic> dataMap = doc.data() as Map<String, dynamic>;

  // --- Null-safety en todos los campos del post ---
  final String avatarUrl = (dataMap['Image'] as String?) ?? '';
  final String name      = (dataMap['User']  as String?) ?? '';
  final String timeStr   = (dataMap['Time']  as String?) ?? '';
  final String dateStr   = (dataMap['Date']  as String?) ?? '';
  final String comment   = (dataMap['Comment'] as String?) ?? '';

  // Lista de imágenes segura (filtra nulls y vacíos)
  final List<String> images = ((dataMap['images'] as List?) ?? const [])
      .map((e) => (e as dynamic)?.toString() ?? '')
      .where((s) => s.isNotEmpty)
      .toList();

  return AnimationConfiguration.staggeredList(
    position: index,
    child: ScaleAnimation(
      duration: const Duration(milliseconds: 300),
      child: FadeInAnimation(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(size.width * 0.04),
          ),
          elevation: size.height * 0.01,
          shadowColor: Colors.black,
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Cabecera (avatar, nombre, hora) ---
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                      backgroundColor: Theme.of(context).colorScheme.tertiary,
                      minRadius: size.height * 0.021,
                      maxRadius: size.height * 0.021,
                      child: avatarUrl.isEmpty
                          ? Icon(Icons.person,
                              color: Colors.white, size: size.height * 0.02)
                          : null,
                    ),
                    SizedBox(width: size.width * 0.02),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: size.height * 0.018,
                        fontFamily: 'Arial',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    SizedBox(width: size.width * 0.02),
                    Text(
                      timeStr,
                      style: TextStyle(
                        fontSize: size.height * 0.013,
                        fontFamily: 'Arial',
                        color: const Color.fromARGB(255, 168, 168, 168),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.004),
                Row(
                  children: [
                    SizedBox(width: size.width * 0.12),
                    Text(
                      dateStr,
                      style: TextStyle(
                        fontSize: size.height * 0.013,
                        fontFamily: 'Arial',
                        color: const Color.fromARGB(255, 168, 168, 168),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.006),

                // --- Mensaje con links (seguro) ---
                Align(
                  alignment: Alignment.topLeft,
                  child: Linkify(
                    text: comment,
                    linkStyle: TextStyle(
                      decoration: TextDecoration.none,
                      fontSize: size.height * 0.0155,
                      fontFamily: 'Arial',
                      color: const Color.fromARGB(255, 94, 145, 255),
                    ),
                    style: TextStyle(
                      fontSize: size.height * 0.0155,
                      fontFamily: 'Arial',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onOpen: (link) async {
                      if (!await launchUrl(Uri.parse(link.url))) {
                        throw Exception('Could not launch ${link.url}');
                      }
                    },
                  ),
                ),

                // --- Imágenes con apertura a ImageDetallesHome ---
                if (images.isNotEmpty) ...[
                  SizedBox(height: size.height * 0.01),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(size.width * 0.03),
                    child: SizedBox(
                      height: size.height * 0.30,
                      child: images.length == 1
                          // 1 sola imagen -> abrir detalle (idx 0)
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    transitionDuration:
                                        const Duration(milliseconds: 500),
                                    reverseTransitionDuration:
                                        const Duration(milliseconds: 500),
                                    pageBuilder: (_, __, ___) => ImageDetallesHome(
                                      images: images,
                                      initialIndex: 0,
                                      documentSnapshot: doc,
                                    ),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: 'student_ESLpm_post_${doc.id}_img_0',
                                child: Image.network(
                                  images.first,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          // Varias imágenes -> carrusel; cada slide abre con su índice
                          : PageView.builder(
                              itemCount: images.length,
                              controller: PageController(viewportFraction: 0.95),
                              itemBuilder: (_, idx) {
                                final url = images[idx];
                                return Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        PageRouteBuilder(
                                          transitionDuration:
                                              const Duration(milliseconds: 500),
                                          reverseTransitionDuration:
                                              const Duration(milliseconds: 500),
                                          pageBuilder: (_, __, ___) =>
                                              ImageDetallesHome(
                                            images: images,
                                            initialIndex: idx,
                                            documentSnapshot: doc,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Hero(
                                      tag:
                                          'student_ESLpm_post_${doc.id}_img_$idx',
                                      child: Image.network(
                                        url,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
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
    final imageRef = storageRef.child(currentUsera.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      print('Profile Picture could not be found');
    }
  }
}

class FireStoreDataBase {
  final currentUsera = FirebaseAuth.instance.currentUser!;
  String? downloadURL;
  Future getData() async {
    try {
      await downloadURLExample();
      return downloadURL;
    } catch (e) {
      debugPrint('Error - $e');
      return null;
    }
  }

  Future<void> downloadURLExample() async {
    downloadURL = await FirebaseStorage.instance
        .ref()
        .child(currentUsera.email.toString())
        .getDownloadURL();
    debugPrint(downloadURL.toString());
  }
}
