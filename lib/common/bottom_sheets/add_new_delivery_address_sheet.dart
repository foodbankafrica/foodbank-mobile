import 'package:flutter/material.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/debouncer.dart';
import '../../screens/user_account_screens/auth/presentation/screens/select_avatar_screen.dart';

class AddNewDeliveryAddressBottomSheet extends StatefulWidget {
  const AddNewDeliveryAddressBottomSheet({super.key});

  @override
  State<AddNewDeliveryAddressBottomSheet> createState() =>
      _AddNewDeliveryAddressBottomSheetState();
}

class _AddNewDeliveryAddressBottomSheetState
    extends State<AddNewDeliveryAddressBottomSheet> {
  late Debouncer _debouncer;

  @override
  void initState() {
    _debouncer = Debouncer(
      const Duration(milliseconds: 500),
    );
    super.initState();
  }

  void onSearchChanged(String? searchTerm) {
    if (searchTerm.toString().isEmpty) return;
    _debouncer.call(() {
      print(searchTerm);
    });
  }

  @override
  void dispose() {
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const FoodBankBottomSheetAppBar(
          title: 'Add New  Delivery Address',
        ),
        const Divider(),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Address',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 5),
              const FoodBankSearchTextField(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.push(SelectAvatarScreen.route);
                  context.pop();
                },
                child: const Text('Add'),
              ),
            ],
          ),
        )
      ],
    );
  }
}
