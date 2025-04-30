import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/post.dart';
import 'package:flutter_facebook_teo/services_firebase/service_authentification.dart';
import 'package:flutter_facebook_teo/widgets/widget_contenu_post.dart';

class WidgetPost extends StatelessWidget {
  final Post post;
  const WidgetPost({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: [
            WidgetContenuPost(post: post),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.star,
                    color:
                        post.likes.contains(ServiceAuthentification().myId!)
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text('${post.likes.length} Likes'),
                IconButton(onPressed: () {}, icon: Icon(Icons.messenger)),
                Text('Commenter'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
