import 'package:flutter/material.dart';
import 'package:flutter_facebook_teo/modeles/post.dart';
import 'package:flutter_facebook_teo/services_firebase/service_firestore.dart';
import 'package:flutter_facebook_teo/widgets/list_commentaire.dart';
import 'package:flutter_facebook_teo/widgets/widget_contenu_post.dart';

class PageDetailPost extends StatefulWidget {
  final Post post;
  const PageDetailPost({super.key, required this.post});

  @override
  State<PageDetailPost> createState() => _PageDetailPostState();
}

class _PageDetailPostState extends State<PageDetailPost> {
  final TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> addComment(String postId) async {
    final commentText = commentController.text.trim();
    if (commentText.isEmpty) return;

    try {
      await ServiceFirestore().addComment(post: widget.post, text: commentText);
      commentController.clear();
    } catch (e) {
      debugPrint("Error adding comment: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Commentaires'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetContenuPost(post: widget.post),
            Divider(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: const InputDecoration(
                        hintText: 'Écrivez un commentaire...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () => addComment(widget.post.id),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ListCommentaire(post: widget.post),
          ],
        ),
      ),
    );
  }
}
