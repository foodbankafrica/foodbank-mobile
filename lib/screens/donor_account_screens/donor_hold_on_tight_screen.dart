import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/screens/donor_account_screens/donation_created_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../user_account_screens/checkout/presentation/bloc/checkout_bloc.dart';
import '../user_account_screens/home/my_bag_page/cache/donation_cache.dart';

class DonorHoldOnTightScreen extends StatefulWidget {
  static String name = 'donor-hold-on-tight';
  static String route = '/donor-hold-on-tight';
  const DonorHoldOnTightScreen({super.key});

  @override
  State<DonorHoldOnTightScreen> createState() => _DonorHoldOnTightScreenState();
}

class _DonorHoldOnTightScreenState extends State<DonorHoldOnTightScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  static const double _targetPercentage = 100.0;
  static const Duration _animationDuration = Duration(seconds: 5);
  final DonationCache donationCache = DonationCache.instance;

  @override
  void initState() {
    super.initState();
    context.read<CheckoutBloc>().add(GettingDonationsEvent(1));
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _controller.forward();
    _controller.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          context.go(DonationCreatedScreen.route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is GettingDonationsSuccessful) {
            donationCache.donations = state.res.donations!.data!;
          }
        },
        builder: (context, state) {
          return Padding(
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
                    'Your order is been processed.',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF98A2B3)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
