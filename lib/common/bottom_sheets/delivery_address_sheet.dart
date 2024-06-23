import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';

import '../../screens/user_account_screens/home/user_page/cache/address_cache.dart';
import '../../screens/user_account_screens/home/user_page/models/address_model.dart';

class DeliveryAddressBottomSheet extends StatelessWidget {
  const DeliveryAddressBottomSheet({
    super.key,
    required this.onSelected,
  });

  final Function(Address) onSelected;

  @override
  Widget build(BuildContext context) {
    final AddressCache addressCache = AddressCache.instance;
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        const FoodBankBottomSheetAppBar(
          title: 'Delivery Location',
        ),
        const Divider(),
        const SizedBox(height: 10),
        addressCache.addresses.isNotEmpty
            ? Column(
                children: addressCache.addresses.map((address) {
                  return InkWell(
                    onTap: () {
                      onSelected(address);
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
                              color: Colors.grey.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  address.address!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
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
