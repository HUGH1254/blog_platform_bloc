import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post/post_bloc.dart';
import '../bloc/post/post_event.dart';
import '../bloc/post/post_state.dart';
import '../widgets/post_card_widget.dart';
import 'create_edit_post_screen.dart';

class BlogHomeScreen extends StatefulWidget {
  const BlogHomeScreen({super.key});
  @override
  State<BlogHomeScreen> createState() => _BlogHomeScreenState();
}

class _BlogHomeScreenState extends State<BlogHomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Pagination: Kéo đến cuối thì tải thêm bài
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<PostBloc>().add(FetchPosts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blog Platform')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreateEditPostScreen())),
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(hintText: 'Tìm kiếm...', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
              onChanged: (val) => context.read<PostBloc>().add(SearchAndFilter(query: val)),
            ),
          ),
          
          // CATEGORY FILTER
          BlocBuilder<PostBloc, PostState>(
            builder: (context, state) {
              if (state is PostLoaded) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: ['All', 'Technology', 'Design'].map((cat) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: state.selectedCategory == cat,
                        onSelected: (_) => context.read<PostBloc>().add(SearchAndFilter(category: cat)),
                      ),
                    );
                  }).toList(),
                );
              }
              return const SizedBox();
            },
          ),

          // LIST BÀI VIẾT
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                if (state is PostLoading) return const Center(child: CircularProgressIndicator());
                if (state is PostLoaded) {
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.hasReachedMax ? state.posts.length : state.posts.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.posts.length) return const Center(child: CircularProgressIndicator());
                      return PostCardWidget(post: state.posts[index]);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}