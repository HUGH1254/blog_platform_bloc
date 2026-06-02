import '../../models/blog_models.dart';

abstract class CommentState {}
class CommentLoading extends CommentState {}
class CommentLoaded extends CommentState {
  final List<Comment> comments;
  CommentLoaded({required this.comments});
}