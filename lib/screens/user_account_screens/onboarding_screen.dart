import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:go_router/go_router.dart';

import 'auth/presentation/screens/signin_screen.dart';
import 'auth/presentation/screens/signup_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static String name = 'onboarding';
  static String route = '/onboarding';
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 384,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/onboarding_frame.png'),
                  ),
                ),
                // child: const Placeholder(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      'Feed well and gift \nothers in need',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 30),
                    CustomButton(
                      onTap: () {
                        context.go(SignUpScreen.route);
                      },
                      text: 'Get Started',
                    ),
                    const SizedBox(height: 20),
                    OpenElevatedButton(
                      onPressed: () {
                        context.push(SignInScreen.route);
                      },
                      child: Text(
                        'Sign In',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 0.5,
                            width: 20,
                            color: const Color(0xFF98A2B3),
                          ),
                        ),
                        Text(
                          ' Or ',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFF98A2B3),
                                  ),
                        ),
                        Expanded(
                          child: Container(
                            height: 0.5,
                            width: 20,
                            color: const Color(0xFF98A2B3),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),
                    const GuestButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
