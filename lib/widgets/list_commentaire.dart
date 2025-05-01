import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/modeles/formatage_date.dart';
import 'package:flutter_facebook_teo/modeles/post.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/avatar.dart';
import 'package:flutter_facebook_teo/widgets/widget_vide.dart';

class ListCommentaire extends StatelessWidget {
  final Post post;
  const ListCommentaire({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> commentsStream = ServiceFirestore().postComment(
      post.id,
    );

    return StreamBuilder<QuerySnapshot>(
      stream: commentsStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const EmptyBody(message: "Aucun commentaire pour le moment");
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.docs.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            var document = snapshot.data!.docs[index];
            final String memberId = document[memberIdKey];
            return FutureBuilder<Map<String, dynamic>?>(
              future: ServiceFirestore().getMember(memberId),
              builder: (context, snapshotUser) {
                if (!snapshotUser.hasData) {
                  return const ListTile(
                    leading: CircleAvatar(child: Icon(Icons.person)),
                    title: Text("Chargement..."),
                  );
                }
                final member = snapshotUser.data!;
                final profileUrl = member[profilePictureKey];
                final dateFormatted = FormatageDate().formatted(
                  document[dateKey],
                );
                return ListTile(
                  leading: Avatar(radius: 20, url: profileUrl),
                  title: Text(document[textKey]),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "par ${member[surnameKey]} ${member[nameKey]}",
                            style: const TextStyle(fontSize: 12),
                          ),
                          Spacer(),
                          Text(dateFormatted),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
