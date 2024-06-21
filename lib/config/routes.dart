import 'package:flutter/widgets.dart';
import 'package:food_bank/common/donor_bottom_nav_bar.dart';
import 'package:food_bank/common/user_bottom_nav_bar.dart';
import 'package:food_bank/screens/donor_account_screens/donation_created_screen.dart';
import 'package:food_bank/screens/donor_account_screens/donor_checkout_screen.dart';
import 'package:food_bank/screens/donor_account_screens/donor_my_bag_screen.dart';
import 'package:food_bank/screens/donor_account_screens/donor_hold_on_tight_screen.dart';
import 'package:food_bank/screens/user_account_screens/auth/presentation/screens/forget_password_screen.dart';
import 'package:food_bank/screens/user_account_screens/hold_on_tight_screen.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/models/transaction_model.dart';
import 'package:food_bank/screens/user_account_screens/home/user_donor_page.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/screens/user_home_page.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/screens/user_my_bag_page.dart';
import 'package:food_bank/screens/user_account_screens/home/town_hall_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/delivery_address.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/edit_profile_info_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/faq_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/kyc/kyc_screen.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/release_notes_content_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/release_notes_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/user_user_page.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/wallet_page.dart';
import 'package:food_bank/screens/user_account_screens/my_bag_screen.dart';
import 'package:food_bank/screens/user_account_screens/onboarding_screen.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/screens/qr_scanner_screen.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/screens/search_screen.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/screens/view_order_summary_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/splash_screen.dart';
import '../screens/user_account_screens/auth/presentation/screens/password_reset_success_screen.dart';
import '../screens/user_account_screens/auth/presentation/screens/reset_password_screen.dart';
import '../screens/user_account_screens/auth/presentation/screens/select_avatar_screen.dart';
import '../screens/user_account_screens/auth/presentation/screens/signin_screen.dart';
import '../screens/user_account_screens/auth/presentation/screens/signup_screen.dart';
import '../screens/user_account_screens/auth/presentation/screens/verify_reset_Password_screen.dart';
import '../screens/user_account_screens/auth/presentation/screens/verify_account_signup_screen.dart';
import '../screens/user_account_screens/checkout/presentation/screens/checkout_screen.dart';
import '../screens/user_account_screens/empty_wallet_message_screen.dart';
import '../screens/user_account_screens/home/home_page/presentation/screens/redeem_screen.dart';
import '../screens/user_account_screens/home/my_bag_page/presentation/screens/bag_history_page.dart';
import '../screens/user_account_screens/home/my_bag_page/presentation/screens/track_screen.dart';
import '../screens/user_account_screens/home/my_bag_page/presentation/screens/view_reoccurring_order_summary_screen.dart';
import '../screens/user_account_screens/home/user_page/presentation/screens/change_password_page.dart';
import '../screens/user_account_screens/home/user_page/presentation/screens/kyc/kyc_success_screen.dart';
import '../screens/user_account_screens/home/user_page/presentation/screens/transaction_summary_screen.dart';

