part of 'transaction_cubit.dart';

@immutable
abstract class TransactionState {}

class TransactionInitial extends TransactionState {}

class TransactionLoadingState extends TransactionState {}

class TransactionSuccess extends TransactionState {
  final List<TransactionModel> transactionsList;

  TransactionSuccess(this.transactionsList);
}

class TransactionError extends TransactionState {
  final String message;

  TransactionError(this.message);
}
