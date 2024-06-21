import 'package:flutter/material.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/screens/user_account_screens/my_bag_screen.dart';
import 'package:go_router/go_router.dart';

import '../../screens/user_account_screens/auth/cache/user_cache.dart';

class SendAsAGiftBottomSheet extends StatefulWidget {
  const SendAsAGiftBottomSheet({
    super.key,
    required this.senderAndRReceiver,
    required this.to,
    required this.toPhone,
    required this.address,
    required this.isPickup,
  });
  final Function(String, String, String, String) senderAndRReceiver;
  final String to, toPhone, address;
  final bool isPickup;

  @override
  State<SendAsAGiftBottomSheet> createState() => _SendAsAGiftBottomSheetState();
}

class _SendAsAGiftBottomSheetState extends State<SendAsAGiftBottomSheet> {
  final UserCache userCache = UserCache.instance;
  final TextEditingController fromController = TextEditingController();

  final TextEditingController toController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    fromController.text =
        '${userCache.user.firstName} ${userCache.user.lastName}';
    toController.text = widget.to;
    phoneController.text = widget.toPhone;
    addressController.text = widget.address;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FoodBankBottomSheetAppBar(
          title: '',
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'From',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 5),
              FoodBankTextField(
                controller: fromController,
                readOnly: true,
              ),
              const SizedBox(height: 10),
              Text(
                'To',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 5),
              FoodBankTextField(
                controller: toController,
                hintText: "Enter Full Name",
              ),
              const SizedBox(height: 10),
              Text(
                'Phone Number',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 5),
              FoodBankTextField(
                controller: phoneController,
                keyboardType: TextInputType.number,
                maxLength: 11,
                hintText: "Enter Recipient Phone Number",
              ),
              if (!widget.isPickup) ...{
                const SizedBox(height: 15),
                DeliveryAddressContent(
                  address: addressController.text,
                  onAddAddress: (String address, lng, lat) {
                    setState(
                      () {
                        addressController.text = address;
                      },
                    );
                  },
                  horizontalPadding: 0,
                ),
              },
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.senderAndRReceiver(
                      fromController.text,
                      toController.text,
                      phoneController.text,
                      addressController.text,
                    );
                    context.pop();
                  },
                  child: const Text('Send'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        )
      ],
    );
  }
}
