import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets.dart';
import '../../cache/user_cache.dart';
import '../bloc/auth_bloc.dart';
import 'signin_screen.dart';
import 'verify_reset_Password_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static String name = 'forget-password';
  static String route = '/forget-password';
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
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
                    'Reset Password',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter your email address to get a link to reset your password',
                    style: Theme.of(context).textTheme.bodyLarge,
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
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is ForgettingPasswordFail) {
                        context.buildError(state.error);
                      } else if (state is ForgettingPasswordSuccessful) {
                        context.toast(content: state.message);
                        context.push(
                          VerifyResetPasswordScreen.route,
                          extra: phoneOrEmailController.text,
                        );
                      }
                    },
                    builder: (context, state) {
                      return CustomButton(
                        isLoading: state is ForgettingPassword,
                        onTap: () {
                          if (!_formKey.currentState!.validate()) return;
                          context.read<AuthBloc>().add(
                                ForgetPasswordEvent(
                                  email: phoneOrEmailController.text,
                                ),
                              );
                        },
                        text: 'Forget Password',
                      );
                    },
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      Text(
                        'Remember your password ?',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          context.go(SignInScreen.route);
                        },
                        child: Text(
                          'Login',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: const Color(0xFFEB5017),
                                  ),
                        ),
                      )
                    ],
                  ),
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
