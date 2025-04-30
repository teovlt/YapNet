import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:image_picker/image_picker.dart';

class BoutonCamera extends StatelessWidget {
  final String type;
  final String userId;

  const BoutonCamera({super.key, required this.type, required this.userId});

  _takePicture(ImageSource source, String type) async {
    final XFile? xFile = await ImagePicker().pickImage(
      source: source,
      maxWidth: 500,
    );
    if (xFile == null) return;
    ServiceFirestore().updateImage(
      file: File(xFile.path),
      folder: memberCollectionKey,
      userId: userId,
      imageName: type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.camera_alt),
      onPressed: () {
        _takePicture(ImageSource.camera, type);
      },
    );
  }
}
