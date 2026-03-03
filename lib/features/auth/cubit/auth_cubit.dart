import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';

const _kUsername = 'admin';
const _kPassword = 'admin123';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthUnauthenticated());

  bool get isAuthenticated => state is AuthAuthenticated;

  Future<void> login(String username, String password) async {
    emit(const AuthLoading());
    await Future.delayed(const Duration(milliseconds: 350));
    if (username.trim() == _kUsername && password == _kPassword) {
      emit(const AuthAuthenticated());
    } else {
      emit(const AuthError('Invalid username or password. Please try again.'));
    }
  }

  void logout() => emit(const AuthUnauthenticated());
}
