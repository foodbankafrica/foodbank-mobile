import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../screens/user_account_screens/hold_on_tight_screen.dart';
import '../../screens/user_account_screens/home/my_bag_page/models/donation_model.dart';
import '../../screens/user_account_screens/home/user_page/cache/address_cache.dart';
import '../../screens/user_account_screens/my_bag_screen.dart';

class RedeemFoodBlockBottomSheet extends StatefulWidget {
  const RedeemFoodBlockBottomSheet({
    super.key,
    required this.donation,
    this.private = false,
    this.redeemCode = "",
  });
  final Donation donation;
  final bool private;
  final String redeemCode;

  @override
  State<RedeemFoodBlockBottomSheet> createState() =>
      _RedeemFoodBlockBottomSheetState();
}

class _RedeemFoodBlockBottomSheetState
    extends State<RedeemFoodBlockBottomSheet> {
  final TextEditingController deliveryAddressController =
      TextEditingController();
  final AddressCache addressCache = AddressCache.instance;
  @override
  void initState() {
    setState(() {
      deliveryAddressController.text = addressCache.defaultAddress;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        print(state);
        if (state is RedeemingDonationSuccessful) {
          context.go(
            HoldOnTightScreen.route,
          );
        } else if (state is RedeemingDonationFail) {
          if (state.error.toLowerCase() == "unauthenticated") {
            context.buildError(state.error);
            context.logout();
          } else {
            context.buildError(state.error);
          }
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const FoodBankBottomSheetAppBar(
              title: '',
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 28,
                    width: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFFFECE5),
                    ),
                    child: Center(
                      child: Text(
                        'Free',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Text(
                  //       'Jollof rice from  ',
                  //       style: Theme.of(context)
                  //           .textTheme
                  //           .bodyLarge
                  //           ?.copyWith(fontSize: 20),
                  //     ),
                  //     Image.asset(
                  //       'assets/images/food-logo.png',
                  //       scale: 1.4,
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 8),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text:
                              'For ${widget.donation.noOfPeople} Recipients by |  ',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(color: const Color(0xFF98A2B3)),
                          children: [
                            TextSpan(
                              text: widget.donation.isAnonymous == 1
                                  ? 'Anonymous'
                                  : widget.donation.user!.firstName!
                                      .capitalize(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Bag Summary',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        ...(widget.donation.donationProducts ?? [])
                            .map((product) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(6),
                                      child: CustomCacheImage(
                                        image: ((product.product ?? Product())
                                                        .images ??
                                                    [])
                                                .isEmpty
                                            ? ''
                                            : (product.product ?? Product())
                                                    .images!
                                                    .first
                                                    .path ??
                                                '',
                                        width: 60,
                                        height: 60,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            (product.product ?? Product())
                                                    .name ??
                                                '',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                        const SizedBox(height: 5),
                                        Text(
                                          (product.product ?? Product())
                                                  .description ??
                                              '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      const Color(0xFF98A2B3)),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          '₦${((product.product ?? Product()).price).toString().formatAmount()}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Text(
                                  product.quantity ?? '',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          );
                        }),
                        const SizedBox(height: 5),
                        const Divider(
                          thickness: 0.5,
                        ),
                        if ((widget.donation.type ?? "").toLowerCase() !=
                            "pickup") ...{
                          const SizedBox(height: 30),
                          DeliveryAddressContent(
                            horizontalPadding: 0,
                            address: deliveryAddressController.text,
                            onAddAddress: (String address, lng, lat) {
                              setState(() {
                                deliveryAddressController.text = address;
                              });
                            },
                          ),
                        },
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  CustomButton(
                    isLoading: state is RedeemingDonation,
                    onTap: () {
                      if (deliveryAddressController.text.trim().isEmpty &&
                          (widget.donation.type ?? 'deliver').toLowerCase() !=
                              "pickup") {
                        context.buildError(
                            "Delivery Address is Required ${widget.donation.type!.toLowerCase()}");
                        return;
                      }
                      if (widget.private) {
                        context.read<CheckoutBloc>().add(
                              RedeemingPrivateDonationEvent(
                                address: deliveryAddressController.text,
                                donationId: widget.donation.id!,
                                redeemCode: widget.redeemCode,
                              ),
                            );
                      } else {
                        context.read<CheckoutBloc>().add(
                              RedeemingDonationEvent(
                                address: deliveryAddressController.text,
                                donationId: widget.donation.id!,
                              ),
                            );
                      }
                    },
                    text: 'Redeem',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
