import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_wallet_app/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void getUserInfo(User user) async {
    try {
      emit(UserLoadingState());

      // Add a delay of 2 seconds before fetching userDoc
      await Future.delayed(const Duration(seconds: 1));

      final userDoc =
          FirebaseFirestore.instance.collection("Users").doc(user.email);
      final snapshot = await userDoc.get();

      if (snapshot.exists) {
        final data = snapshot.data();
        if (data != null) {
          final userModel = UserModel(
            data["name"] ?? "", // Handle null for "name"
            data["email"] ?? "", // Handle null for "email"
            data["balance"] ??
                0, // Handle null for "balance" with a default value
            data["token"] ?? "", // Handle null for "token"
          );
          emit(UserSuccessState(userModel));
        } else {
          // If data is null, stay in loading state until a valid data is retrieved
          emit(UserLoadingState());
        }
      } else {
        emit(UserErrorState("User document does not exist."));
      }
    } catch (e) {
      print("Error during getUserInfo: $e");
      emit(UserErrorState("An unexpected error occurred."));
    }
  }
}
