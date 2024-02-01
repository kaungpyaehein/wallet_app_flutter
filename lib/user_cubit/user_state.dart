part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserLoadingState extends UserState {}

class UserSuccessState extends UserState {
  final UserModel model;

  UserSuccessState(this.model);
}

class UserErrorState extends UserState {
  final String message;

  UserErrorState(this.message);
}
