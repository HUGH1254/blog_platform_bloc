import '../../models/blog_models.dart';

abstract class PostState {}
class PostLoading extends PostState {}
class PostLoaded extends PostState {
  final List<Post> posts;
  final String searchQuery;
  final String selectedCategory;
  final int currentPage;
  final bool hasReachedMax;

  PostLoaded({
    required this.posts, this.searchQuery = '', 
    this.selectedCategory = 'All', this.currentPage = 1, this.hasReachedMax = false
  });

  PostLoaded copyWith({
    List<Post>? posts, String? searchQuery, String? selectedCategory, 
    int? currentPage, bool? hasReachedMax
  }) {
    return PostLoaded(
      posts: posts ?? this.posts,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}