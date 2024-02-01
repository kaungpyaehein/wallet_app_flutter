class UserModel {
  final String? name;
  final String? email;
  final int? balance;
  final String? token;

  UserModel(this.name, this.email, this.balance, this.token);
  toJson() {
    return {"name": name, "email": email, "balance": balance, "token": token};
  }
}
