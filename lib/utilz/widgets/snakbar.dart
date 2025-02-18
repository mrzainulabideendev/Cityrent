


import 'package:car_rent/utilz/contants/export.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snaki(
    {required context, required String msg, bool isErrorColor = false}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        duration: const Duration(milliseconds: 3000),
        backgroundColor:
            isErrorColor ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        content: Text(msg,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white))),);
}