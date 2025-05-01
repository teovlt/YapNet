import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/modeles/formatage_date.dart';
import 'package:flutter_facebook_teo/modeles/post.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/avatar.dart';

class WidgetContenuPost extends StatelessWidget {
  final Post post;
  const WidgetContenuPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(post.member),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!.data() as Map<String, dynamic>;
        final profilePicture = data[profilePictureKey] ?? '';
        final name = data[nameKey] ?? '';
        final surname = data[surnameKey] ?? '';

        return Card(
          margin: const EdgeInsets.all(8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Avatar(radius: 15, url: profilePicture),
                    const SizedBox(width: 8),
                    Text(
                      '$name $surname',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(FormatageDate().formatted(post.date)),
                  ],
                ),
                const SizedBox(height: 12),
                if (post.image.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(post.image),
                  ),
                const SizedBox(height: 12),
                Text(post.text),
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
