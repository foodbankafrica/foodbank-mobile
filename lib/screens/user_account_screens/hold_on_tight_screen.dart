import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/bottom_sheets/three_step_order_in_progress_sheet.dart';
import 'package:food_bank/common/user_bottom_nav_bar.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'home/my_bag_page/cache/cart_cache.dart';

class HoldOnTightScreen extends StatefulWidget {
  static String name = 'hold-on-tight';
  static String route = '/hold-on-tight';
  const HoldOnTightScreen({super.key});

  @override
  State<HoldOnTightScreen> createState() => _HoldOnTightScreenState();
}

class _HoldOnTightScreenState extends State<HoldOnTightScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  static const double _targetPercentage = 100.0;
  static const Duration _animationDuration = Duration(seconds: 5);
  final CartCache cartCache = CartCache.instance;

  String? orderId;

  @override
  void initState() {
    super.initState();
    context.read<BagBloc>().add(GetCartsEvent());
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _controller.forward();
    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          if (orderId != null) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              isDismissible: false,
              useSafeArea: true,
              builder: (context) {
                return ThreeStepOrderInProgressBottomSheet(
                  orderId: orderId!,
                );
              },
            );
          } else {
            context.toast(content: "Successfully Redeem A Donation.");
            context.go(UserFoodBankBottomNavigator.route);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    orderId = GoRouterState.of(context).extra as dynamic;
    return Scaffold(
      body: BlocConsumer<BagBloc, BagState>(
        listener: (context, state) {
          if (state is GettingCartSuccessful) {
            cartCache.carts = state.carts;
          }
        },
        builder: (context, state) => Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return CircularPercentIndicator(
                      radius: 60,
                      percent: _controller.value,
                      progressColor: const Color(0xFFEB5017),
                      lineWidth: 15,
                      backgroundColor: const Color(0xFFF0F2F5),
                      circularStrokeCap: CircularStrokeCap.round,
                      center: Text(
                        '${(_controller.value * _targetPercentage).toInt()}%',
                        style: Theme.of(context)
                            .textTheme
                            .displayLarge
                            ?.copyWith(fontSize: 18),
                      ),
                      animation: true,
                      animateFromLastPercent: true,
                      animationDuration: _animationDuration.inMilliseconds,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text('Hold on tight',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 10),
                Text(
                  'Your order is been processed.\n To track your order, go to your order history',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF98A2B3)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
