import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/auth/presentation/bloc/auth_bloc.dart';

import '../../../../auth/cache/user_cache.dart';

class EditProfileInfoPage extends StatefulWidget {
  static String name = 'edit-profile-info';
  static String route = '/edit-profile-info';
  const EditProfileInfoPage({super.key});

  @override
  State<EditProfileInfoPage> createState() => _EditProfileInfoPageState();
}

class _EditProfileInfoPageState extends State<EditProfileInfoPage> {
  final UserCache userCache = UserCache.instance;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  initState() {
    setUserDetails();
    super.initState();
  }

  setUserDetails() {
    final user = userCache.user;
    final kyc = userCache.kyc;
    firstNameController.text = user.firstName!;
    lastNameController.text = user.lastName!;
    emailController.text = user.email!;
    phoneController.text = user.phone!;
    dobController.text = kyc.dob ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Edit Profile info',
      ),
      body: Column(
        children: [
          const Divider(thickness: 0.8),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FoodBankTextField(
                      hintText: "First Name",
                      controller: firstNameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 15),
                    FoodBankTextField(
                      hintText: "Last Name",
                      controller: lastNameController,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 15),
                    FoodBankTextField(
                      hintText: "Email",
                      controller: emailController,
                      readOnly: true,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    FoodBankTextField(
                      hintText: "Phone Number",
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),
                    if (dobController.text.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FoodBankTextField(
                            hintText: "Date of Birth",
                            controller: dobController,
                            readOnly: true,
                            onTap: () async {
                              // dobController.text = await pickDateOfBirth(context);
                            },
                            suffix: InkWell(
                              onTap: () async {
                                // dobController.text = await pickDateOfBirth(context);
                              },
                              child: const Icon(
                                Icons.calendar_month,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          const Text(
                            "Contact admin to change your date of birth.",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
          BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UpdatingAccountSuccessful) {
                context.toast(content: "Profile updated successfully");
              } else if (state is UpdatingAccountFail) {
                if (state.error.toLowerCase() == "unauthenticated") {
                  context.buildError(state.error);
                  context.logout();
                } else {
                  context.buildError(state.error);
                }
              }
            },
            builder: (context, state) => Padding(
              padding: const EdgeInsets.all(18.0),
              child: CustomButton(
                isLoading: state is UpdatingAccount,
                onTap: () {
                  context.read<AuthBloc>().add(UpdateAccountEvent(
                        email: emailController.text,
                        lastName: lastNameController.text,
                        firstName: firstNameController.text,
                        phone: phoneController.text,
                      ));
                },
                text: 'Update',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
