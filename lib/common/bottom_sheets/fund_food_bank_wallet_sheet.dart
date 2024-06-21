import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../screens/user_account_screens/auth/cache/user_cache.dart';
import '../../screens/user_account_screens/home/user_page/presentation/screens/kyc/kyc_screen.dart';

class FundFoodBankWalletBottomSheet extends StatefulWidget {
  const FundFoodBankWalletBottomSheet({super.key});

  @override
  State<FundFoodBankWalletBottomSheet> createState() =>
      _FundFoodBankWalletBottomSheetState();
}

class _FundFoodBankWalletBottomSheetState
    extends State<FundFoodBankWalletBottomSheet> {
  final UserCache userCache = UserCache.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FoodBankBottomSheetAppBar(
          title: 'Fund Your Foodbank Wallet',
        ),
        const Divider(),
        const SizedBox(height: 10),
        if (userCache.virtualAccounts.isNotEmpty) ...{
          ...userCache.virtualAccounts.map(
            (ac) => UserAccountNumber(
              bankName: ac.bankName,
              accountNumber: ac.accountNumber,
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                RichText(
                  text: TextSpan(
                    text: "Make a bank transfer to your ",
                    children: [
                      TextSpan(
                        text: "account number above.",
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: const Color(0xFF475467),
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const TextSpan(
                          text: " It will reflects immediately on your "),
                      TextSpan(
                        text: "foodbank wallet",
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: const Color(0xFF475467),
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                    ],
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: const Color(0xFF475467),
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onTap: () {
                    context.pop();
                  },
                  text: 'Close',
                ),
              ],
            ),
          )
        } else ...{
          NotFound(
            message: userCache.kyc.bvn != null
                ? "Verifying Your Account"
                : "Kindly Complete Your Kyc.",
            onTap: () {
              context.push(KycScreen.route);
            },
            buttonText: "Verify Identity",
            showButton: userCache.kyc.bvn == null,
          ),
          const SizedBox(height: 50),
        }
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
