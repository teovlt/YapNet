import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/widget_vide.dart';

class ListCommentaire extends StatelessWidget {
  const ListCommentaire({super.key});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allMembers = ServiceFirestore().allMembers();

    return StreamBuilder<QuerySnapshot>(
      stream: allMembers,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const EmptyBody(message: "Aucun commentaires pour le moment");
        }

        return ListView.separated(
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            var document = snapshot.data!.docs[index];
            return ListTile(
              title: Text(document[textKey]),
              subtitle: Text(document[memberIdKey]),
              leading: const Icon(Icons.comment),
            );
          },
        );
      },
    );
  }
}
