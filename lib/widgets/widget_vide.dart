import 'package:flutter/material.dart';

class EmptyBody extends StatelessWidget {
  final String? message;
  const EmptyBody({super.key, this.message = "Aucun contenu disponible"});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(message!));
  }
}

class EmptyScaffold extends StatelessWidget {
  const EmptyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: EmptyBody());
  }
}
