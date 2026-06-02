import '../../models/blog_models.dart';

abstract class CommentEvent {}
class LoadComments extends CommentEvent {
  final int postId;
  LoadComments(this.postId);
}
class AddComment extends CommentEvent {
  final int postId;
  final String text;
  final String author;
  final Comment? replyingTo;

  AddComment({required this.postId, required this.text, required this.author, this.replyingTo});
}