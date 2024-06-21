import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/user_bottom_nav_bar.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../../../../common/bottom_sheets/update_avatar_sheet.dart';
import '../../../../../common/donor_bottom_nav_bar.dart';
import '../../../../../common/widgets.dart';
import '../../cache/user_cache.dart';
import '../bloc/auth_bloc.dart';

class SelectAvatarScreen extends StatefulWidget {
  static String name = 'select-avatar';
  static String route = '/select-avatar';
  const SelectAvatarScreen({super.key});

  @override
  State<SelectAvatarScreen> createState() => _SelectAvatarScreenState();
}

class _SelectAvatarScreenState extends State<SelectAvatarScreen> {
  String selectImage = "avatar1";
  final UserCache userCache = UserCache.instance;

  _setSelectImage(path) {
    setState(
      () {
        selectImage = path;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select your avatar',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Pick one avatar that suites your taste',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleAvatar(
                          selectImagePath: selectImage,
                          imagePath: "avatar-1",
                          onTap: (String path) => _setSelectImage(path),
                        ),
                        SingleAvatar(
                          selectImagePath: selectImage,
                          imagePath: "avatar-2",
                          onTap: (String path) => _setSelectImage(path),
                        ),
                        SingleAvatar(
                          selectImagePath: selectImage,
                          imagePath: "avatar-3",
                          onTap: (String path) => _setSelectImage(path),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleAvatar(
                          selectImagePath: selectImage,
                          imagePath: "avatar-4",
                          onTap: (String path) => _setSelectImage(path),
                        ),
                        SingleAvatar(
                          selectImagePath: selectImage,
                          imagePath: "avatar-5",
                          onTap: (String path) => _setSelectImage(path),
                        ),
                        SingleAvatar(
                          selectImagePath: selectImage,
                          imagePath: "avatar-6",
                          onTap: (String path) => _setSelectImage(path),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleAvatar(
                          selectImagePath: selectImage,
                          imagePath: "avatar-7",
                          onTap: (String path) => _setSelectImage(path),
                        ),
                        SingleAvatar(
                          selectImagePath: selectImage,
                          imagePath: "avatar-8",
                          onTap: (String path) => _setSelectImage(path),
                        ),
                        SingleAvatar(
                          selectImagePath: selectImage,
                          imagePath: "avatar-9",
                          onTap: (String path) => _setSelectImage(path),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is SavingAvatarFail) {
                    context.buildError(state.error);
                  } else if (state is SavingAvatarSuccessful) {
                    context.read<AuthBloc>().add(GetMeEvent());
                  } else if (state is GettingMeSuccessful) {
                    userCache.updateCache(
                      user: state.user.user!,
                      wallet: state.user.wallet!,
                      virtualAccounts: state.user.virtualAccounts!,
                      kyc: state.user.kyc,
                    );
                    if (userCache.user.userType == "recipient") {
                      context.go(UserFoodBankBottomNavigator.route);
                    } else {
                      context.go(DonorFoodBankBottomNavigator.route);
                    }
                    context.toast(content: "Registration Complete!");
                  }
                },
                builder: (context, state) {
                  return CustomButton(
                    isLoading: state is SavingAvatar,
                    onTap: () {
                      context.read<AuthBloc>().add(
                            SaveAvatarEvent(
                              avatar:
                                  "https://firebasestorage.googleapis.com/v0/b/amam-appilication-store.appspot.com/o/avatar%2F$selectImage.png?alt=media&token=e39f17aa-d4e4-4d1d-9cb5-8adf712fab04",
                            ),
                          );
                    },
                    text: 'Complete Signup',
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
