import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pinch_zoom/pinch_zoom.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageDetallesHome extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  /// Opcional: lista completa de imágenes para carrusel
  final List<String>? images;

  /// Opcional: índice inicial cuando hay múltiples imágenes
  final int initialIndex;

  /// Opcional: prefijo para Hero en modo múltiples (debe coincidir con el tag del feed)
  final String? heroTagPrefix;

  const ImageDetallesHome({
    super.key,
    required this.documentSnapshot,
    this.images,
    this.initialIndex = 0,
    this.heroTagPrefix,
  });

  @override
  State<ImageDetallesHome> createState() => _ImageDetallesHomeState();
}

class _ImageDetallesHomeState extends State<ImageDetallesHome> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  late final PageController _pageController;

  Uint8List? pickedImage;
  bool showInfo = true;

  bool get _isMulti =>
      widget.images != null && widget.images!.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
      body: GestureDetector(
        onTap: () => setState(() => showInfo = !showInfo),
        child: Stack(
          children: [
            // ======== IMAGEN(ES) ========
            Positioned.fill(
              child: _isMulti
                  ? _buildMultiViewer(size)
                  : _buildSingleViewer(size),
            ),

            // ======== BOTÓN CERRAR ========
            Positioned(
              top: size.height * 0.07,
              right: 20,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showInfo ? 1.0 : 0.0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black45,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white),
                  ),
                ),
              ),
            ),

            // ======== INFO USUARIO ABAJO ========
            Positioned(
              left: 0,
              right: 0,
              bottom: size.height * 0.04,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: showInfo ? 1.0 : 0.0,
                child: _buildFooterInfo(size),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---- SINGLE IMAGE (comportamiento original) ----
  Widget _buildSingleViewer(Size size) {
    return PinchZoom(
      maxScale: 5.0,
      child: Hero(
        tag: widget.documentSnapshot, // tu tag original
        flightShuttleBuilder: (
          flightContext,
          animation,
          flightDirection,
          fromHeroContext,
          toHeroContext,
        ) {
          return FadeTransition(
            opacity: animation.drive(
              Tween<double>(begin: 0.0, end: 1.0)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: toHeroContext.widget,
          );
        },
        child: CachedNetworkImage(
          imageUrl: widget.documentSnapshot['postUrl'],
          fit: BoxFit.contain,
          width: double.infinity,
          placeholder: (_, __) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (_, __, ___) => const Center(
            child: Text('No se pudo cargar la imagen',
                style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }

  // ---- MULTIPLE IMAGES (carrusel con PageView) ----
  Widget _buildMultiViewer(Size size) {
    final images = widget.images!;
    return PageView.builder(
      controller: _pageController,
      itemCount: images.length,
      itemBuilder: (_, idx) {
        final url = images[idx];

        final child = CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.contain,
          width: double.infinity,
          placeholder: (_, __) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (_, __, ___) => const Center(
            child: Text('No se pudo cargar la imagen',
                style: TextStyle(color: Colors.white)),
          ),
        );

        // Si quieres Hero también en múltiples, usa heroTagPrefix + idx (debe coincidir con el feed)
        final withHero = (widget.heroTagPrefix != null)
            ? Hero(tag: '${widget.heroTagPrefix}_$idx', child: child)
            : child;

        return Center(
          child: PinchZoom(
            maxScale: 5.0,
            child: withHero,
          ),
        );
      },
    );
  }

  Widget _buildFooterInfo(Size size) {
    return Container(
      padding: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.003),
          Row(
            children: [
              SizedBox(width: size.width * 0.014),
              CircleAvatar(
                radius: size.height * 0.018,
                backgroundImage: NetworkImage(widget.documentSnapshot['Image']),
              ),
              SizedBox(width: size.width * 0.01),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          (widget.documentSnapshot['User'] != null &&
                                  widget.documentSnapshot['User']
                                      .toString()
                                      .trim()
                                      .isNotEmpty)
                              ? widget.documentSnapshot['User']
                              : widget.documentSnapshot['User'],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.height * 0.017,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          widget.documentSnapshot['Date'],
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 13,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Text(
                widget.documentSnapshot['Time'],
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: size.height * 0.016,
                ),
              ),
              SizedBox(width: size.width * 0.014),
            ],
          ),
          SizedBox(height: size.height * 0.018),
        ],
      ),
    );
  }

  Future<void> getProfilePicture() async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef.child(currentUser.email.toString());

    try {
      final imageBytes = await imageRef.getData();
      if (imageBytes == null) return;
      setState(() => pickedImage = imageBytes);
    } catch (e) {
      // ignore
    }
  }
}

Future _launchUrlclass() async {
  final Uri url = Uri.parse("https://www.lapuertawaco.com/educacion");
  if (!await launchUrl(url)) {
    throw Exception("Could not launch $url");
  }
}
