import 'package:flutter_bloc/flutter_bloc.dart';
import 'post_event.dart';
import 'post_state.dart';
import '../../models/blog_models.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  List<Post> _database = List.from(mockPosts);

  PostBloc() : super(PostLoading()) {
    on<FetchPosts>((event, emit) async {
      if (state is PostLoaded && (state as PostLoaded).hasReachedMax && !event.isRefresh) return;

      try {
        if (event.isRefresh || state is PostLoading) {
          emit(PostLoading());
          await Future.delayed(const Duration(milliseconds: 500));
          // Tải trang 1 (ví dụ 10 bài)
          emit(PostLoaded(posts: _database, currentPage: 1, hasReachedMax: false));
        } else {
          final currentState = state as PostLoaded;
          // Giả lập load more (Trang 2, 3...)
          await Future.delayed(const Duration(milliseconds: 500));
          emit(currentState.copyWith(hasReachedMax: true)); // Giả lập đã hết data
        }
      } catch (_) {}
    });

    on<SearchAndFilter>((event, emit) {
      final currentState = state as PostLoaded;
      final q = event.query ?? currentState.searchQuery;
      final cat = event.category ?? currentState.selectedCategory;
      
      final filtered = _database.where((p) {
        final matchQuery = p.title.toLowerCase().contains(q.toLowerCase());
        final matchCat = cat == 'All' || p.category == cat;
        return matchQuery && matchCat;
      }).toList();

      emit(currentState.copyWith(posts: filtered, searchQuery: q, selectedCategory: cat));
    });

    on<SubmitPost>((event, emit) {
      if (event.isEdit) {
        int index = _database.indexWhere((p) => p.id == event.post.id);
        if (index != -1) _database[index] = event.post;
      } else {
        _database.insert(0, event.post);
      }
      add(FetchPosts(isRefresh: true));
    });

    on<DeletePost>((event, emit) {
      _database.removeWhere((p) => p.id == event.postId);
      add(FetchPosts(isRefresh: true));
    });
  }
}