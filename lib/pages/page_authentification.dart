import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/services_firebase/service_authentification.dart';

class PageAuthentification extends StatefulWidget {
  const PageAuthentification({super.key});

  @override
  State<PageAuthentification> createState() => _PageAuthentificationState();
}

class _PageAuthentificationState extends State<PageAuthentification> {
  late bool accountExists;
  late ServiceAuthentification serviceAuthentification;

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController nameController;
  late TextEditingController surnameController;

  @override
  void initState() {
    accountExists = true;
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    surnameController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  _onSelectedChanged(Set<bool> newValue) {
    setState(() {
      accountExists = newValue.first;
    });
  }

  _handleAuthentication() async {
    if (accountExists) {
      await serviceAuthentification.signIn(
        email: emailController.value as String,
        password: passwordController.value as String,
      );
    } else {
      await serviceAuthentification.signUp(
        email: emailController.value as String,
        password: passwordController.value as String,
        surname: surnameController.value as String,
        name: nameController.value as String,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(image: Image.asset('assets/image/auth.jpg').image),
              SegmentedButton(
                segments: const [
                  ButtonSegment<bool>(value: true, label: Text('Connexion')),
                  ButtonSegment<bool>(value: false, label: Text('Inscription')),
                ],
                selected: {accountExists},
                onSelectionChanged: _onSelectedChanged,
              ),
              Card(
                child: Column(
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: 'Mot de passe'),
                      obscureText: true,
                    ),
                    if (!accountExists)
                      Column(
                        children: [
                          TextField(
                            controller: surnameController,
                            decoration: InputDecoration(labelText: 'Prénom'),
                          ),
                          TextField(
                            controller: nameController,
                            decoration: InputDecoration(labelText: 'Nom'),
                          ),
                        ],
                      ),
                    Center(
                      child: TextButton(
                        onPressed: _handleAuthentication,
                        child: const Text('C\'est parti !'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
