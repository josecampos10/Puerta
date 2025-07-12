import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:lapuerta2/onboarding.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';

class GuestdonateHome extends StatefulWidget {
  const GuestdonateHome({super.key});
  @override
  State<GuestdonateHome> createState() => _GuestdonateHomeState();
}

class _GuestdonateHomeState extends State<GuestdonateHome> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;

  @override
  void initState() {
    _init();
    
    super.initState();
    _initializeMapRenderer();
  }

  _init() {
    _cameraPosition = CameraPosition(
        target: LatLng(31.552747572929263, -97.1278868172345), zoom: 15.3);
  }

     void _initializeMapRenderer() {
    final GoogleMapsFlutterPlatform mapsImplementation = GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
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
                  /*Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Hola,',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Colors.white, fontSize: size.height * 0.018),
                      ),
                    ],
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Ubicación',
                          style: TextStyle(
                              fontSize: size.height * 0.027,
                              fontFamily: 'Arial',
                              //fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 255, 255, 255)),
                        ), // 👈 your valid data here
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
            ),
          ),
        ),
        actions: [
         
          IconButton(
            color: Colors.white,
            icon: Icon(Icons.logout, size: size.height*0.03,),
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => OnboardingPage()));
            },
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
      //backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(size.width * 0.08),
                topRight: Radius.circular(size.width * 0.08))),
        height: size.height,
        width: size.width,
        //decoration: BoxDecoration(
        //image: DecorationImage(image: AssetImage('assets/img/foto5.jpg'),
        //colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.dstATop),
        // fit: BoxFit.cover
        // ),
        //),

        child: SingleChildScrollView(
          //physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                  //padding: EdgeInsets.all(5.0),
                  height: size.height*0.789,
                  width: size.width * 1,
                  child: _buildBody())
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMap() {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(size.width * 0.08),
        topRight: Radius.circular(size.width * 0.08),
      ),
      child: GoogleMap(
        
          zoomControlsEnabled: false,
          myLocationEnabled: false,
          //padding: EdgeInsets.all(40),
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          onMapCreated: (GoogleMapController controller) {
            controller.showMarkerInfoWindow(MarkerId('La Puerta'));
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
          markers: {
            const Marker(
              visible: true,
              markerId: MarkerId("La Puerta"),
              position: LatLng(31.552747572929263, -97.1278868172345),
              infoWindow:
                  InfoWindow(title: "La Puerta", snippet: "500 Clay Ave"),
            ),
          }),
    );
  }
}
