import '../models/user_model.dart';

sealed class AuthState {
  const AuthState();

  const factory AuthState.initial() = AuthStateInitial;
  const factory AuthState.loading() = AuthStateLoading;
  const factory AuthState.otpSent(String phone) = AuthStateOtpSent;
  const factory AuthState.roleSelection(String phone) = AuthStateRoleSelection;
  const factory AuthState.authenticated(UserModel user) = AuthStateAuthenticated;
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
  const factory AuthState.error(String message) = AuthStateError;

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(String phone)? otpSent,
    T Function(String phone)? roleSelection,
    T Function(UserModel user)? authenticated,
    T Function()? unauthenticated,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    return switch (this) {
      AuthStateInitial() when initial != null => initial(),
      AuthStateLoading() when loading != null => loading(),
      AuthStateOtpSent(:final phone) when otpSent != null => otpSent(phone),
      AuthStateRoleSelection(:final phone) when roleSelection != null => roleSelection(phone),
      AuthStateAuthenticated(:final user) when authenticated != null => authenticated(user),
      AuthStateUnauthenticated() when unauthenticated != null => unauthenticated(),
      AuthStateError(:final message) when error != null => error(message),
      _ => orElse(),
    };
  }

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(String phone) otpSent,
    required T Function(String phone) roleSelection,
    required T Function(UserModel user) authenticated,
    required T Function() unauthenticated,
    required T Function(String message) error,
  }) {
    return switch (this) {
      AuthStateInitial() => initial(),
      AuthStateLoading() => loading(),
      AuthStateOtpSent(:final phone) => otpSent(phone),
      AuthStateRoleSelection(:final phone) => roleSelection(phone),
      AuthStateAuthenticated(:final user) => authenticated(user),
      AuthStateUnauthenticated() => unauthenticated(),
      AuthStateError(:final message) => error(message),
    };
  }
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateOtpSent extends AuthState {
  final String phone;
  const AuthStateOtpSent(this.phone);
}

class AuthStateRoleSelection extends AuthState {
  final String phone;
  const AuthStateRoleSelection(this.phone);
}

class AuthStateAuthenticated extends AuthState {
  final UserModel user;
  const AuthStateAuthenticated(this.user);
}

class AuthStateUnauthenticated extends AuthState {
  const AuthStateUnauthenticated();
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}
