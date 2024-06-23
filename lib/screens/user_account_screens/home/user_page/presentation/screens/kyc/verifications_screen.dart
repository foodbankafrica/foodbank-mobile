import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';
import 'kyc_success_screen.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = true;

  final TextEditingController bvnController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  initState() {
    setUserDetails();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(
          () {
            isLoading = false;
          },
        );
      },
    );
    super.initState();
  }

  setUserDetails() {
    final user = userCache.user;
    phoneController.text = user.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Verification',
      ),
      body: isLoading
          ? const Center(
              child: CustomIndicator(
                color: Color(0xFFF56630),
              ),
            )
          : SafeArea(
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
                              "Email Address",
                              true,
                              null,
                            ),
                            _verifiedElements(
                              context,
                              "Phone Number",
                              true,
                              null,
                            ),
                            _verifiedElements(
                              context,
                              "User Identity",
                              false,
                              null,
                            ),
                            _verifiedElements(
                              context,
                              "Address",
                              true,
                              null,
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
    Function()? onTap,
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
            onTap: () {
              context.push(KycSuccessScreen.route);
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
