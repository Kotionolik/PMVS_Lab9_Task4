part of 'auth_cubit.dart';
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }
class AuthState {
  final AuthStatus status;
  final AppUser? user;
  final String? error;
  const AuthState.initial() : status = AuthStatus.initial, user = null, error = null;
  const AuthState.loading() : status = AuthStatus.loading, user = null, error = null;
  const AuthState.authenticated(this.user) : status = AuthStatus.authenticated, error = null;
  const AuthState.unauthenticated() : status = AuthStatus.unauthenticated, user = null, error = null;
  const AuthState.error(this.error) : status = AuthStatus.error, user = null;
}