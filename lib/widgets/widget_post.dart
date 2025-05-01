import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/post.dart';
import 'package:flutter_facebook_teo/pages/page_detail_post.dart';
import 'package:flutter_facebook_teo/services_firebase/service_authentification.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/widget_contenu_post.dart';

class WidgetPost extends StatelessWidget {
  final Post post;
  const WidgetPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            WidgetContenuPost(post: post),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    ServiceFirestore().addLike(
                      memberID: FirebaseAuth.instance.currentUser!.uid,
                      post: post,
                    );
                  },
                  icon: Icon(
                    Icons.star,
                    color:
                        post.likes.contains(ServiceAuthentification().myId!)
                            ? Colors.amber
                            : Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text('${post.likes.length} Likes'),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PageDetailPost(post: post),
                      ),
                    );
                  },
                  icon: const Icon(Icons.messenger),
                ),
                FutureBuilder<dynamic>(
                  future: ServiceFirestore().getCommentsNumber(post.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("...");
                    } else if (snapshot.hasError) {
                      return const Text("Erreur");
                    } else {
                      return Text('${snapshot.data} Commentaires');
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
