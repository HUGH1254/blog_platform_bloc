import '../../models/blog_models.dart';
abstract class PostEvent {}
class FetchPosts extends PostEvent { // Phân trang
  final bool isRefresh;
  FetchPosts({this.isRefresh = false});
}
class SearchAndFilter extends PostEvent {
  final String? query;
  final String? category;
  SearchAndFilter({this.query, this.category});
}
class SubmitPost extends PostEvent {
  final Post post;
  final bool isEdit;
  SubmitPost(this.post, {this.isEdit = false});
}
class DeletePost extends PostEvent {
  final int postId;
  DeletePost(this.postId);
}