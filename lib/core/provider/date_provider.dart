import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateProvider = StateNotifierProvider<Date, DateTime>((ref) {
  return Date();
});

class Date extends StateNotifier<DateTime> {
  Date() : super(DateTime.now());

  void avantDerSem() {
    state = DateTime.now().add(const Duration(days: -14));
  }

  void semDer() {
    state = DateTime.now().add(const Duration(days: -7));
  }

  void cetteSem() {
    state = DateTime.now();
  }

  void semProc() {
    state = DateTime.now().add(const Duration(days: 7));
  }

  void selectedDate(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    ).then((value) {
      state = value!;
    });
  }
}
