// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/bottom_sheets/update_avatar_sheet.dart';
import 'package:food_bank/common/donor_bottom_nav_bar.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/core/cache/cache_key.dart';
import 'package:food_bank/core/cache/cache_store.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/delivery_address.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/edit_profile_info_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/faq_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/release_notes_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/wallet_page.dart';
import 'package:go_router/go_router.dart';

import '../../../../auth/cache/user_cache.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/screens/signin_screen.dart';
import 'change_password_page.dart';
import 'kyc/kyc_screen.dart';
import 'kyc/verifications_screen.dart';
import 'support_screen.dart';

class UserPage extends StatefulWidget {
  static String name = 'user-page';
  static String route = '/user-page';
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Future<void> onRefresh() async {
    context.read<AuthBloc>().add(GetMeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileHeader(
                  onSwitch: () {
                    context.go(DonorFoodBankBottomNavigator.route);
                  },
                  switchTo: "Donor",
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
                    context.push(DeliveryAddressPage.route);
                  },
                  icon: 'location-icon',
                  title: 'Delivery Address',
                  subtitle: 'Manage your delivery address',
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
                    context.push(VerificationsScreen.route);
                  },
                  icon: 'approve',
                  title: 'Verify Identity',
                  subtitle: 'Verify your account',
                ),
                const Divider(thickness: 0.5),
                UserOptions(
                  onTap: () {
                    context.push(ChangePasswordPage.route);
                  },
                  icon: 'approve',
                  title: 'Security',
                  subtitle: 'Change your password',
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
      ),
    );
  }
}

class ProfileHeader extends StatefulWidget {
  const ProfileHeader({
    super.key,
    this.bg,
    required this.onSwitch,
    required this.switchTo,
    this.isDonor = false,
  });
  final Function() onSwitch;
  final Color? bg;
  final String switchTo;
  final bool isDonor;
  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final UserCache userCache = UserCache.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(
            16,
          ),
        ),
        color: widget.bg ?? const Color(0xFFFFECE5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: widget.onSwitch,
                    child: Container(
                      height: 24,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF000000),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Switch to ${widget.switchTo} ',
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      fontSize: 12,
                                      color: const Color(0xFFFFFFFF),
                                    ),
                          ),
                          SvgPicture.asset(
                            'assets/icons/switch_icon.svg',
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    useSafeArea: true,
                    builder: (context) {
                      return const UpdateAvatarBottomSheet();
                    });
              },
              child: CircleAvatar(
                radius: 52,
                backgroundImage: NetworkImage(
                  userCache.user.avatar ??
                      "https://firebasestorage.googleapis.com/v0/b/amam-appilication-store.appspot.com/o/avatar%2Favatar-1.png?alt=media&token=e39f17aa-d4e4-4d1d-9cb5-8adf712fab04",
                ),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              '${userCache.user.firstName} ${userCache.user.lastName}'
                  .capitalizeAll(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            if (widget.isDonor) ...{
              Container(
                height: 24,
                width: 88,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFFFECE5),
                ),
                child: const Center(child: Text('Company')),
              ),
              const SizedBox(height: 10),
            },
            const AvailableBalance(),
          ],
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
