import '../models/wallet_model.dart';

sealed class WalletState {
  const WalletState();

  const factory WalletState.initial() = WalletStateInitial;
  const factory WalletState.loading() = WalletStateLoading;
  const factory WalletState.loaded(WalletModel wallet, bool hasPin) = WalletStateLoaded;
  const factory WalletState.error(String message) = WalletStateError;

  T maybeWhen<T>({
    T Function()? initial,
    T Function()? loading,
    T Function(WalletModel wallet, bool hasPin)? loaded,
    T Function(String message)? error,
    required T Function() orElse,
  }) {
    return switch (this) {
      WalletStateInitial() when initial != null => initial(),
      WalletStateLoading() when loading != null => loading(),
      WalletStateLoaded(:final wallet, :final hasPin) when loaded != null => loaded(wallet, hasPin),
      WalletStateError(:final message) when error != null => error(message),
      _ => orElse(),
    };
  }

  T when<T>({
    required T Function() initial,
    required T Function() loading,
    required T Function(WalletModel wallet, bool hasPin) loaded,
    required T Function(String message) error,
  }) {
    return switch (this) {
      WalletStateInitial() => initial(),
      WalletStateLoading() => loading(),
      WalletStateLoaded(:final wallet, :final hasPin) => loaded(wallet, hasPin),
      WalletStateError(:final message) => error(message),
    };
  }
}

class WalletStateInitial extends WalletState {
  const WalletStateInitial();
}

class WalletStateLoading extends WalletState {
  const WalletStateLoading();
}

class WalletStateLoaded extends WalletState {
  final WalletModel wallet;
  final bool hasPin;
  const WalletStateLoaded(this.wallet, this.hasPin);
}

class WalletStateError extends WalletState {
  final String message;
  const WalletStateError(this.message);
}
