import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/otp_form_widget.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/widgets.dart';
import '../bloc/auth_bloc.dart';
import 'reset_password_screen.dart';

class VerifyResetPasswordScreen extends StatefulWidget {
  static String name = 'verify-reset-password';
  static String route = '/verify-reset-password';
  const VerifyResetPasswordScreen({super.key});

  @override
  State<VerifyResetPasswordScreen> createState() =>
      _VerifyResetPasswordScreenState();
}

class _VerifyResetPasswordScreenState extends State<VerifyResetPasswordScreen> {
  final TextEditingController pinController = TextEditingController();

  int _secondsRemaining = 60;
  bool countDownStarted = false;
  Timer? _timer;

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          countDownStarted = true;
        } else {
          countDownStarted = false;
          _timer!.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = GoRouterState.of(context).extra as String;
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is ResendForgetPasswordOtpFail) {
              context.buildError("Fail to resend otp");
            } else if (state is ResendForgetPasswordOtpSuccessful) {
              startTimer();
              context.toast(content: "Otp resend successfully");
            } else if (state is VerifyingForgetPasswordFail) {
              context.buildError(state.error);
            } else if (state is VerifyingForgetPasswordSuccessful) {
              context.toast(content: state.message);
              context.go(ResetPasswordScreen.route);
            }
          },
          builder: (context, state) => Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify otp',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    text: 'Enter the 6 Digit verification code sent to ',
                    style: Theme.of(context).textTheme.headlineSmall,
                    children: [
                      TextSpan(
                        text: '$email ',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w400),
                      ),
                      const TextSpan(
                        text: 'The code expires in 30 Minutes',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                OtpForm(controller: pinController),
                const SizedBox(height: 40),
                if (countDownStarted) ...{
                  Center(
                    child: Text(
                      'Resend code in ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      '$_secondsRemaining seconds',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                } else ...{
                  Center(
                    child: Text(
                      'Haven’t received code ?',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      context.read<AuthBloc>().add(
                            ResendForgetPasswordOtpEvent(
                              email: email,
                            ),
                          );
                    },
                    child: Center(
                      child: Text(
                        'Resend code',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                },
                const SizedBox(height: 20),
                CustomButton(
                  isLoading: state is VerifyingForgetPassword,
                  onTap: () {
                    context.read<AuthBloc>().add(VerifyForgotPasswordEvent(
                          email: email,
                          otp: pinController.text,
                        ));
                  },
                  text: 'Verify',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
