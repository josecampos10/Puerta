import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MapaPersonalizadoView extends StatefulWidget {
  const MapaPersonalizadoView({super.key});

  @override
  State<MapaPersonalizadoView> createState() => _MapaPersonalizadoViewState();
}

class _MapaPersonalizadoViewState extends State<MapaPersonalizadoView> {
  late final WebViewController _controller;

  final String mapaUrl =
      'https://www.google.com/maps/d/u/1/embed?mid=1ivghEE4pApHqpAM0CcXuINrOfEmf2jkf';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(mapaUrl));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa de recursos'.tr(),style: TextStyle(color: Colors.white, fontFamily: 'Arial', fontSize: size.height*0.02, fontWeight: FontWeight.bold),),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
