import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- IMPORT BLOC & EVENT ---
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/post/post_bloc.dart';
import 'bloc/post/post_event.dart';
import 'bloc/comment/comment_bloc.dart';

// --- IMPORT SCREENS ---
import 'screens/blog_home_screen.dart';

void main() {
  // Đảm bảo các binding của Flutter được khởi tạo trước khi chạy App
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const MyBlogPlatform());
}

class MyBlogPlatform extends StatelessWidget {
  const MyBlogPlatform({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // 1. BLOC XÁC THỰC (ĐĂNG NHẬP)
        // Vừa tạo ra là bắn ngay sự kiện AppStarted() để lấy thông tin User đang đăng nhập
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(AppStarted()),
        ),

        // 2. BLOC BÀI VIẾT (QUẢN LÝ DANH SÁCH BÀI)
        // Vừa tạo ra là bắn sự kiện FetchPosts() để tải dữ liệu trang 1 từ Database
        BlocProvider<PostBloc>(
          create: (context) => PostBloc()..add(FetchPosts(isRefresh: true)),
        ),

        // 3. BLOC BÌNH LUẬN (QUẢN LÝ BÌNH LUẬN & GẮN THẺ)
        // Khởi tạo sẵn chờ đó, khi nào vào màn hình Chi tiết bài viết mới bắt đầu Load dữ liệu
        BlocProvider<CommentBloc>(
          create: (context) => CommentBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Full Blog Platform',
        debugShowCheckedModeBanner: false, // Tắt dải băng Debug góc phải
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[50], // Màu nền app hơi xám nhẹ cho đẹp
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          // Chỉnh sửa style nút bấm mặc định cho toàn app
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ),
        // Mở app lên là chạy thẳng vào Màn hình danh sách bài viết
        home: const BlogHomeScreen(),
      ),
    );
  }
}