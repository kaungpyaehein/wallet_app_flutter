import 'package:intl/intl.dart';

String formatNumber(int value) {
  final formatter = NumberFormat('#,###');
  return formatter.format(value).toString();
}

String formatDateNow() {
  DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd, MMM, yyyy');
  final String formattedDate = formatter.format(now);
  print(formattedDate);
  return formattedDate.toString();
}
