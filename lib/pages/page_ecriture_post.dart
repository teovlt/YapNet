import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/membre.dart';
import 'package:flutter_facebook_teo/pages/page_accueil.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:image_picker/image_picker.dart';

class PageEcriturePost extends StatefulWidget {
  final Membre member;
  const PageEcriturePost({super.key, required this.member});

  @override
  State<PageEcriturePost> createState() => _PageEcriturePostState();
}

class _PageEcriturePostState extends State<PageEcriturePost> {
  final TextEditingController textController = TextEditingController();
  XFile? selectedImage;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(
      source: source,
      maxWidth: 800,
    );
    if (image != null) {
      setState(() {
        selectedImage = XFile(image.path);
      });
    }
  }

  void envoyerPost() async {
    final texte = textController.text.trim();
    FocusScope.of(context).requestFocus(FocusNode());

    if (texte.isEmpty && selectedImage == null) return;

    try {
      await ServiceFirestore().createPost(
        member: widget.member,
        text: texte,
        image: selectedImage,
      );

      textController.clear();
      setState(() {
        selectedImage = null;
      });
    } catch (e) {
      debugPrint('Error creating post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un post")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.border_color),
                        SizedBox(width: 8),
                        Text("Écrire un post", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                    const Divider(height: 24),
                    TextField(
                      controller: textController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "Qu'avez-vous en tête ?",
                        border: InputBorder.none,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (selectedImage != null)
                      Image.file(
                        File(selectedImage!.path),
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.photo_library),
                          onPressed: () => pickImage(ImageSource.gallery),
                        ),
                        IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () => pickImage(ImageSource.camera),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        envoyerPost();
                      },
                      child: const Text("Envoyer"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
