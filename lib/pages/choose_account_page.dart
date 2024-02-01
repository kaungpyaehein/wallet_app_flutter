import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_wallet_app/core/route_extensions.dart';
import 'package:interview_wallet_app/core/utils/colors.dart';
import 'package:interview_wallet_app/core/utils/dimensions.dart';
import 'package:interview_wallet_app/models/user_model.dart';
import 'package:interview_wallet_app/pages/transfer_page.dart';
import 'package:interview_wallet_app/services/auth_service.dart';
import 'package:interview_wallet_app/user_list_cubit/user_list_cubit.dart';

class ChooseAccountPage extends StatefulWidget {
  final String senderMail;
  const ChooseAccountPage({super.key, required this.senderMail});

  @override
  State<ChooseAccountPage> createState() => _ChooseAccountPageState();
}

class _ChooseAccountPageState extends State<ChooseAccountPage> {
  @override
  void initState() {
    context.read<UserListCubit>().getAllUsers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Choose Account to Transfer"),
        ),
        body: BlocBuilder<UserListCubit, UserListState>(
            builder: (context, state) {
          if (state is UserListLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is UserListSuccessState) {
            return ListView.builder(
              itemCount: state.userList.length,
              itemBuilder: (context, index) {
                final UserModel user = state.userList[index];
                return GestureDetector(
                  onTap: () {
                    if (widget.senderMail != user.email) {
                      context.push(TransferPage(
                        senderMail: widget.senderMail,
                        receiverMail: user.email ?? "",
                        token: user.token ?? "",
                      ));
                    }
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: widget.senderMail == user.email
                              ? kPrimaryHalfColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(kMarginMedium3)),
                      margin: const EdgeInsets.symmetric(
                          horizontal: kMarginMedium3, vertical: kMarginSmall),
                      padding: const EdgeInsets.symmetric(
                          horizontal: kMarginMedium3, vertical: kMarginMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name ?? "",
                            style: const TextStyle(
                                color: kTextColor,
                                fontWeight: FontWeight.w500,
                                fontSize: kTextRegular3X),
                          ),
                          Text(user.email ?? "",
                              style: const TextStyle(
                                  color: kTextColor,
                                  fontWeight: FontWeight.w400,
                                  fontSize: kTextRegular2X)),
                        ],
                      )),
                );
              },
            );
          }
          return Container();
        }));
  }
}
