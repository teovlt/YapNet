import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/formatage_date.dart';
import 'package:flutter_facebook_teo/modeles/membre.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/avatar.dart';

class WidgetMemberHeader extends StatelessWidget {
  const WidgetMemberHeader({
    super.key,
    required this.date,
    required this.memberId,
  });

  final int date;
  final String memberId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: ServiceFirestore().specificMember(memberId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          );
        }

        if (snapshot.hasData && snapshot.data!.data() != null) {
          final data = snapshot.data!;
          final Membre member = Membre(
            id: memberId,
            reference: data.reference,
            map: data.data() as Map<String, dynamic>,
          );

          return Row(
            children: [
              Avatar(url: member.profilePicture, radius: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  member.fullname,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                FormatageDate().formatted(date),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          );
        }

        return const SizedBox();
      },
    );
  }
}
