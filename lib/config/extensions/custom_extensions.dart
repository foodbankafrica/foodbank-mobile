import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../core/cache/cache_key.dart';
import '../../core/cache/cache_store.dart';
import '../../screens/user_account_screens/auth/presentation/screens/signin_screen.dart';

extension EXContext on BuildContext {
  buildError(String content) {
    return showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 0,
          ),
          insetPadding: const EdgeInsets.all(0),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      content,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        pop();
                      },
                      child: const Text("Okay"),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  toast({
    required String content,
  }) {
    return ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: const Duration(milliseconds: 800),
        content: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Text(
            content,
            style: Theme.of(this).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  logout() {
    CacheStore().remove(key: CacheKey.token);
    Future.delayed(const Duration(seconds: 2), () {
      go(SignInScreen.route);
    });
  }
}

extension EXDate on DateTime {
  DateTime getPastDate(int? subYear) {
    final date = DateTime.now();
    if (subYear != null) {
      return DateTime.parse(
        "${date.year - subYear}-${date.month > 10 ? date.month : '0${date.month}'}-${date.day > 10 ? date.day : '0${date.day}'}",
      );
    }
    return DateTime.parse(
      "${date.year}-${date.month > 10 ? date.month : '0${date.month}'}-${date.day > 10 ? date.day : '0${date.day}'}",
    );
  }

  String dateOnly() {
    return toIso8601String().split("T")[0];
  }
}

extension ExString on String {
  capitalize() {
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  capitalizeAll() {
    String newWord = "";
    split(' ').forEach((element) {
      newWord += '${element.capitalize()} ';
    });
    return newWord.trim();
  }

  log() {
    var logger = Logger();
    logger.d(this);
  }

  String writeTo(int toValue) {
    return '${substring(0, length > toValue ? toValue : length)}...';
  }

  String formatAmount() {
    final number = int.tryParse(contains('.') ? split('.')[0] : this);
    if (number != null) {
      final formattedValue = number.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (match) => '${match[1]},');
      return formattedValue;
    }
    return this;
  }
}
