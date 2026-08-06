import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';
import '../models/wallet_model.dart';
import 'wallet_state.dart';

final walletNotifierProvider = NotifierProvider<WalletNotifier, WalletState>(() {
  return WalletNotifier();
});

class WalletNotifier extends Notifier<WalletState> {
  late Dio _dio;

  @override
  WalletState build() {
    _dio = ref.read(dioProvider);
    Future.microtask(() => fetchWallet());
    return const WalletState.initial();
  }

  Future<void> fetchWallet() async {
    try {
      state = const WalletState.loading();
      final response = await _dio.get<Map<String, dynamic>>('/wallet');
      
      final data = response.data!;
      final wallet = WalletModel.fromJson(data['wallet'] as Map<String, dynamic>);
      final hasPin = data['hasPin'] as bool;
      
      state = WalletState.loaded(wallet, hasPin);
    } catch (e) {
      state = WalletState.error(e.toString());
    }
  }

  Future<void> setupPin(String pin) async {
    try {
      state = const WalletState.loading();
      await _dio.post<Map<String, dynamic>>('/wallet/setup-pin', data: {'pin': pin});
      await fetchWallet();
    } catch (e) {
      state = WalletState.error(e.toString());
    }
  }

  Future<void> addMoney(double amount, {String? referenceId}) async {
    try {
      state = const WalletState.loading();
      await _dio.post<Map<String, dynamic>>('/wallet/add-money', data: {
        'amount': amount,
        if (referenceId != null) 'referenceId': referenceId
      });
      await fetchWallet();
    } catch (e) {
      state = WalletState.error(e.toString());
    }
  }

  Future<void> transferToFamily(double amount, String pin) async {
    try {
      state = const WalletState.loading();
      await _dio.post<Map<String, dynamic>>('/wallet/transfer-family', data: {
        'amount': amount,
        'pin': pin
      });
      await fetchWallet();
    } catch (e) {
      state = WalletState.error(e.toString());
    }
  }
}
