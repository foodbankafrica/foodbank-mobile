import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../screens/user_account_screens/home/home_page/models/buisness_model.dart';

class DeliveryLocationSheet extends StatelessWidget {
  const DeliveryLocationSheet({
    super.key,
    required this.deliveryLocation,
    required this.onSelected,
  });
  final List<DeliveryLocation> deliveryLocation;
  final Function(String, String, String) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        const FoodBankBottomSheetAppBar(
          title: 'Delivery Location',
        ),
        const Divider(),
        const SizedBox(height: 10),
        deliveryLocation.isNotEmpty
            ? Column(
                children: deliveryLocation.map((location) {
                  return InkWell(
                    onTap: () {
                      onSelected(
                        location.name!,
                        location.deliveryCost,
                        location.id.toString(),
                      );
                      context.pop();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: (true ? Colors.green : Colors.black45)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location.name!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  "Delivery fee N${location.deliveryCost}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            : Text(
                "No Delivery address",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
              ),
      ],
    );
  }
}

class UserAccountNumber extends StatelessWidget {
  const UserAccountNumber({
    super.key,
    this.bankName,
    this.accountNumber,
  });
  final String? bankName, accountNumber;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFF9FAFB)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$bankName:',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: const Color(0xFF475467), fontSize: 12),
                ),
                const SizedBox(height: 10),
                Text(
                  '$accountNumber',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: const Color(0xFF101928),
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            InkWell(
                onTap: () {
                  FlutterClipboard.copy(accountNumber!).then(
                    (value) => context.toast(content: "Copied!"),
                  );
                },
                child: SvgPicture.asset('assets/icons/copy.svg')),
          ],
        ),
      ),
    );
  }
}
