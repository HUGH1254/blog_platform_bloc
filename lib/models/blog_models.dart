class User {
  final String id;
  final String name;
  User({required this.id, required this.name});
}

class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final String category;
  final String image;
  final String createdAt;

  Post({
    required this.id, required this.title, required this.content, 
    required this.author, required this.category, required this.image, required this.createdAt
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      category: json['category'],
      image: json['image'],
      createdAt: json['createdAt'],
    );
  }
}

// Dữ liệu mẫu ban đầu
final List<Post> mockPosts = [
  Post(id: 1, title: 'Hướng dẫn Flutter BLoC', content: 'Nội dung chi tiết...', author: 'John', category: 'Technology', image: 'https://via.placeholder.com/400', createdAt: '2024-01-01'),
  Post(id: 2, title: 'UI/UX cơ bản', content: 'Thiết kế đẹp...', author: 'Alice', category: 'Design', image: 'https://via.placeholder.com/400', createdAt: '2024-01-02'),
];
class Comment {
  final String id;
  final int postId; // ID của bài viết chứa bình luận này
  final String author;
  final String text;
  final String? parentId;

  Comment({
    required this.id, required this.postId, required this.author, 
    required this.text, this.parentId
  });
}