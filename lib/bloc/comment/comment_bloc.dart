import 'package:flutter_bloc/flutter_bloc.dart';
import 'comment_event.dart';
import 'comment_state.dart';
import '../../models/blog_models.dart';

class CommentBloc extends Bloc<CommentEvent, CommentState> {
  // Giả lập Database chứa bình luận
  final List<Comment> _allComments = [];

  CommentBloc() : super(CommentLoading()) {
    on<LoadComments>((event, emit) async {
      emit(CommentLoading());
      await Future.delayed(const Duration(milliseconds: 300)); // Giả lập call API
      
      // Chỉ lấy các bình luận thuộc về bài viết đang xem
      final postComments = _allComments.where((c) => c.postId == event.postId).toList();
      emit(CommentLoaded(comments: postComments));
    });

    on<AddComment>((event, emit) {
      final currentState = state;
      if (currentState is CommentLoaded) {
        String? rootId;
        String finalText = event.text;

        // THUẬT TOÁN FACEBOOK: Gắn Tag @ và Ép tầng
        if (event.replyingTo != null) {
          final target = event.replyingTo!;
          finalText = '@${target.author} $finalText'; 

          if (target.parentId == null) {
            rootId = target.id;
          } else {
            rootId = target.parentId;
          }
        }

        final newComment = Comment(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          postId: event.postId,
          author: event.author,
          text: finalText,
          parentId: rootId,
        );

        _allComments.add(newComment); // Lưu vào DB tổng
        
        // Cập nhật lại UI cho bài viết hiện tại
        final updatedList = List<Comment>.from(currentState.comments)..add(newComment);
        emit(CommentLoaded(comments: updatedList));
      }
    });
  }
}