import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/screens/user_home_page.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/screens/track_screen.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/cache/address_cache.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/models/address_model.dart';
import 'package:go_router/go_router.dart';

import 'enter_delivery_address_sheet.dart';

class GuessTrackOrOrderSheet extends StatefulWidget {
  const GuessTrackOrOrderSheet({
    super.key,
  });

  @override
  State<GuessTrackOrOrderSheet> createState() => _GuessTrackOrOrderSheetState();
}

class _GuessTrackOrOrderSheetState extends State<GuessTrackOrOrderSheet> {
  final TextEditingController addressController = TextEditingController();
  AddressCache addressCache = AddressCache.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FoodBankBottomSheetAppBar(
          title: 'Continuing as Guest',
        ),
        const Divider(),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            context.push(TrackOrderScreen.route);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF9FAFB),
              border: const Border(
                bottom: BorderSide(
                  color: Colors.grey,
                  width: 0.8,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Track an order',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: const Color(0xFF475467), fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        InkWell(
          onTap: () {
            context.pop();
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              useSafeArea: true,
              builder: (context) {
                return EnterDeliveryAddressBottomSheet(
                  controller: addressController,
                  onAdd: (lat, lng) {
                    print(lng);
                    print(lat);
                    addressCache.addresses = [
                      Address(
                        address: addressController.text,
                        latitude: lat,
                        longitude: lng,
                      ),
                    ];
                    context.go(
                      HomePage.route,
                      extra: {
                        "address": addressController.text,
                        "latitude": lat.toString(),
                        "longitude": lng.toString(),
                      },
                    );
                  },
                );
              },
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFF9FAFB),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Make an order',
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(color: const Color(0xFF475467), fontSize: 16),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
