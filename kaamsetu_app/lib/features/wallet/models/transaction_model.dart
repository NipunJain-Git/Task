class TransactionModel {
  final String id;
  final String walletId;
  final double amount;
  final String type;
  final String? description;
  final String receiptNumber;
  final String? referenceId;
  final DateTime createdAt;

  TransactionModel({
    required this.id,
    required this.walletId,
    required this.amount,
    required this.type,
    this.description,
    required this.receiptNumber,
    this.referenceId,
    required this.createdAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      walletId: json['walletId'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: json['type'] as String,
      description: json['description'] as String?,
      receiptNumber: json['receiptNumber'] as String,
      referenceId: json['referenceId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
