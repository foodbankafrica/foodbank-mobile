import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';

import '../../../../auth/presentation/bloc/auth_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  static String name = 'change-password';
  static String route = '/change-password';
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Change password',
      ),
      body: Column(
        children: [
          const Divider(thickness: 0.8),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FoodBankTextField(
                        hintText: "Old Password",
                        labelText: "Old Password",
                        controller: oldPasswordController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Old password is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      FoodBankTextField(
                        hintText: "New Password",
                        labelText: "New Password",
                        controller: passwordController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "New password is required";
                          } else if (value == oldPasswordController.text) {
                            return "New password should not be old password";
                          } else if (value != confirmPasswordController.text) {
                            return "Password not matched";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      FoodBankTextField(
                        hintText: "Confirm Password",
                        labelText: "Confirm Password",
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Old password is required";
                          } else if (value != passwordController.text) {
                            return "Password not matched";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is ChangingPasswordSuccessful) {
                context.toast(content: state.message);
              } else if (state is ChangingPasswordFail) {
                context.buildError(state.error);
              }
            },
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.all(18.0),
                child: CustomButton(
                  isLoading: state is ChangingPassword,
                  onTap: () {
                    if (!_formKey.currentState!.validate()) return;
                    context.read<AuthBloc>().add(
                          ChangePasswordEvent(
                            currentPassword: oldPasswordController.text,
                            password: passwordController.text,
                            confirmPassword: confirmPasswordController.text,
                          ),
                        );
                  },
                  text: 'Change password',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
