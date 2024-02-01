import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_wallet_app/core/utils/colors.dart';
import 'package:interview_wallet_app/core/utils/dimensions.dart';
import 'package:interview_wallet_app/pages/auth_page.dart';
import 'package:interview_wallet_app/pages/home_page.dart';
import 'package:interview_wallet_app/pages/page0.dart';
import 'package:interview_wallet_app/user_cubit/user_cubit.dart';

import '../services/auth_service.dart';
import '../user_list_cubit/user_list_cubit.dart';

class TransferPage extends StatefulWidget {
  final String senderMail;
  final String receiverMail;
  final String token;
  const TransferPage(
      {super.key, required this.senderMail, required this.receiverMail, required this.token});

  @override
  State<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends State<TransferPage> {
  FocusNode numberFocus = FocusNode();
  TextEditingController amountController = TextEditingController();

  @override
  void didChangeDependencies() {
    numberFocus.requestFocus();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    context.read<UserCubit>().getUserInfo(FirebaseAuth.instance.currentUser!);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
    numberFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transfer To"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
        child: Column(
          children: [
            const SizedBox(
              height: kMarginMedium4,
            ),
            Text(widget.receiverMail,
                style: const TextStyle(
                    color: kPrimaryColor,
                    fontSize: kTextRegular3X,
                    fontWeight: FontWeight.w500)),
            const SizedBox(
              height: kMarginLarge,
            ),
            TextField(
              controller: amountController,
              style: const TextStyle(
                  color: kTextColor,
                  fontWeight: FontWeight.w500,
                  fontSize: kTextRegular2X),
              focusNode: numberFocus,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "Enter amount to transfer",
                  hintStyle: TextStyle(
                      color: kTextColor.withOpacity(0.5),
                      fontSize: kTextRegular2X,
                      fontWeight: FontWeight.w500),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kMarginMedium2),
                      borderSide: const BorderSide(color: kPrimaryHalfColor)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(kMarginMedium2),
                      borderSide: const BorderSide(color: kPrimaryHalfColor))),
            ),
            const SizedBox(
              height: kMarginMedium4,
            ),
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state is UserLoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is UserSuccessState) {
                  return ElevatedButton(
                      onPressed: () {
                        FirebaseService()
                            .transfer(
                                myBalance: state.model.balance!,
                                sender: widget.senderMail,
                                recipient: widget.receiverMail,
                                transferAmount:
                                    int.parse(amountController.text.trim()),
                                time: DateTime.now().toString())
                            .then((value) {
                          if (value == "Success") {
                            FirebaseService().sendPushNotification(
                                body: "Money received!",
                                title: "Successfully received${amountController.text.toString()} from ${widget.senderMail}",
                                token: widget.token,);
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  alignment: Alignment.center,
                                  content: Text(
                                    "Successfully transferred ${amountController.text.toString()} to ${widget.receiverMail}.",
                                    style: const TextStyle(color: Colors.green),
                                  )),
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => const AlertDialog(
                                  alignment: Alignment.center,
                                  content: Text(
                                    "Failed to transfer selected amount. Try again!",
                                    style: TextStyle(color: Colors.red),
                                  )),
                            );
                          }
                        }).whenComplete(() {
                          Future.delayed(const Duration(milliseconds: 1000))
                              .then((value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const PageO(),
                                  ),
                                  (route) => route.isFirst));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(kMarginMedium))),
                      child: const Text(
                        "Transfer",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: kTextRegular2X),
                      ));
                } else if (state is UserErrorState) {
                  return Text(state.message.toString());
                }
                return Container();
              },
            ),
            const SizedBox(
              height: kMarginLarge,
            ),
          ],
        ),
      ),
    );
  }
}
