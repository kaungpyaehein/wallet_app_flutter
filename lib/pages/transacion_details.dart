import 'package:flutter/material.dart';
import 'package:interview_wallet_app/core/utils/dimensions.dart';
import 'package:interview_wallet_app/models/transaction_mode.dart';

class TransactionDetails extends StatelessWidget {
  final TransactionModel model;
  const TransactionDetails({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LabelAndDataView(label: "Sender", data: model.sender ?? ""),
            const SizedBox(
              height: kMarginMedium,
            ),
            LabelAndDataView(label: "Recipient", data: model.receiver ?? ""),
            const SizedBox(
              height: kMarginMedium,
            ),
            LabelAndDataView(
                label: "Transfer Amount",
                data: "SGD ${model.amount.toString()}"),
          ],
        ),
      ),
    );
  }
}

class LabelAndDataView extends StatelessWidget {
  final String label;
  final String data;
  const LabelAndDataView({super.key, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: kTextRegular2X),
        ),
        const Spacer(),
        Text(
          data,
          style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: kTextRegular2X),
        )
      ],
    );
  }
}
