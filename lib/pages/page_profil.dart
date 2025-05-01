import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/modeles/membre.dart';
import 'package:flutter_facebook_teo/pages/page_maj_profil.dart';
import 'package:flutter_facebook_teo/services_firebase/service_authentification.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/avatar.dart';
import 'package:flutter_facebook_teo/widgets/bouton_camera.dart';

class PageProfil extends StatefulWidget {
  final Membre member;
  const PageProfil({super.key, required this.member});

  @override
  State<PageProfil> createState() => _PageProfilState();
}

class _PageProfilState extends State<PageProfil> {
  @override
  Widget build(BuildContext context) {
    final isMe = ServiceAuthentification().isMe(widget.member.id);

    return Scaffold(
      appBar:
          isMe
              ? null
              : AppBar(
                title: Text(widget.member.fullname),
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ServiceFirestore().postForMember(widget.member.id),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data;
          final docs = data?.docs;
          final length = docs?.length ?? 0;
          final indexToAdd = (isMe) ? 2 : 1;

          return ListView.builder(
            itemCount: length + indexToAdd,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Stack(
                              children: [
                                Container(
                                  height: 200,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    image:
                                        widget.member.coverPicture.isNotEmpty
                                            ? DecorationImage(
                                              image: NetworkImage(
                                                widget.member.coverPicture,
                                              ),
                                              fit: BoxFit.cover,
                                            )
                                            : null,
                                  ),
                                  child:
                                      isMe
                                          ? BoutonCamera(
                                            type: coverPictureKey,
                                            userId: widget.member.id,
                                          )
                                          : null,
                                ),
                              ],
                            ),
                            const SizedBox(height: 25),
                          ],
                        ),
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Avatar(
                                  radius: 75,
                                  url: widget.member.profilePicture,
                                ),
                              ),
                              if (isMe)
                                Center(
                                  child: BoutonCamera(
                                    type: profilePictureKey,
                                    userId: widget.member.id,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.member.fullname,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        widget.member.description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    if (isMe)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => PageMajProfil(member: widget.member),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          label: const Text("Modifier le profil"),
                        ),
                      ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
