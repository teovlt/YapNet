import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/modeles/membre.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';

class PageMajProfil extends StatefulWidget {
  final Membre member;
  const PageMajProfil({super.key, required this.member});

  @override
  State<PageMajProfil> createState() => _PageMajProfilState();
}

class _PageMajProfilState extends State<PageMajProfil> {
  late TextEditingController surname;
  late TextEditingController name;
  late TextEditingController description;

  @override
  void initState() {
    super.initState();
    surname = TextEditingController(text: widget.member.surname);
    name = TextEditingController(text: widget.member.name);
    description = TextEditingController(text: widget.member.description);
  }

  @override
  void dispose() {
    surname.dispose();
    name.dispose();
    description.dispose();
    super.dispose();
  }

  Future<void> _onValidate() async {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> map = {};
    final member = widget.member;

    if (name.text.isNotEmpty && name.text != member.name) {
      map[nameKey] = name.text;
    }

    if (surname.text.isNotEmpty && surname.text != member.surname) {
      map[surnameKey] = surname.text;
    }

    if (description.text.isNotEmpty && description.text != member.description) {
      map[descriptionKey] = description.text;
    }
    ServiceFirestore().updateMember(id: member.id, data: map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier votre compte'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: surname,
              decoration: const InputDecoration(labelText: 'Prénom'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Nom'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: description,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("Enregistrer"),
              onPressed: _onValidate,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
