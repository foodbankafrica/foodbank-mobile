import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../common/success_screen.dart';
import '../../../../../auth/cache/user_cache.dart';
import '../../../../../auth/presentation/bloc/auth_bloc.dart';

class KycSuccessScreen extends StatefulWidget {
  static String name = 'kyc-success';
  static String route = '/kyc-success';
  const KycSuccessScreen({super.key});

  @override
  State<KycSuccessScreen> createState() => _KycSuccessScreenState();
}

class _KycSuccessScreenState extends State<KycSuccessScreen> {
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
        }
      },
      builder: (context, state) => SuccessScreen(
        title: "Account verification",
        subtitle: "Your account verification is been processing",
        buttonText: "Explore Foodbank",
        onClick: () {
          context
            ..pop()
            ..pop();
        },
      ),
    );
  }
}
