import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/kyc/kyc_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../../../auth/cache/user_cache.dart';

class VerificationsScreen extends StatefulWidget {
  static String name = 'verifications';
  static String route = '/verifications';
  const VerificationsScreen({super.key});

  @override
  State<VerificationsScreen> createState() => _VerificationsScreenState();
}

class _VerificationsScreenState extends State<VerificationsScreen> {
  final UserCache userCache = UserCache.instance;

  final TextEditingController bvnController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final kyc = userCache.kyc;
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Verification',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18.0,
              left: 18.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete your verification to enjoy all the features of the app.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _verifiedElements(
                        context,
                        "Phone Number",
                        kyc.phoneVerified == 1,
                      ),
                      _verifiedElements(
                        context,
                        "BVN",
                        kyc.bvnVerified == 1,
                      ),
                      _verifiedElements(
                        context,
                        "User Identity",
                        kyc.verified == 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _verifiedElements(
    BuildContext context,
    String title,
    bool verified,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          InkWell(
            onTap: verified
                ? null
                : () {
                    context.push(KycScreen.route);
                  },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: (verified ? Colors.green : Colors.grey).withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                verified ? 'Verified' : "Unverified",
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      color: verified ? Colors.green : Colors.grey,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
