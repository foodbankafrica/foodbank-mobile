import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/bloc/kyc_bloc/kyc_bloc.dart';
import 'kyc_success_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../../core/utils/helper_func.dart';
import '../../../../../auth/cache/user_cache.dart';

class KycScreen extends StatefulWidget {
  static String name = 'kyc';
  static String route = '/kyc';
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  final UserCache userCache = UserCache.instance;
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool isLoading = true;

  final TextEditingController bvnController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();

  @override
  initState() {
    if (userCache.kyc.bvnVerified != null && userCache.kyc.bvnVerified == 1) {
      Future.delayed(
        const Duration(seconds: 3),
        () {
          context.push(KycSuccessScreen.route);
        },
      );
    }
    setUserDetails();
    Future.delayed(
      const Duration(seconds: 3),
      () {
        setState(
          () {
            isLoading = false;
          },
        );
      },
    );
    super.initState();
  }

  setUserDetails() {
    final user = userCache.user;
    phoneController.text = user.phone!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Kyc',
      ),
      body: isLoading
          ? const Center(
              child: CustomIndicator(
                color: Color(0xFFF56630),
              ),
            )
          : userCache.kyc.bvn != null || userCache.virtualAccounts.isNotEmpty
              ? NotFound(
                  message: userCache.virtualAccounts.isNotEmpty
                      ? "Account Verified"
                      : "Your have a Pending KYC.",
                  showButton: false,
                )
              : SafeArea(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 18.0,
                        left: 18.0,
                        top: 30.0,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Verify your Identity',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'We need few info from you to verify your account.',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            const SizedBox(height: 40),
                            FoodBankTextField(
                              labelText: "BVN",
                              hintText: "Enter your BVN",
                              controller: bvnController,
                              keyboardType: TextInputType.number,
                              maxLength: 11,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Bvn is required.';
                                }
                                if (value.length < 11) {
                                  return 'Bvn is must be 11 digits.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            FoodBankTextField(
                              labelText: "Date of Birth",
                              hintText: "Pick your Date of Birth",
                              controller: dobController,
                              readOnly: true,
                              onTap: () async {
                                dobController.text =
                                    await pickDateOfBirth(context);
                              },
                              suffix: InkWell(
                                onTap: () async {
                                  dobController.text =
                                      await pickDateOfBirth(context);
                                },
                                child: const Icon(
                                  Icons.calendar_month,
                                  color: Colors.black45,
                                ),
                              ),
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Date of birth is required.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select your Gender',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 5),
                                DropdownButtonFormField(
                                  hint: const Text("What is your Gender"),
                                  validator: (String? value) {
                                    if ((value ?? '').isEmpty) {
                                      return 'Gender is required.';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD0D5DD),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color(0xFFD0D5DD),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: Color.fromARGB(255, 35, 90, 179),
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFEB5017)),
                                    ),
                                    errorStyle: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFFEB5017),
                                        ),
                                  ),
                                  items: ["Male", "Female"]
                                      .map(
                                        (timeline) => DropdownMenuItem<String>(
                                          value: timeline,
                                          child: Text(timeline),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (timeline) {
                                    setState(
                                      () {
                                        genderController.text = timeline!;
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            FoodBankTextField(
                              labelText: "Whats your address",
                              hintText: "Enter your address",
                              controller: addressController,
                              keyboardType: TextInputType.text,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Address is required.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 15),
                            FoodBankTextField(
                              labelText: "Phone Number",
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              // readOnly: true,
                              maxLength: 15,
                              hintText: "Enter your phone number",
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Phone is required.';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 25),
                            BlocConsumer<KycBloc, KycState>(
                              listener: (context, state) {
                                if (state is VerificationFail) {
                                  context.buildError(state.error);
                                } else if (state is VerificationSuccessful) {
                                  context.push(KycSuccessScreen.route);
                                }
                              },
                              builder: (context, state) => CustomButton(
                                isLoading: state is Verifying,
                                onTap: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  context.read<KycBloc>().add(
                                        VerificationEvent(
                                          dob: dobController.text,
                                          bvn: bvnController.text,
                                          gender: genderController.text
                                              .toLowerCase(),
                                          address: addressController.text,
                                          phone: phoneController.text,
                                        ),
                                      );
                                },
                                text: 'Verify Account',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
