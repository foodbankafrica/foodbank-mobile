// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/donor_account_screens/donor_hold_on_tight_screen.dart';
import 'package:go_router/go_router.dart';

import '../../common/bottom_sheets/delivery_location_sheet.dart';
import '../user_account_screens/auth/cache/user_cache.dart';
import '../user_account_screens/checkout/presentation/bloc/checkout_bloc.dart';
import '../user_account_screens/empty_wallet_message_screen.dart';
import '../user_account_screens/home/home_page/cache/business_cache.dart';
import '../user_account_screens/home/my_bag_page/cache/cart_cache.dart';
import '../user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';
import '../user_account_screens/my_bag_screen.dart';

class DonorMyBagScreen extends StatefulWidget {
  static String name = 'donor-my-bag';
  static String route = '/donor-my-bag';
  const DonorMyBagScreen({super.key});

  @override
  State<DonorMyBagScreen> createState() => _DonorMyBagScreenState();
}

class _DonorMyBagScreenState extends State<DonorMyBagScreen> {
  final CartCache cartCache = CartCache.instance;
  final UserCache userCache = UserCache.instance;
  final BusinessCache businessCache = BusinessCache.instance;

  num fee = 0;
  num _deliveryFee = 0;
  num totalAmount = 0;
  num subTotal = 0;
  final TextEditingController numberOfDonee = TextEditingController(text: '');
  final TextEditingController deliveryAddressController =
      TextEditingController();
  List<String> orderPref = [
    'Once a day',
    'Twice a day',
    'Thrice a day',
  ];

  bool isLoading = true;
  bool value1 = true;
  bool value2 = false;
  bool value3 = true;
  bool value4 = false;

  String? selectedValue;
  String? deliveryLocationId;
  String? _numberOfDonee = "0";

  @override
  void initState() {
    _updateFee();
    super.initState();

    selectedValue = orderPref.first;
  }

  _setNumberOfDonee(String value) {
    setState(
      () {
        _numberOfDonee = value == "Others" ? "Others" : value;
        numberOfDonee.text =
            _numberOfDonee! == "Others" ? "1" : _numberOfDonee!;
      },
    );
  }

