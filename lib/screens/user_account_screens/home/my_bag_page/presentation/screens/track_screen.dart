import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../common/bottom_sheets/redeem_food_block_sheet.dart';
import '../../../../../../core/cache/cache_key.dart';
import '../../../../../../core/cache/cache_store.dart';
import '../../../../auth/presentation/screens/signin_screen.dart';

class TrackOrderScreen extends StatefulWidget {
  static String name = 'track-order';
  static String route = '/track-order';
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Track an order',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Track with code",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 10),
                FoodBankTextField(
                  hintText: "Enter tracking code",
                  controller: controller,
                  suffix: Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 5),
                    child: BlocConsumer<CheckoutBloc, CheckoutState>(
                      listener: (context, state) {
                        print(state);
                        if (state is SearchingForDonationSuccessful) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            useSafeArea: true,
                            builder: (context) {
                              return RedeemFoodBlockBottomSheet(
                                donation: state.res,
                                private: true,
                                redeemCode: controller.text,
                              );
                            },
                          );
                        } else if (state is SearchingForDonationFail) {
                          if (state.error.toLowerCase() == "unauthenticated") {
                            context.buildError(state.error);
                            CacheStore().remove(key: CacheKey.token);
                            Future.delayed(const Duration(seconds: 2), () {
                              context.go(SignInScreen.route);
                            });
                          } else {
                            context.buildError(state.error);
                          }
                        }
                      },
                      builder: (context, state) => CustomButton(
                        isLoading: state is SearchingForDonation,
                        onTap: () {
                          context
                              .read<CheckoutBloc>()
                              .add(SearchingForDonationEvent(controller.text));
                        },
                        text: "Track",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
