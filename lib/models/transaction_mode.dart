class TransactionModel {
  int? amount;
  String? time;
  String? type;
  String? sender;
  String? receiver;
  TransactionModel(
      this.amount, this.time, this.type, this.sender, this.receiver);
  toJson() {
    return {
      "amount": amount,
      "time": time,
      "type": type,
      "sender": sender,
      "receiver": receiver,
    };
  }
}
