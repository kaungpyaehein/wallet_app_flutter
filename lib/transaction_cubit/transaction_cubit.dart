import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_wallet_app/models/transaction_mode.dart';

part 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  TransactionCubit() : super(TransactionInitial());
  final _db = FirebaseFirestore.instance;

  void getTransactionsList() async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    try {
      emit(TransactionLoadingState());
      await getTransactions(currentUser!.email!).then((data) {
        print(data.toString());
        emit(TransactionSuccess(data));
      });
    } catch (e) {
      print("Error");
      print(e);
      emit(TransactionError(e.toString()));
    }
  }

  Future<List<TransactionModel>> getTransactions(String email) async {
    final userDocRef = _db.collection("Users").doc(email);
    final QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await userDocRef.collection("transactions").get();

    final List<TransactionModel> result = querySnapshot.docs
        .map((doc) => TransactionModel(
              doc["amount"] as int?,
              doc["time"] as String?,
              doc["type"] as String?,
              doc["sender"] as String?,
              doc["receiver"] as String?,
            ))
        .toList();
    return result;
  }
}
