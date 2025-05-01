import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/membre.dart';
import 'package:flutter_facebook_teo/pages/page_profil.dart';
import 'package:flutter_facebook_teo/services_firebase/service_authentification.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/avatar.dart';
import 'package:flutter_facebook_teo/widgets/widget_vide.dart';

class PageMembres extends StatefulWidget {
  const PageMembres({super.key});

  @override
  State<PageMembres> createState() => _PageMembresState();
}

class _PageMembresState extends State<PageMembres> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ServiceFirestore().allMembers(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const EmptyBody(message: "Erreur de chargement");
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const EmptyBody(message: "Aucun membre trouvé");
        }

        final myId = ServiceAuthentification().myId!;

        final members =
            snapshot.data!.docs
                .map(
                  (doc) => Membre(
                    reference: doc.reference,
                    id: doc.id,
                    map: doc.data() as Map<String, dynamic>,
                  ),
                )
                .where((membre) => membre.id != myId)
                .toList();

        return ListView.separated(
          itemCount: members.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final member = members[index];
            return ListTile(
              title: Text(member.name),
              subtitle: Text(member.surname),
              leading: Avatar(radius: 20, url: member.profilePicture),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PageProfil(member: member)),
                );
              },
            );
          },
        );
      },
    );
  }
}
