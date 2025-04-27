import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/pages/page_authentification.dart';

class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Page d\'accueil'),
      ),
      body: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return (snapshot.hasData)
              ? const Center(child: Text('Vous êtes connecté'))
              : const Center(child: PageAuthentification());
        },
      ),
    );
  }
}
