import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

class ImageStoreMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, user, String nombre) async {
    String res = 'Error';
    try {
      
      String elnombre = nombre;
      String usuario = user;
      String photoUrl = await imageToStorage(file);
      String postId = const Uuid().v1();
      DateTime date = DateTime.now();
      String today = '${date.day}/${date.month}/${date.year}';
      String timetoday = '${date.hour}:${date.minute}';

      if (file == null) {
          
              _firestore.collection('posts').doc(postId).set({
                'Comment': description,
                'Date': today,
                'Time': timetoday,
                'User': elnombre,
                'postUrl': 'no imagen',
                'postId': 'no id',
                'Image': usuario,
                'createdAt': Timestamp.now()
              });
              res = 'success';
           
      } else {
        _firestore.collection('posts').doc(postId).set({
          'Comment': description,
          'Date': today,
          'Time': timetoday,
          'User': elnombre,
          'postUrl': photoUrl,
          'postId': postId,
          'Image': usuario,
          'createdAt': Timestamp.now()
        });
        res = 'success';
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> imageToStorage(Uint8List file) async {
    String id = const Uuid().v1();
    Reference ref = _storage.ref().child('posts').child(id);

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snapshot = await uploadTask;
    String donwloadUrl = await snapshot.ref.getDownloadURL();
    return donwloadUrl;
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
