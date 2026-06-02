import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../models/blog_models.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AppStarted>((event, emit) {
      // Giả lập user "John" đã đăng nhập thành công
      emit(AuthAuthenticated(User(id: 'u1', name: 'John')));
    });
  }
}