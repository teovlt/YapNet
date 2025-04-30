import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/post.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/widget_post.dart';
import 'package:flutter_facebook_teo/widgets/widget_vide.dart';

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ServiceFirestore().allPosts(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Erreur de chargement'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const EmptyBody();
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            final doc = snapshot.data!.docs[index];
            final post = Post(
              reference: doc.reference,
              id: doc.id,
              map: doc.data() as Map<String, dynamic>,
            );
            return WidgetPost(post: post);
          },
        );
      },
    );
  }
}
