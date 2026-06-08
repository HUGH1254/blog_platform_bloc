import 'dart:io';
import 'package:flutter/material.dart';
import '../models/blog_models.dart';
import '../screens/post_detail_screen.dart';

class PostCardWidget extends StatelessWidget {
  final Post post;
  const PostCardWidget({super.key, required this.post});

  Widget _buildImage() {
    if (post.image.isEmpty) return const Icon(Icons.image_not_supported, size: 50);
    if (post.image.startsWith('http')) {
      return Image.network(
        post.image, 
        width: 50, height: 50, fit: BoxFit.cover,
        errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 50),
      );
    }
    return Image.file(
      File(post.image), 
      width: 50, height: 50, fit: BoxFit.cover,
      errorBuilder: (ctx, err, stack) => const Icon(Icons.broken_image, size: 50),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: _buildImage(),
        title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(post.author),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PostDetailScreen(post: post))),
      ),
    );
  }
}