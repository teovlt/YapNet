import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/membre.dart';
import 'package:flutter_facebook_teo/pages/page_accueil.dart';
import 'package:flutter_facebook_teo/pages/page_ecriture_post.dart';
import 'package:flutter_facebook_teo/pages/page_membres.dart';
import 'package:flutter_facebook_teo/pages/page_notifications.dart';
import 'package:flutter_facebook_teo/pages/page_profil.dart';
import 'package:flutter_facebook_teo/services_firebase/service_authentification.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/widget_vide.dart';

class PageNavigation extends StatefulWidget {
  const PageNavigation({super.key});

  @override
  State<PageNavigation> createState() => _PageNavigationState();
}

class _PageNavigationState extends State<PageNavigation> {
  ServiceAuthentification serviceAuthentification = ServiceAuthentification();
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final memberId = ServiceAuthentification().myId;
    return (memberId == null)
        ? const EmptyScaffold()
        : StreamBuilder<DocumentSnapshot>(
          stream: ServiceFirestore().specificMember(memberId),
          builder: (
            BuildContext context,
            AsyncSnapshot<DocumentSnapshot> snapshot,
          ) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              final Membre member = Membre(
                reference: data.reference,
                id: data.id,
                map: data.data() as Map<String, dynamic>,
              );
              List<Widget> bodies = [
                PageAccueil(),
                PageMembres(),
                PageEcriturePost(member: member),
                PageNotifications(member: member),
                PageProfil(member: member),
              ];
              return Scaffold(
                appBar: AppBar(
                  title: Text('Cht\'i Face Bouc'),
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.exit_to_app),
                      onPressed: () async {
                        await serviceAuthentification.signOut();
                      },
                    ),
                  ],
                ),
                bottomNavigationBar: NavigationBar(
                  labelBehavior:
                      NavigationDestinationLabelBehavior.onlyShowSelected,
                  selectedIndex: index,
                  onDestinationSelected: (int newValue) {
                    setState(() {
                      index = newValue;
                    });
                  },
                  destinations: [
                    NavigationDestination(
                      icon: Icon(Icons.home),
                      label: "Accueil",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.group),
                      label: "Membres",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.border_color),
                      label: "Ecrire",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.notifications),
                      label: "Notifs",
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person),
                      label: "Profil",
                    ),
                  ],
                ),
                body: bodies[index],
              );
            } else {
              return const EmptyScaffold();
            }
          },
        );
  }
}
