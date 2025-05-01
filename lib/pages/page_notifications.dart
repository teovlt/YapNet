import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/membre.dart';
import 'package:flutter_facebook_teo/modeles/notification.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/widget_notif.dart';
import 'package:flutter_facebook_teo/widgets/widget_vide.dart';

class PageNotifications extends StatefulWidget {
  final Membre member;
  const PageNotifications({super.key, required this.member});

  @override
  State<PageNotifications> createState() => _PageNotificationsState();
}

class _PageNotificationsState extends State<PageNotifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: ServiceFirestore().notificationForUser(widget.member.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> notifications = snapshot.data!.docs;

            return ListView.separated(
              padding: const EdgeInsets.all(8),
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = NotificationModel(
                  id: notifications[index].id,
                  reference: notifications[index].reference,
                  data: notifications[index].data() as Map<String, dynamic>,
                );

                return WidgetNotif(notification: notification);
              },
            );
          } else {
            return EmptyBody();
          }
        },
      ),
    );
  }
}