  _updateFee() {
    print("Heelo");
    setState(
      () {
        fee = _deliveryFee *
            (numberOfDonee.text.isNotEmpty ? num.parse(numberOfDonee.text) : 1);
        subTotal = cartCache.fees().$1;
        totalAmount = ((subTotal *
                num.parse(
                    numberOfDonee.text.isEmpty ? '1' : numberOfDonee.text)) +
            (!value2 ? fee : 0));
      },
    );
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    context.read<BagBloc>().add(GetCartsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FoodBankAppBar(
        title: 'My Bag',
        end: cartCache.isCartsEmpty
            ? const SizedBox.shrink()
            : InkWell(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  context.read<BagBloc>().add(RemoveAllCartEvent());
                },
                child: Text(
                  "Empty My Bag",
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
      ),
      body: BlocConsumer<BagBloc, BagState>(
        listener: (context, state) {
          if (state is GettingCartSuccessful) {
            cartCache.carts = state.carts;
            _updateFee();
            setState(() {
              isLoading = false;
            });
          } else if (state is AddingToCartSuccessful) {
            context.read<BagBloc>().add(
                  GetCartsEvent(),
                );
          } else if (state is RemovingToCartSuccessful) {
            context.read<BagBloc>().add(
                  GetCartsEvent(),
                );
          }
        },
        builder: (context, state) {
          return state is GettingCart && isLoading
              ? Center(
                  child: CustomIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : cartCache.isCartsEmpty
                  ? const NotFound(
                      message: "No item Bagged.",
                      showButton: false,
                    )
                  : RefreshIndicator(
                      onRefresh: _refresh,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'My Bag summary',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                ...cartCache.carts.map((cart) {
                                  return SingleCartBag(cart: cart);
                                }),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/user_group.svg'),
                                      const SizedBox(width: 20),
                                      Text(
                                          'Number of people you want to donate to?',
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      '10',
                                      '50',
                                      '100',
                                      '300',
                                      '500',
                                      'Others'
                                    ].map(
                                      (e) {
                                        return NumberOfDonations(
                                          numbers: e,
                                          isActive: e == _numberOfDonee,
                                          onChange: () {
                                            _setNumberOfDonee(e);
                                            _updateFee();
                                          },
                                        );
                                      },
                                    ).toList(),
                                  ),
                                  if (_numberOfDonee == 'Others') ...{
                                    const SizedBox(height: 30),
                                    Text(
                                        'Enter the number of people you want to donate to.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium),
                                    const SizedBox(height: 10),
                                    FoodBankTextField(
                                      hintText: 'Enter the quantity',
                                      keyboardType: TextInputType.number,
                                      controller: numberOfDonee,
                                      onChanged: (String value) {
                                        _updateFee();
                                      },
                                    ),
                                  },
                                  if (!value2) ...{
                                    const SizedBox(height: 20),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Nearest Delivery Location',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(fontSize: 20),
                                        ),
                                        const SizedBox(height: 10),
                                        FoodBankTextField(
                                          readOnly: true,
                                          controller: deliveryAddressController,
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return DeliveryLocationSheet(
                                                  deliveryLocation:
                                                      businessCache
                                                          .deliveryLocations(
                                                              cartCache
                                                                  .carts
                                                                  .first
                                                                  .vendorId),
                                                  onSelected: (address,
                                                      deliveryFee, addressId) {
                                                    setState(
                                                      () {
                                                        _deliveryFee =
                                                            num.parse(
                                                                deliveryFee);
                                                        deliveryAddressController
                                                            .text = address;
                                                        deliveryLocationId =
                                                            addressId;
                                                      },
                                                    );
                                                    _updateFee();
                                                  },
                                                );
                                              },
                                            );
                                          },
                                          hintText:
                                              "Select your delivery location",
                                          suffix: const Icon(
                                            Icons.keyboard_arrow_down_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  },
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Donate for general public',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      FoodBankToggleSwitch(
                                        value: value4,
                                        onToggle: (value) {
                                          setState(() {
                                            value4 = !value4;
                                            value4 = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Include Delivery Average',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      FoodBankToggleSwitch(
                                        value: value1,
                                        onToggle: (value) {
                                          setState(() {
                                            value1 = !value1;
                                            value1 = value;
                                            value2 = !value2;
                                          });
                                          _updateFee();
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Pickup',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      FoodBankToggleSwitch(
                                        value: value2,
                                        onToggle: (value) {
                                          setState(() {
                                            value2 = !value2;
                                            value2 = value;
                                            value1 = !value1;
                                          });
                                          _updateFee();
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Make it anonymous',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      FoodBankToggleSwitch(
                                        value: value3,
                                        onToggle: (value) {
                                          setState(() {
                                            value3 = !value3;
                                            value3 = value;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 30),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Order summary',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium
                                            ?.copyWith(fontSize: 20),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Sub-total',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge),
                                          Text(
                                            '₦${(subTotal * num.parse(numberOfDonee.text.isEmpty ? '1' : numberOfDonee.text)).toString().formatAmount()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(
                                                        0xFF98A2B3)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Delivery fee',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge),
                                          Text(
                                            '₦${value1 ? fee.toString().formatAmount() : "0"}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(
                                                        0xFF98A2B3)),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('Total',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge
                                                  ?.copyWith(
                                                    fontSize: 16,
                                                  )),
                                          Text(
                                            '₦${totalAmount.toString().formatAmount()}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: const Color(
                                                        0xFF98A2B3)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
        },
      ),
      bottomNavigationBar: cartCache.isCartsEmpty
          ? const SizedBox.shrink()
          : BottomAppBar(
              color: Colors.white,
              surfaceTintColor: Colors.white,
              child: Center(
                child: BlocConsumer<CheckoutBloc, CheckoutState>(
                  listener: (context, state) {
                    if (state is CreatingDonationSuccessful) {
                      context.read<BagBloc>().add(
                            RemoveAllCartEvent(),
                          );

                      context.go(
                        DonorHoldOnTightScreen.route,
                        extra: state.res.donation,
                      );
                    } else if (state is CreatingDonationFail) {
                      if (state.error.toLowerCase() == "insufficient balance") {
                        context.push(EmptyWalletMessageScreen.route);
                      } else {
                        context.buildError(state.error);
                      }
                    }
                  },
                  builder: (context, state) => ElevatedButton(
                    onPressed: () {
                      if (numberOfDonee.text.isEmpty ||
                          numberOfDonee.text == "Others") {
                        return;
                      }

                      if (!value2 && deliveryAddressController.text.isEmpty) {
                        context.buildError(
                            "Nearest Delivery Location is required.");
                        return;
                      }

                      if ((num.parse(userCache.wallet.balance!) - totalAmount)
                          .toString()
                          .startsWith("-")) {
                        context.push(EmptyWalletMessageScreen.route);
                        return;
                      }
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.transparent,
                            contentPadding: const EdgeInsets.all(0),
                            insetPadding: const EdgeInsets.all(0),
                            content: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Summary",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF000000),
                                            ),
                                      ),
                                      const Divider(
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(height: 5),
                                      ...cartCache.carts.map((cart) {
                                        return Builder(builder: (context) {
                                          return KeyPairValue(
                                            "${cart..name}\n₦${cart..price.toString().formatAmount()}",
                                            "Per person \nx${cart.quantity} QTY",
                                            boldTitle: true,
                                          );
                                        });
                                      }),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Payment Summary",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall
                                            ?.copyWith(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF000000),
                                            ),
                                      ),
                                      const SizedBox(height: 10),
                                      KeyPairValue(
                                        "Wallet Balance",
                                        "₦${userCache.wallet.balance.toString().formatAmount()}",
                                      ),
                                      KeyPairValue(
                                        "Delivery Fee",
                                        '₦${fee.toString().formatAmount()}',
                                      ),
                                      KeyPairValue(
                                        "Total Order Amount",
                                        "₦${totalAmount.toString().formatAmount()}",
                                      ),
                                      KeyPairValue(
                                        "New Balance",
                                        "₦${(num.parse(userCache.wallet.balance!) - totalAmount).toString().formatAmount()}",
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: SizedBox(
                                              height: 36,
                                              width: 153,
                                              child: OpenElevatedButton(
                                                onPressed: () {
                                                  context.pop();
                                                },
                                                child: Center(
                                                  child: Text('Cancel',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Expanded(
                                            child: SizedBox(
                                              height: 36,
                                              width: 153,
                                              child: CustomButton(
                                                onTap: () {
                                                  context.pop();
                                                  context
                                                      .read<CheckoutBloc>()
                                                      .add(
                                                        DonatingEvent(
                                                          isAnonymous: value3,
                                                          privateDonation:
                                                              value4
                                                                  ? "0"
                                                                  : "1",
                                                          noOfPeople: num.parse(
                                                              numberOfDonee
                                                                  .text),
                                                          products: cartCache
                                                              .toJson(),
                                                          type: value2
                                                              ? "pickup"
                                                              : "delivery",
                                                          vendorId: cartCache
                                                              .carts
                                                              .first
                                                              .vendorId!
                                                              .toString(),
                                                        ),
                                                      );
                                                },
                                                text: 'Proceed',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(45),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (state is CreatingDonation) ...{
                          const CustomIndicator(),
                        } else ...{
                          SvgPicture.asset('assets/icons/wallet.svg',
                              color: Colors.white),
                          const Text('  Pay'),
                        },
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}

class FoodBankToggleSwitch extends StatelessWidget {
  const FoodBankToggleSwitch({
    super.key,
    this.value = false,
    required this.onToggle,
  });

  final bool value;
  final Function(bool value) onToggle;

  @override
  Widget build(BuildContext context) {
    return FlutterSwitch(
      width: 32.5,
      height: 20,
      padding: 1.25,
      toggleSize: 18,
      borderRadius: 30,
      activeColor: const Color(0xFFEB5017),
      inactiveColor: const Color(0xFFE4E7EC),
      value: value,
      onToggle: onToggle,
    );
  }
}

class NumberOfDonations extends StatelessWidget {
  const NumberOfDonations({
    super.key,
    required this.numbers,
    required this.isActive,
    required this.onChange,
  });

  final String? numbers;
  final bool isActive;
  final Function() onChange;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChange,
      child: Container(
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFAD3307) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFAD3307),
          ),
        ),
        child: Center(
          child: Text(
            '$numbers',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isActive ? Colors.white : const Color(0xFFAD3307),
                ),
          ),
        ),
      ),
    );
  }
}
