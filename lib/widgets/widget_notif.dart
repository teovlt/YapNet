import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/notification.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/member_header.dart';

class WidgetNotif extends StatelessWidget {
  const WidgetNotif({super.key, required this.notification});

  final NotificationModel notification;

  _markRead() {
    ServiceFirestore().markRead(notification.reference);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _markRead,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color:
              notification.isRead
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.red.withValues(alpha: 0.3),
        ),
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 5, right: 5),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            WidgetMemberHeader(
              date: notification.date,
              memberId: notification.from,
            ),
            const Divider(thickness: 1),
            Text(notification.text),
          ],
        ),
      ),
    );
  }
}
