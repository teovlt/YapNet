import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/constants.dart';
import 'package:flutter_facebook_teo/modeles/membre.dart';
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
    return StreamBuilder<QuerySnapshot>(
      stream: ServiceFirestore().postForMember(widget.member.id),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        final data = snapshot.data;
        final docs = data?.docs;
        final length = docs?.length ?? 0;
        final isMe = ServiceAuthentification().isMe(widget.member.id);
        final indexToAdd = (isMe) ? 2 : 1;

        return ListView.builder(
          itemCount: length + indexToAdd,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Column(
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
                                color: Theme.of(context).colorScheme.primary,
                                child:
                                    (isMe)
                                        ? Container(
                                          height: 200,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                            image:
                                                widget
                                                        .member
                                                        .coverPicture
                                                        .isNotEmpty
                                                    ? DecorationImage(
                                                      image: NetworkImage(
                                                        widget
                                                            .member
                                                            .coverPicture,
                                                      ),
                                                      fit: BoxFit.cover,
                                                    )
                                                    : null,
                                          ),
                                          child: BoutonCamera(
                                            type: profilePictureKey,
                                            userId: widget.member.id,
                                          ),
                                        )
                                        : Center(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                        ],
                      ),
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Avatar(radius: 75, url: widget.member.profilePicture),
                          (isMe)
                              ? BoutonCamera(
                                type: profilePictureKey,
                                userId: widget.member.id,
                              )
                              : Center(),
                        ],
                      ),
                    ],
                  ),
                  Text(
                    widget.member.fullname,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const Divider(),
                  Text(widget.member.description),
                ],
              );
            }
            return null;
          },
        );
      },
    );
  }
}
