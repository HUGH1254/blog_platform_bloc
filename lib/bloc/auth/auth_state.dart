import '../../models/blog_models.dart';
abstract class AuthState {}
class AuthInitial extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User currentUser;
  AuthAuthenticated(this.currentUser);
}