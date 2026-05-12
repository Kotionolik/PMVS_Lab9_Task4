import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
part 'auth_state.dart';
class AuthCubit extends Cubit<AuthState> {
  final AuthService service;
  AuthCubit(this.service) : super(const AuthState.initial());
  Future<void> checkSession() async {
    final u = await service.currentUser();
    emit(u != null ? AuthState.authenticated(u) : const AuthState.unauthenticated());
  }
  Future<void> login(String email, String password) async {
    emit(const AuthState.loading());
    try {
      final u = await service.login(email, password);
      emit(u == null
        ? const AuthState.error('Invalid credentials')
        : AuthState.authenticated(u));
    } catch (e, s) {
      print('AuthCubit.login: $e\n$s');
      emit(AuthState.error(e.toString()));
    }
  }
  Future<void> logout() async {
    await service.logout();
    emit(const AuthState.unauthenticated());
  }
}