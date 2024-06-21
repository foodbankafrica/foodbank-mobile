import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/auth/presentation/screens/forget_password_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/bottom_sheets/guess_track_or_order_sheet.dart';
import '../../../../../common/donor_bottom_nav_bar.dart';
import '../../../../../common/user_bottom_nav_bar.dart';
import '../../../../../common/widgets.dart';
import '../../cache/user_cache.dart';
import '../bloc/auth_bloc.dart';
import './signup_screen.dart';
import 'verify_account_signup_screen.dart';

class SignInScreen extends StatefulWidget {
  static String name = 'signin';
  static String route = '/signin';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final UserCache userCache = UserCache.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController phoneOrEmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign in',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        'Don’t have an account ?',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          context.go(SignUpScreen.route);
                        },
                        child: Text(
                          'Create Account',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFFEB5017),
                                  ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  FoodBankTextField(
                    controller: phoneOrEmailController,
                    keyboardType: TextInputType.emailAddress,
                    labelText: 'Email',
                    hintText: "Enter your email",
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomPasswordInput(
                    controller: passwordController,
                    labelText: 'Password',
                    hintText: "Enter your password",
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is SigningFail) {
                        context.buildError(state.error);
                      } else if (state is SigningSuccessful) {
                        context.toast(content: "Welcome Back!");
                        userCache.updateCache(
                          user: state.user.user!,
                          wallet: state.user.wallet,
                          virtualAccounts: state.user.virtualAccounts,
                          kyc: state.user.kyc,
                        );
                        if (state.user.scope == "user-onboard") {
                          context.push(VerifyAccountSignUpScreen.route);
                        } else if (userCache.user.userType == "recipient") {
                          context.go(UserFoodBankBottomNavigator.route);
                        } else {
                          context.go(DonorFoodBankBottomNavigator.route);
                        }
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        isLoading: state is Signing,
                        onTap: () {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<AuthBloc>().add(
                                LoginEvent(
                                  emailOrPhone: phoneOrEmailController.text,
                                  password: passwordController.text,
                                ),
                              );
                        },
                        text: 'Sign in',
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  InkWell(
                    onTap: () {
                      context.push(ForgetPasswordScreen.route);
                    },
                    child: Center(
                      child: Text(
                        'Forgot password ?',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFFEB5017),
                            ),
                      ),
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
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
          ),
        ),
      ),
    );
  }
}

class GuestButton extends StatelessWidget {
  const GuestButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          useSafeArea: true,
          builder: (context) {
            return const GuessTrackOrOrderSheet();
          },
        );
      },
      child: Center(
        child: Text(
          'Continue as Guest',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
