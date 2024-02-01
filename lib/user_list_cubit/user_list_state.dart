part of 'user_list_cubit.dart';

@immutable
abstract class UserListState {}

class UserListInitial extends UserListState {}

class UserListLoadingState extends UserListState {}

class UserListSuccessState extends UserListState {
  final List<UserModel> userList;

  UserListSuccessState(this.userList);
}

class UserListErrorState extends UserListState {
  final String message;

  UserListErrorState(this.message);
}
