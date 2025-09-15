/// Transaction model for representing transaction data
///
/// This model represents a transaction with all necessary information
/// for display in transaction cards and lists.
library;

import 'money.dart';

/// Transaction status enumeration
enum TransactionStatus {
  /// Transaction is pending
  pending,

  /// Transaction completed successfully
  success,

  /// Transaction failed
  failed,

  /// Transaction was reversed
  reversed,
}

/// Transaction model representing a financial transaction
class TransactionModel {
  /// Creates a transaction model
  ///
  /// [id] - Unique identifier for the transaction
  /// [title] - Main title/description of the transaction
  /// [subtitle] - Additional details or description
  /// [amount] - The monetary amount of the transaction
  /// [status] - The current status of the transaction
  /// [icon] - Optional icon to display with the transaction
  /// [timestamp] - When the transaction occurred
  /// [reference] - Optional reference number or ID
  const TransactionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    this.icon,
    this.timestamp,
    this.reference,
  });

  /// Unique identifier for the transaction
  final String id;

  /// Main title/description of the transaction
  final String title;

  /// Additional details or description
  final String subtitle;

  /// The monetary amount of the transaction
  final Money amount;

  /// The current status of the transaction
  final TransactionStatus status;

  /// Optional icon to display with the transaction
  final String? icon;

  /// When the transaction occurred
  final DateTime? timestamp;

  /// Optional reference number or ID
  final String? reference;

  /// Creates a copy of this transaction with updated values
  TransactionModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    Money? amount,
    TransactionStatus? status,
    String? icon,
    DateTime? timestamp,
    String? reference,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      icon: icon ?? this.icon,
      timestamp: timestamp ?? this.timestamp,
      reference: reference ?? this.reference,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TransactionModel &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.amount == amount &&
        other.status == status &&
        other.icon == icon &&
        other.timestamp == timestamp &&
        other.reference == reference;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        subtitle.hashCode ^
        amount.hashCode ^
        status.hashCode ^
        icon.hashCode ^
        timestamp.hashCode ^
        reference.hashCode;
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, title: $title, subtitle: $subtitle, '
        'amount: $amount, status: $status, icon: $icon, '
        'timestamp: $timestamp, reference: $reference)';
  }
}

