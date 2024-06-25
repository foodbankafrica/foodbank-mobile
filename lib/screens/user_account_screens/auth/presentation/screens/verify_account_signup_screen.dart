import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/bottom_sheets/enter_delivery_address_sheet.dart';
import 'package:food_bank/common/otp_form_widget.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../../home/user_page/presentation/bloc/address_bloc/address_bloc.dart';
import '../../cache/user_cache.dart';
import '../bloc/auth_bloc.dart';
import 'select_avatar_screen.dart';

class VerifyAccountSignUpScreen extends StatefulWidget {
  static String name = 'verify-account-signup';
  static String route = '/verify-account-signup';
  const VerifyAccountSignUpScreen({super.key});

  @override
  State<VerifyAccountSignUpScreen> createState() =>
      _VerifyAccountSignUpScreenState();
}

class _VerifyAccountSignUpScreenState extends State<VerifyAccountSignUpScreen> {
  final UserCache userCache = UserCache.instance;
  final TextEditingController otpController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

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
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is VerifyingOtpFail) {
              context.buildError(state.error);
            } else if (state is VerifyingOtpSuccessful) {
              context.pop();
              context.toast(content: "Phone number verified successfully!");
              userCache.updateCache(
                user: state.user.user!,
                wallet: state.user.wallet,
                virtualAccounts: state.user.virtualAccounts,
                kyc: state.user.kyc,
              );
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                isDismissible: false,
                useSafeArea: true,
                builder: (context) {
                  return BlocConsumer<AddressBloc, AddressState>(
                    listener: (context, state) {
                      if (state is AddingAddressFail) {
                        context.buildError(state.error);

                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: false,
                          useSafeArea: true,
                          builder: (context) {
                            return Text(state.error);
                          },
                        );
                      } else if (state is AddingAddressSuccessful) {
                        context.pop();
                        context.toast(content: "Address added successfully!");
                        context.push(SelectAvatarScreen.route);
                      }
                    },
                    builder: (context, state) {
                      return EnterDeliveryAddressBottomSheet(
                        controller: addressController,
                        isLoading: state is AddingAddress,
                        onAdd: (lat, lng) {
                          context.read<AddressBloc>().add(
                                AddAddressEvent(
                                  address: addressController.text,
                                  latitude: lat,
                                  longitude: lng,
                                ),
                              );
                        },
                      );
                    },
                  );
                },
              );
            } else if (state is ResendingOtpFail) {
              context.buildError(state.error);
            } else if (state is ResendingOtpSuccessful) {
              startTimer();
              context.toast(content: "Otp resend successfully");
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verify account signup',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Enter the 6 Digit verification code sent to ',
                      style: Theme.of(context).textTheme.headlineSmall,
                      children: [
                        TextSpan(
                          text: '${userCache.user.phone} ',
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
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          child: OtpForm(controller: otpController),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        context.read<AuthBloc>().add(ResendOtpEvent());
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
                    isLoading: state is VerifyingOtp,
                    onTap: () {
                      context
                          .read<AuthBloc>()
                          .add(VerifyOtpEvent(otp: otpController.text));
                    },
                    text: 'Verify Account',
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
