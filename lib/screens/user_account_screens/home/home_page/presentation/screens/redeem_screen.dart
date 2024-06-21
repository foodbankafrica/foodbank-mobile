import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/screens/qr_scanner_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../../../../../common/bottom_sheets/redeem_food_block_sheet.dart';

class RedeemScreen extends StatefulWidget {
  static String name = 'redeem';
  static String route = '/redeem';
  const RedeemScreen({super.key});

  @override
  State<RedeemScreen> createState() => _RedeemScreenState();
}

class _RedeemScreenState extends State<RedeemScreen> {
  Barcode? result;
  TextEditingController controller = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Redeem Food',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Redeem With Code",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                ),
                const SizedBox(height: 10),
                FoodBankTextField(
                  hintText: "Enter redeem code",
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
                          context.buildError(state.error);
                        }
                      },
                      builder: (context, state) => CustomButton(
                        isLoading: state is SearchingForDonation,
                        onTap: () {
                          context
                              .read<CheckoutBloc>()
                              .add(SearchingForDonationEvent(controller.text));
                        },
                        text: "Redeem",
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "OR",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onTap: () {
                    context.push(QRScannerScreen.route);
                  },
                  text: "Scan QR Code",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
