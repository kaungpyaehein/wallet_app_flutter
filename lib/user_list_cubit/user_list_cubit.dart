import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_wallet_app/models/user_model.dart';

part 'user_list_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(UserListInitial());
  final _db = FirebaseFirestore.instance;

  void getAllUsers() async {
    try {
      emit(UserListLoadingState());
      await getAllAccounts().then((data) {
        print(data.toString());
        emit(UserListSuccessState(data));
      });
    } catch (e) {
      print("Error");
      print(e);
      emit(UserListErrorState(e.toString()));
    }
  }

  Future<List<UserModel>> getAllAccounts() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _db.collection("Users").get();

    // Get data from docs and convert map to List
    final allUsers = querySnapshot.docs
        .map((doc) => UserModel(
              doc["name"] as String,
              doc["email"] as String,
              doc["balance"] as int,
              doc["token"] as String,
            ))
        .toList();
    print(allUsers.toString());
    return allUsers;
  }
}
