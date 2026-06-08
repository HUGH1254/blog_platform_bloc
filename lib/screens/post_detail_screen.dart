import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/blog_models.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/post/post_event.dart';
import 'create_edit_post_screen.dart';
import '../widgets/comment_item_widget.dart';

class PostDetailScreen extends StatelessWidget {
  final Post post;
  const PostDetailScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    bool isAuthor = false;
    
    // AUTHENTICATION CHECK
    if (authState is AuthAuthenticated) {
      isAuthor = authState.currentUser.name == post.author;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết'),
        actions: [
          // CHỈ TÁC GIẢ MỚI THẤY NÚT SỬA/XÓA
          if (isAuthor) ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CreateEditPostScreen(editPost: post))),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                context.read<PostBloc>().add(DeletePost(post.id));
                Navigator.pop(context);
              },
            ),
          ]
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(post.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('Bởi: ${post.author} | ${post.category}', style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            if (post.image.isNotEmpty)
              post.image.startsWith('http')
                  ? Image.network(post.image, errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 100))
                  : Image.file(File(post.image), errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 100))
            else
              const Icon(Icons.image_not_supported, size: 100),
            const SizedBox(height: 16),
            Text(post.content, style: const TextStyle(fontSize: 16)),
           const Divider(thickness: 2),
              CommentSectionWidget(postId: post.id),
          ],
        ),
      ),
    );
  }
}