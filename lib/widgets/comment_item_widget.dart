import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/blog_models.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../bloc/comment/comment_bloc.dart';
import '../bloc/comment/comment_event.dart';
import '../bloc/comment/comment_state.dart';

class CommentSectionWidget extends StatefulWidget {
  final int postId;
  const CommentSectionWidget({super.key, required this.postId});

  @override
  State<CommentSectionWidget> createState() => _CommentSectionWidgetState();
}

class _CommentSectionWidgetState extends State<CommentSectionWidget> {
  final TextEditingController _commentCtrl = TextEditingController();
  Comment? _replyingTo;

  @override
  void initState() {
    super.initState();
    // Tải bình luận của bài viết này khi vừa mở lên
    context.read<CommentBloc>().add(LoadComments(widget.postId));
  }

  void _submitComment() {
    if (_commentCtrl.text.trim().isEmpty) return;

    final authState = context.read<AuthBloc>().state;
    String currentUserName = "Guest";
    if (authState is AuthAuthenticated) {
      currentUserName = authState.currentUser.name;
    }

    context.read<CommentBloc>().add(AddComment(
      postId: widget.postId,
      text: _commentCtrl.text,
      author: currentUserName,
      replyingTo: _replyingTo,
    ));

    _commentCtrl.clear();
    setState(() => _replyingTo = null);
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Text('Bình luận', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ),
        
        // 1. DANH SÁCH BÌNH LUẬN
        BlocBuilder<CommentBloc, CommentState>(
          builder: (context, state) {
            if (state is CommentLoading) return const Center(child: CircularProgressIndicator());
            if (state is CommentLoaded) {
              if (state.comments.isEmpty) return const Text('Chưa có bình luận nào. Hãy là người đầu tiên!');

              final roots = state.comments.where((c) => c.parentId == null).toList();
              
              return ListView.builder(
                shrinkWrap: true, // Quan trọng: Để listview không bị lỗi khi nằm trong SingleChildScrollView
                physics: const NeverScrollableScrollPhysics(),
                itemCount: roots.length,
                itemBuilder: (context, index) {
                  final root = roots[index];
                  final children = state.comments.where((c) => c.parentId == root.id).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCommentItem(root, isChild: false),
                      for (var child in children) _buildCommentItem(child, isChild: true),
                    ],
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),

        const SizedBox(height: 16),

        // 2. KHUNG NHẬP BÌNH LUẬN
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              if (_replyingTo != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Text('Đang trả lời: @${_replyingTo!.author}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() => _replyingTo = null),
                        child: const Icon(Icons.close, size: 16),
                      )
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Nhập bình luận...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _submitComment,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentItem(Comment comment, {required bool isChild}) {
    return Padding(
      padding: EdgeInsets.only(left: isChild ? 40.0 : 0.0, top: 8.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 16, child: Text(comment.author[0])),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.author, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(comment.text),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: () => setState(() => _replyingTo = comment),
                  child: const Text('Phản hồi', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}