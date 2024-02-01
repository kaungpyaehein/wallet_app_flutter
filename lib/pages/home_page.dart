import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:interview_wallet_app/core/route_extensions.dart';
import 'package:interview_wallet_app/core/utils/dimensions.dart';
import 'package:interview_wallet_app/core/utils/functions.dart';
import 'package:interview_wallet_app/pages/choose_account_page.dart';
import 'package:interview_wallet_app/pages/history_page.dart';
import 'package:interview_wallet_app/pages/notifications_page.dart';
import 'package:interview_wallet_app/services/auth_service.dart';
import '../core/utils/colors.dart';
import '../user_cubit/user_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<UserCubit>().getUserInfo(FirebaseAuth.instance.currentUser!);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: kMarginMedium),
                child: Row(
                  children: [
                    const Text(
                      "Welcome back,",
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: kTextRegular3X,
                          fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text("Log out"),
                              content: const Text(
                                  "Are you sure you want to log out?"),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      context.pop();
                                    },
                                    child: const Text("Cancel")),
                                TextButton(
                                    onPressed: () {
                                      GoogleSignIn()
                                          .disconnect()
                                          .whenComplete(() {
                                        setState(() {
                                          FirebaseAuth.instance.signOut();
                                        });
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: const Text(
                                      "Log Out",
                                      style: TextStyle(color: Colors.red),
                                    )),
                              ],
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(kMarginSmall),
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius:
                                  BorderRadius.circular(kMarginXXLarge3)),
                          child: const Icon(
                            Icons.power_settings_new_sharp,
                            size: kMarginXLarge,
                          ),
                        ))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: kMarginMedium),
                child: Text(
                  FirebaseAuth.instance.currentUser!.displayName.toString(),
                  style: const TextStyle(
                      color: kTextColor,
                      fontWeight: FontWeight.w300,
                      fontSize: kTextHeading1X),
                ),
              ),
              const SizedBox(
                height: kMarginMedium3,
              ),
              const MemberCardView(),
              const SizedBox(
                height: kMarginXLarge,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ActionButtonView(
                    onTap: () {
                      context.push(ChooseAccountPage(
                        senderMail: FirebaseAuth.instance.currentUser!.email!,
                      ));
                    },
                    label: "Transfer",
                    icon: Icons.arrow_circle_up_sharp,
                  ),
                  ActionButtonView(
                    onTap: () {
                      context.push(const HistoryPage());
                    },
                    label: "History",
                    icon: Icons.sticky_note_2_outlined,
                  ),
                  ActionButtonView(
                    onTap: () {
                      context.push(const NotificationPage());
                    },
                    label: "Noti",
                    icon: Icons.notifications_outlined,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ActionButtonView extends StatelessWidget {
  final String label;
  final IconData icon;
  final void Function() onTap;
  const ActionButtonView({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
            color: Colors.grey.shade50,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 2,
                blurRadius: 3,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            // border: Border.all(color: kPrimaryHalfColor),
            borderRadius: BorderRadius.circular(kMarginMedium3)),
        padding: const EdgeInsets.all(kMarginMedium2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Icon(
              icon,
              color: kPrimaryColor,
              size: 60,
            ),
            Text(
              label,
              style: const TextStyle(
                  color: kTextColor,
                  fontSize: kTextRegular2X,
                  fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class MemberCardView extends StatefulWidget {
  const MemberCardView({
    super.key,
  });

  @override
  State<MemberCardView> createState() => _MemberCardViewState();
}

class _MemberCardViewState extends State<MemberCardView> {
  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.zero,
      height: MediaQuery.of(context).size.width * 0.63 - 48,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: kMarginLarge, vertical: kMarginMedium3),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(kMarginLarge),
          gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(147, 39, 143, 1),
                Color.fromRGBO(41, 171, 226, 1)
              ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //logo
          RichText(
              text: const TextSpan(children: [
            TextSpan(
                text: "Walle",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: kTextHeading2X * 1.6,
                )),
            TextSpan(
                text: "To",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: kTextHeading2X * 1.6,
                )),
          ])),
          Align(
            alignment: Alignment.centerRight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Current Balance",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: kTextRegular3X,
                        fontWeight: FontWeight.w400)),
                const SizedBox(
                  height: kMarginSmall,
                ),
                BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                  if (state is UserLoadingState) {
                    return const Text(".....",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: kTextHeading1X,
                            fontWeight: FontWeight.bold));
                  } else if (state is UserErrorState) {
                    return Text(state.message);
                  } else if (state is UserSuccessState) {
                    final int? balance = state.model.balance;

                    print(state.model.balance.toString());
                    return Text("SGD ${formatNumber(balance!)}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: kTextHeading1X,
                            fontWeight: FontWeight.bold));
                  }
                  return const Text("error");
                })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
