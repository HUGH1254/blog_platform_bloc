import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../models/blog_models.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/post/post_event.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';

class CreateEditPostScreen extends StatefulWidget {
  final Post? editPost;
  const CreateEditPostScreen({super.key, this.editPost});

  @override
  State<CreateEditPostScreen> createState() => _CreateEditPostScreenState();
}

class _CreateEditPostScreenState extends State<CreateEditPostScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _contentCtrl;
  String _category = 'Technology';
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.editPost?.title ?? '');
    _contentCtrl = TextEditingController(text: widget.editPost?.content ?? '');
    if (widget.editPost != null) _category = widget.editPost!.category;
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _imageFile = File(picked.path));
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is! AuthAuthenticated) return;

      final newPost = Post(
        id: widget.editPost?.id ?? DateTime.now().millisecondsSinceEpoch,
        title: _titleCtrl.text,
        content: _contentCtrl.text,
        author: authState.currentUser.name, // Lấy tên User đang đăng nhập
        category: _category,
        image: _imageFile?.path ?? widget.editPost?.image ?? 'https://via.place holder.com/400',
        createdAt: widget.editPost?.createdAt ?? DateTime.now().toString(),
      );

      context.read<PostBloc>().add(SubmitPost(newPost, isEdit: widget.editPost != null));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.editPost == null ? 'Tạo bài mới' : 'Sửa bài')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200, color: Colors.grey[300],
                child: _imageFile != null ? Image.file(_imageFile!, fit: BoxFit.cover) 
                     : (widget.editPost?.image != null && widget.editPost!.image.isNotEmpty
                        ? (widget.editPost!.image.startsWith('http') 
                            ? Image.network(widget.editPost!.image, fit: BoxFit.cover)
                            : Image.file(File(widget.editPost!.image), fit: BoxFit.cover))
                        : const Center(child: Icon(Icons.add_a_photo, size: 50))),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Tiêu đề'),
              validator: (val) => val!.isEmpty ? 'Vui lòng nhập tiêu đề' : null,
            ),
            DropdownButtonFormField<String>(
              initialValue: _category,
              items: ['Technology', 'Design'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (val) => setState(() => _category = val!),
            ),
            TextFormField(
              controller: _contentCtrl, maxLines: 5,
              decoration: const InputDecoration(labelText: 'Nội dung'),
              validator: (val) => val!.isEmpty ? 'Vui lòng nhập nội dung' : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _submit, child: const Text('Lưu'))
          ],
        ),
      ),
    );
  }
}