import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/donor_bottom_nav_bar.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:go_router/go_router.dart';

class DonationCreatedScreen extends StatelessWidget {
  static String name = 'donation-created';
  static String route = '/donation-created';
  const DonationCreatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/donation_created.svg',
                height: 150,
              ),
              const SizedBox(height: 10),
              Text(
                'Donation Have been \ncreated',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Your donation have been created.',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: const Color(0xFF98A2B3)),
              ),
              const SizedBox(height: 10),
              CustomButton(
                onTap: () {
                  context.go(
                    DonorFoodBankBottomNavigator.route,
                  );
                },
                text: "Continue Exploring",
              )
            ],
          ),
        ),
      ),
    );
  }
}
