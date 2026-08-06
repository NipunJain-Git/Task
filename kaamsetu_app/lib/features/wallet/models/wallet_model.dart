import 'transaction_model.dart';

class WalletModel {
  final String id;
  final String userId;
  final double balance;
  final List<TransactionModel> transactions;

  WalletModel({
    required this.id,
    required this.userId,
    this.balance = 0.0,
    this.transactions = const [],
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      transactions: (json['transactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
