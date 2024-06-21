import 'package:flutter/material.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';

Future<String> pickDateOfBirth(BuildContext context) async {
  final selectedDate = await showDatePicker(
    context: context,
    firstDate: DateTime.now().getPastDate(70),
    lastDate: DateTime.now().getPastDate(18),
    currentDate: DateTime.now().getPastDate(18),
  );
  if (selectedDate != null) {
    return selectedDate.dateOnly();
  }
  return "";
}
