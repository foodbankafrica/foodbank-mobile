import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/models/transaction_model.dart';

class TransactionSummaryScreen extends StatelessWidget {
  static String name = 'transaction-details';
  static String route = '/transaction-details';
  const TransactionSummaryScreen({
    super.key,
    required this.transaction,
  });

  final Transaction transaction;
  @override
  Widget build(BuildContext context) {
    final isDebit = transaction.type == "debit";
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Transaction Details',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(thickness: 0.6),
                  KeyPairValue(
                    'Description',
                    transaction.description!,
                  ),
                  KeyPairValue(
                    'Fee',
                    '₦${transaction.totalCharge!.toString().formatAmount()}',
                  ),
                  KeyPairValue(
                    'Total Amount',
                    "${isDebit ? "-" : "+"}₦${transaction.totalAmount.toString().formatAmount()}",
                  ),
                  KeyPairValue(
                    'Status',
                    transaction.status!,
                  ),
                  KeyPairValue(
                    'Reference',
                    transaction.reference!,
                  ),
                  KeyPairValue(
                    'Channel',
                    transaction.channel!,
                  ),
                  KeyPairValue(
                    'Date',
                    DateTime.parse(transaction.createdAt!).dateOnly(),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text('Report Transaction',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
