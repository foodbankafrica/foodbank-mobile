import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/auth/cache/user_cache.dart';
import 'package:food_bank/screens/user_account_screens/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

import '../common/donor_bottom_nav_bar.dart';
import '../common/user_bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  static String name = 'splash-screen';
  static String route = '/';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final UserCache userCache = UserCache.instance;

  @override
  void initState() {
    context.read<AuthBloc>().add(GetMeEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is GettingMeSuccessful) {
          userCache.updateCache(
            user: state.user.user!,
            wallet: state.user.wallet,
            virtualAccounts: state.user.virtualAccounts,
            kyc: state.user.kyc,
          );
          if (userCache.user.userType == "recipient") {
            context.go(UserFoodBankBottomNavigator.route);
          } else {
            context.go(DonorFoodBankBottomNavigator.route);
          }
        } else if (state is GettingMeFail) {
          if (state.error.toLowerCase() == "unauthenticated") {
            context.buildError(state.error);
            context.logout();
          } else {
            context.buildError(state.error);
          }
        }
      },
      builder: (context, state) => Scaffold(
        body: Center(
          child: Image.asset(
            "assets/images/logo.png",
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}
