import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/post.dart';

class WidgetContenuPost extends StatelessWidget {
  final Post post;
  const WidgetContenuPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            Row(children: [Text("a")]),
          ],
        ),
      ),
    );
  }
}


// Card
// Container
// Column
// Row
// Avatar(rayon de 15 et photo de l’émetteur du post)
// Text(nom complet de l’émeteur du post)
// DateHandler(date d’émission du post)
// Si imageUrl alors
// Image.network
// Sinon
// Container(vide)
// Text(texte du post)
// Row
// IconButton(Icon.star)
// Text(nombre de likes)
// IconButton(Icon.messenger)
// Text(commenter)