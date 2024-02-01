import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:interview_wallet_app/core/route_extensions.dart';
import 'package:interview_wallet_app/core/utils/dimensions.dart';
import 'package:interview_wallet_app/models/transaction_mode.dart';
import 'package:interview_wallet_app/pages/transacion_details.dart';
import 'package:interview_wallet_app/services/auth_service.dart';
import 'package:interview_wallet_app/transaction_cubit/transaction_cubit.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  void initState() {
    context.read<TransactionCubit>().getTransactionsList();

    // FirebaseService()
    //     .getTransactions(FirebaseAuth.instance.currentUser!)
    //     .then((value) {
    //   debugPrint(value[0].type.toString());
    // });
    // FirebaseService().getAllAccounts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Transaction History"),
        ),
        body: BlocBuilder<TransactionCubit, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoadingState) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is TransactionSuccess) {
              return ListView.builder(
                  itemCount: state.transactionsList.length,
                  itemBuilder: (context, index) {
                    final TransactionModel model =
                        state.transactionsList[index];
                    return GestureDetector(
                      onTap: () {
                        context.push(TransactionDetails(
                          model: model,
                        ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(kMarginMedium)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: kMarginMedium, vertical: kMarginLarge),
                        margin: const EdgeInsets.symmetric(
                            vertical: kMarginMedium, horizontal: kMarginMedium),
                        child: model.type == "sent"
                            ? Text(
                                "Sent SGD${model.amount.toString()} to ${model.receiver}",
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: kTextRegular2X,
                                    fontWeight: FontWeight.w500),
                              )
                            : Text(
                                "Successfully received SGD${model.amount.toString()} from ${model.sender}",
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: kTextRegular2X,
                                    fontWeight: FontWeight.w500),
                              ),
                      ),
                    );
                  });
            }
            return Container();
          },
        ));
  }
}
