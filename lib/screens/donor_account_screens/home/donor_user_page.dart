// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/user_bottom_nav_bar.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/edit_profile_info_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/faq_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/release_notes_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/user_user_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/wallet_page.dart';
import 'package:go_router/go_router.dart';

import '../../../core/cache/cache_key.dart';
import '../../../core/cache/cache_store.dart';
import '../../user_account_screens/auth/presentation/screens/signin_screen.dart';
import '../../user_account_screens/home/user_page/presentation/screens/delivery_address.dart';
import '../../user_account_screens/home/user_page/presentation/screens/kyc/kyc_screen.dart';
import '../../user_account_screens/home/user_page/presentation/screens/kyc/verifications_screen.dart';
import '../../user_account_screens/home/user_page/presentation/screens/support_screen.dart';

class DonorUserPage extends StatelessWidget {
  static String name = 'donor-user-page';
  static String route = '/donor-user-page';
  const DonorUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileHeader(
                onSwitch: () {
                  context.go(UserFoodBankBottomNavigator.route);
                },
                switchTo: "Recipient",
                bg: const Color(0xFFE7F6EC),
                isDonor: true,
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Our Support',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 0.5),
              UserOptions(
                onTap: () {
                  context.push(SupportScreen.route);
                },
                icon: 'info-circle',
                title: 'Help And Support',
                subtitle: 'Need Help?',
              ),
              const Divider(thickness: 0.5),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Personal Info',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 0.5),
              UserOptions(
                onTap: () {
                  context.push(WalletPage.route);
                },
                icon: 'brown_wallet',
                title: 'Wallet',
                subtitle: 'Manage your wallet',
              ),
              const Divider(thickness: 0.5),
              UserOptions(
                onTap: () {
                  context.push(EditProfileInfoPage.route);
                },
                icon: 'profile',
                title: 'Profile Info',
                subtitle: 'Manage your personal info',
              ),
              const Divider(thickness: 0.5),
              UserOptions(
                onTap: () {
                  context.push(DeliveryAddressPage.route);
                },
                icon: 'location-icon',
                title: 'Delivery Address',
                subtitle: 'Manage your delivery address',
              ),
              const Divider(thickness: 0.5),
              UserOptions(
                onTap: () {
                  context.push(VerificationsScreen.route);
                },
                icon: 'approve',
                title: 'Verify Identity',
                subtitle: 'Verify your account',
              ),
              const Divider(thickness: 0.5),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Other',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(thickness: 0.5),
              UserOptions(
                onTap: () {
                  context.push(ReleaseNotesPage.route);
                },
                icon: 'releases_icon',
                title: 'Release notes',
                subtitle: 'Manage your wallet',
              ),
              const Divider(thickness: 0.5),
              UserOptions(
                onTap: () {
                  context.push(FAQPage.route);
                },
                icon: 'profile',
                title: 'FAQ',
              ),
              const Divider(thickness: 0.5),
              UserOptions(
                onTap: () {
                  CacheStore().remove(key: CacheKey.token);
                  Future.delayed(const Duration(seconds: 2), () {
                    context.go(SignInScreen.route);
                  });
                },
                icon: 'logout',
                title: 'Logout',
              ),
              const Divider(thickness: 0.5),
            ],
          ),
        ),
      ),
    );
  }
}

class UserOptions extends StatelessWidget {
  const UserOptions({
    super.key,
    this.icon,
    this.title,
    this.subtitle,
    this.onTap,
  });

  final String? icon, title, subtitle;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      enableFeedback: false,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFFFECE5)),
                  child: SvgPicture.asset(
                    'assets/icons/$icon.svg',
                    color: const Color(0xFFF56630),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (subtitle != null) ...{
                      const SizedBox(height: 5),
                      Text(
                        '$subtitle',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF98A2B3)),
                      ),
                    },
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF98A2B3),
            ),
          ],
        ),
      ),
    );
  }
}
