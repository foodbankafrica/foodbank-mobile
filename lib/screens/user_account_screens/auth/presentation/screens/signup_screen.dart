import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';
import '../../../../../common/widgets.dart';
import '../../cache/user_cache.dart';
import '../bloc/auth_bloc.dart';
import 'signin_screen.dart';
import 'verify_account_signup_screen.dart';

class SignUpScreen extends StatefulWidget {
  static String name = 'signup';
  static String route = '/signup';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final UserCache userCache = UserCache.instance;
  final GlobalKey<FormState> _fomrKey = GlobalKey();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
  final TextEditingController organizationNameController =
      TextEditingController();

  bool isSelected1 = true;
  bool isSelected2 = false;

  void changeState1() {
    if (isSelected1) return;
    setState(() {
      isSelected1 = !isSelected1;
    });
    if (isSelected1 == true) {
      isSelected2 = false;
    }
  }

  void changeState2() {
    if (isSelected2) return;
    setState(() {
      isSelected2 = !isSelected2;
    });
    if (isSelected2 == true) {
      isSelected1 = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create your account',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Have an account ?',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(width: 10),
                    InkWell(
                      onTap: () {
                        context.go(SignInScreen.route);
                      },
                      child: Text(
                        'Sign in',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: const Color(0xFFEB5017),
                            ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  height: 40,
                  width: 216,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(64),
                    color: const Color(0xFFEEF0F4),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          changeState1();
                        },
                        child: Container(
                          height: 40,
                          width: 108,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: isSelected1 == true ? Colors.black : null,
                          ),
                          child: Center(
                            child: Text(
                              'Recipient',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isSelected1 == true
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          changeState2();
                        },
                        child: Container(
                          height: 40,
                          width: 108,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: isSelected2 == true ? Colors.black : null,
                          ),
                          child: Center(
                            child: Text(
                              'Donor',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isSelected2 == true
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _fomrKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: FoodBankTextField(
                              controller: firstNameController,
                              keyboardType: TextInputType.name,
                              labelText: "First Name",
                              hintText: "Enter First Name",
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: FoodBankTextField(
                              controller: lastNameController,
                              keyboardType: TextInputType.emailAddress,
                              labelText: "Last Name",
                              hintText: "Enter Last Name",
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (isSelected2 == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FoodBankTextField(
                              labelText: 'Organization Name (Optional)',
                              hintText: 'Enter your organization name',
                              controller: organizationNameController,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Organization Name (or organization name for NGOs, companies, etc.)',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      const SizedBox(height: 15),
                      FoodBankTextField(
                        controller: emailController,
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
                      FoodBankTextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        maxLength: 11,
                        labelText: 'Phone Number',
                        hintText: "Enter your number",
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      // FoodBankTextField(
                      //   controller: dobController,
                      //   labelText: 'Date of Birth',
                      //   hintText: "Pick your date of birth",
                      //   readOnly: true,
                      //   onTap: () async {
                      //     dobController.text = await pickDateOfBirth(context);
                      //   },
                      //   suffix: InkWell(
                      //     onTap: () async {
                      //       dobController.text = await pickDateOfBirth(context);
                      //     },
                      //     child: const Icon(
                      //       Icons.calendar_month,
                      //       color: Colors.black45,
                      //     ),
                      //   ),
                      // ),
                      // const SizedBox(height: 15),
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
                      FoodBankTextField(
                        controller: referralCodeController,
                        labelText: 'Referral code (Optional)',
                        hintText: "Enter your referral code",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is RegistrationFail) {
                      context.buildError(state.error);
                    } else if (state is RegistrationSuccessful) {
                      context.toast(content: "Registration successful!");
                      userCache.updateCache(
                        user: state.user.user!,
                        wallet: state.user.wallet,
                        virtualAccounts: state.user.virtualAccounts,
                        kyc: state.user.kyc,
                      );
                      context.push(VerifyAccountSignUpScreen.route);
                    }
                  },
                  builder: (context, state) {
                    return CustomButton(
                      isLoading: state is Registering,
                      onTap: () {
                        if (!_fomrKey.currentState!.validate()) return;
                        context.read<AuthBloc>().add(
                              RegisterEvent(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                organizationName:
                                    organizationNameController.text,
                                phone: phoneController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                referralCode: referralCodeController.text,
                                userType: isSelected1 ? 'recipient' : 'donor',
                              ),
                            );
                      },
                      text: 'Create account',
                    );
                  },
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
    );
  }
}