final routes = GoRouter(
  initialLocation: SplashScreen.route,
  routes: <GoRoute>[
    GoRoute(
      path: SplashScreen.route,
      name: SplashScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const SplashScreen(),
    ),
    GoRoute(
      path: OnboardingScreen.route,
      name: OnboardingScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const OnboardingScreen(),
    ),
    GoRoute(
      path: SignUpScreen.route,
      name: SignUpScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const SignUpScreen(),
    ),
    GoRoute(
      path: SignInScreen.route,
      name: SignInScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const SignInScreen(),
    ),
    GoRoute(
      path: VerifyAccountSignUpScreen.route,
      name: VerifyAccountSignUpScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const VerifyAccountSignUpScreen(),
    ),
    GoRoute(
      path: VerifyResetPasswordScreen.route,
      name: VerifyResetPasswordScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const VerifyResetPasswordScreen(),
    ),
    GoRoute(
      path: ForgetPasswordScreen.route,
      name: ForgetPasswordScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ForgetPasswordScreen(),
    ),
    GoRoute(
      path: ResetPasswordScreen.route,
      name: ResetPasswordScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ResetPasswordScreen(),
    ),
    GoRoute(
      path: ResetPasswordSuccessScreen.route,
      name: ResetPasswordSuccessScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ResetPasswordSuccessScreen(),
    ),
    GoRoute(
      path: SelectAvatarScreen.route,
      name: SelectAvatarScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const SelectAvatarScreen(),
    ),
    GoRoute(
      path: UserFoodBankBottomNavigator.route,
      name: UserFoodBankBottomNavigator.name,
      builder: (BuildContext context, GoRouterState state) =>
          const UserFoodBankBottomNavigator(),
    ),
    GoRoute(
      path: HomePage.route,
      name: HomePage.name,
      builder: (BuildContext context, GoRouterState state) =>
          HomePage(arg: state.extra),
    ),
    GoRoute(
      path: DonorPage.route,
      name: DonorPage.name,
      builder: (BuildContext context, GoRouterState state) => const DonorPage(),
    ),
    GoRoute(
      path: EmptyWalletMessageScreen.route,
      name: EmptyWalletMessageScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const EmptyWalletMessageScreen(),
    ),
    GoRoute(
      path: MyBagPage.route,
      name: MyBagPage.name,
      builder: (BuildContext context, GoRouterState state) => const MyBagPage(),
    ),
    GoRoute(
      path: TownHallPage.route,
      name: TownHallPage.name,
      builder: (BuildContext context, GoRouterState state) =>
          const TownHallPage(),
    ),
    GoRoute(
      path: UserPage.route,
      name: UserPage.name,
      builder: (BuildContext context, GoRouterState state) => const UserPage(),
    ),
    GoRoute(
      path: SearchScreen.route,
      name: SearchScreen.name,
      builder: (BuildContext context, GoRouterState state) => SearchScreen(
        isFromDonor: (state.extra ?? false) as bool,
      ),
    ),
    GoRoute(
      path: RedeemScreen.route,
      name: RedeemScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const RedeemScreen(),
    ),
    GoRoute(
      path: TrackOrderScreen.route,
      name: TrackOrderScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const TrackOrderScreen(),
    ),
    GoRoute(
      path: QRScannerScreen.route,
      name: QRScannerScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const QRScannerScreen(),
    ),
    GoRoute(
      path: CheckoutScreen.route,
      name: CheckoutScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const CheckoutScreen(),
    ),
    GoRoute(
      path: MyBagScreen.route,
      name: MyBagScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const MyBagScreen(),
    ),
    GoRoute(
      path: HoldOnTightScreen.route,
      name: HoldOnTightScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const HoldOnTightScreen(),
    ),
    GoRoute(
      path: ViewOrderSummaryScreen.route,
      name: ViewOrderSummaryScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ViewOrderSummaryScreen(),
    ),
    GoRoute(
      path: ViewReoccurringOrderSummaryScreen.route,
      name: ViewReoccurringOrderSummaryScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ViewReoccurringOrderSummaryScreen(),
    ),
    GoRoute(
      path: EditProfileInfoPage.route,
      name: EditProfileInfoPage.name,
      builder: (BuildContext context, GoRouterState state) =>
          const EditProfileInfoPage(),
    ),
    GoRoute(
      path: ChangePasswordPage.route,
      name: ChangePasswordPage.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ChangePasswordPage(),
    ),
    GoRoute(
      path: KycScreen.route,
      name: KycScreen.name,
      builder: (BuildContext context, GoRouterState state) => const KycScreen(),
    ),
    GoRoute(
      path: KycSuccessScreen.route,
      name: KycSuccessScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const KycSuccessScreen(),
    ),
    GoRoute(
      path: DeliveryAddressPage.route,
      name: DeliveryAddressPage.name,
      builder: (BuildContext context, GoRouterState state) =>
          const DeliveryAddressPage(),
    ),
    GoRoute(
      path: ReleaseNotesPage.route,
      name: ReleaseNotesPage.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ReleaseNotesPage(),
    ),
    GoRoute(
      path: BagHistoryPage.route,
      name: BagHistoryPage.name,
      builder: (BuildContext context, GoRouterState state) =>
          const BagHistoryPage(),
    ),
    GoRoute(
      path: WalletPage.route,
      name: WalletPage.name,
      builder: (BuildContext context, GoRouterState state) =>
          const WalletPage(),
    ),
    GoRoute(
      path: ReleaseNotesContentPage.route,
      name: ReleaseNotesContentPage.name,
      builder: (BuildContext context, GoRouterState state) =>
          const ReleaseNotesContentPage(),
    ),
    GoRoute(
      path: FAQPage.route,
      name: FAQPage.name,
      builder: (BuildContext context, GoRouterState state) => const FAQPage(),
    ),
    GoRoute(
      path: DonorFoodBankBottomNavigator.route,
      name: DonorFoodBankBottomNavigator.name,
      builder: (BuildContext context, GoRouterState state) =>
          const DonorFoodBankBottomNavigator(),
    ),
    GoRoute(
      path: DonorCheckoutScreen.route,
      name: DonorCheckoutScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const DonorCheckoutScreen(),
    ),
    GoRoute(
      path: DonorMyBagScreen.route,
      name: DonorMyBagScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const DonorMyBagScreen(),
    ),
    GoRoute(
      path: DonorHoldOnTightScreen.route,
      name: DonorHoldOnTightScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const DonorHoldOnTightScreen(),
    ),
    GoRoute(
      path: DonationCreatedScreen.route,
      name: DonationCreatedScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          const DonationCreatedScreen(),
    ),
    GoRoute(
      path: TransactionSummaryScreen.route,
      name: TransactionSummaryScreen.name,
      builder: (BuildContext context, GoRouterState state) =>
          TransactionSummaryScreen(
        transaction: state.extra as Transaction,
      ),
    ),
  ],
);
