import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String? url;
  final int radius;

  const Avatar({super.key, this.url = '', required this.radius});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return CircleAvatar(
        radius: radius.toDouble(),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: FlutterLogo(size: radius.toDouble()),
      );
    }

    return CircleAvatar(
      radius: radius.toDouble(),
      backgroundImage: NetworkImage(url!),
      backgroundColor: Theme.of(context).colorScheme.tertiary,
    );
  }
}
