// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/bottom_sheets/send_as_a_gift_sheet.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/core/utils/debouncer.dart';
import 'package:food_bank/screens/user_account_screens/checkout/models/checkout_model.dart';
import 'package:food_bank/screens/user_account_screens/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:food_bank/screens/user_account_screens/hold_on_tight_screen.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/models/bag_model.dart';
import 'package:go_router/go_router.dart';

import '../../common/bottom_sheets/delivery_location_sheet.dart';
import '../../common/bottom_sheets/enter_delivery_address_sheet.dart';
import '../../core/cache/cache_key.dart';
import '../../core/cache/cache_store.dart';
import 'auth/cache/user_cache.dart';
import 'auth/presentation/screens/signin_screen.dart';
import 'empty_wallet_message_screen.dart';
import 'home/home_page/cache/business_cache.dart';
import 'home/my_bag_page/cache/cart_cache.dart';
import 'home/my_bag_page/presentation/bloc/bag_bloc.dart';
import 'home/user_page/cache/address_cache.dart';
import 'webview_screen.dart';

class MyBagScreen extends StatefulWidget {
  static String name = 'myBag';
  static String route = '/myBag';
  const MyBagScreen({super.key});

  @override
  State<MyBagScreen> createState() => _MyBagScreenState();
}

class _MyBagScreenState extends State<MyBagScreen> {
  final CartCache cartCache = CartCache.instance;
  final AddressCache addressCache = AddressCache.instance;
  final UserCache userCache = UserCache.instance;
  final BusinessCache businessCache = BusinessCache.instance;
  Order? order;
  bool isLoading = false;

  num newDeliveryFee = 0;
  num deliveryFee = 0;

  List<String> orderPref = [
    'Once a day',
    'Twice a day',
    'Thrice a day',
  ];
  List<String> timelineSubscription = [
    'A Week',
    'A Month',
  ];

  TextEditingController deliveryLocationController = TextEditingController();
  TextEditingController deliveryAddressController = TextEditingController();
  TextEditingController selectedStartDate = TextEditingController();
  TextEditingController selectedEndDate = TextEditingController();
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController toPhoneController = TextEditingController();

  String deliveryLocationId = "";
  String selectedTimeline = "";
  String selectedSubDeliveryType = '';
  int _selectedTimeline(String value) {
    if (isSelected1 || isSelected2 || selectedTimeline.isEmpty) return 1;
    if (value == "A Week") {
      return 6;
    } else {
      return 29;
    }
  }

  int _selectedValue(String value) {
    if (isSelected1 || isSelected2) return 1;
    if (value == "Once a day") {
      return 1;
    } else if (value == "Twice a day") {
      return 2;
    } else {
      return 3;
    }
  }

  bool isSelected1 = true;
  bool isSelected2 = false;
  bool isSelected3 = false;

  void changeState1() {
    setState(() {
      isSelected1 = true;
      selectedTimeline = "";
      selectedSubDeliveryType = '';
      deliveryLocationController.text = "";
      newDeliveryFee = 0;
    });
    if (isSelected1 == true) {
      isSelected2 = false;
      isSelected3 = false;
    }
  }

  void changeState2() {
    setState(() {
      isSelected2 = true;
      selectedTimeline = "";
      selectedSubDeliveryType = '';
      deliveryLocationController.text = "";
      newDeliveryFee = 0;
    });
    if (isSelected2 == true) {
      isSelected1 = false;
      isSelected3 = false;
    }
  }

  void changeState3() {
    setState(() {
      isSelected3 = true;
      selectedTimeline = "";
      selectedSubDeliveryType = '';
      deliveryLocationController.text = "";
      newDeliveryFee = 0;
    });
    if (isSelected3 == true) {
      isSelected1 = false;
      isSelected2 = false;
    }
  }

  String? selectedValue;

  @override
  void initState() {
    super.initState();

    selectedValue = orderPref.first;
    deliveryAddressController.text = addressCache.defaultAddress;
  }

  (num, num) calculateTotal() {
    final startDateAndEndDateCompare = selectedEndDate.text.isNotEmpty
        ? isSelected3
            ? DateTime.parse(selectedEndDate.text.isEmpty
                        ? DateTime.now().toIso8601String()
                        : selectedEndDate.text)
                    .difference(DateTime.parse(selectedStartDate.text.isEmpty
                        ? DateTime.now().toIso8601String()
                        : selectedStartDate.text))
                    .inDays +
                1
            : 1
        : 0;
    newDeliveryFee = startDateAndEndDateCompare != 0
        ? deliveryFee *
            (startDateAndEndDateCompare) *
            _selectedValue(selectedValue!)
        : deliveryFee * _selectedValue(selectedValue!);
    final totalAmount = selectedSubDeliveryType == "Pickup" || isSelected2
        ? (startDateAndEndDateCompare == 0
                ? cartCache.fees()
                : cartCache.fees() * startDateAndEndDateCompare) *
            _selectedValue(selectedValue!)
        : newDeliveryFee +
            (startDateAndEndDateCompare == 0
                    ? cartCache.fees()
                    : cartCache.fees() * startDateAndEndDateCompare) *
                _selectedValue(selectedValue!);

    return (totalAmount, startDateAndEndDateCompare);
  }

  Future<void> _refresh() async {
    setState(() {
      isLoading = true;
    });
    context.read<BagBloc>().add(GetCartsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BagBloc, BagState>(
      listener: (context, state) {
        if (state is GettingCartSuccessful) {
          calculateTotal();
          setState(() {
            isLoading = false;
          });
        } else if (state is RemovingToCartSuccessful) {
          context.read<BagBloc>().add(
                GetCartsEvent(),
              );
        }
      },
      builder: (context, state) {
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
          body: state is GettingCart && isLoading
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
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                thickness: 0.5,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(64),
                                          color: const Color(0xFFEEF0F4),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  changeState1();
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 108,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                    color: isSelected1 == true
                                                        ? Colors.black
                                                        : null,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Delivery',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color:
                                                                isSelected1 ==
                                                                        true
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  changeState2();
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 108,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                    color: isSelected2 == true
                                                        ? Colors.black
                                                        : null,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Pickup',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color:
                                                                isSelected2 ==
                                                                        true
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  changeState3();
                                                },
                                                child: Container(
                                                  height: 40,
                                                  width: 108,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32),
                                                    color: isSelected3 == true
                                                        ? Colors.black
                                                        : null,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      'Reoccurring',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                            color:
                                                                isSelected3 ==
                                                                        true
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                          ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    Text(
                                      'My Bag Summary',
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
                                  ...cartCache.carts.map(
                                    (cart) {
                                      return Builder(builder: (context) {
                                        return SingleCartBag(cart: cart);
                                      });
                                    },
                                  ),
                                  const Divider(
                                    thickness: 0.5,
                                  ),
                                  if (isSelected3)
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Whats your delivery type',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            height: 60,
                                            width: double.infinity,
                                            child: DropdownButtonFormField(
                                              hint: const Text(
                                                  "Select delivery type"),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              items: ["Delivery", "Pickup"]
                                                  .map(
                                                    (timeline) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: timeline,
                                                      child: Text(timeline),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (timeline) {
                                                setState(
                                                  () {
                                                    selectedSubDeliveryType =
                                                        timeline!;
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (isSelected1 ||
                                      (selectedSubDeliveryType == "Delivery" &&
                                          isSelected3))
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Nearest Delivery Location',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge),
                                          const SizedBox(height: 5),
                                          FoodBankTextField(
                                            readOnly: true,
                                            controller:
                                                deliveryLocationController,
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
                                                    onSelected: (address, fee,
                                                        addressId) {
                                                      setState(
                                                        () {
                                                          deliveryFee =
                                                              num.parse(fee);
                                                          deliveryLocationController
                                                              .text = address;
                                                          deliveryLocationId =
                                                              addressId;
                                                        },
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            },
                                            hintText:
                                                "Select your delivery location",
                                            suffix: const Icon(
                                              Icons
                                                  .keyboard_arrow_down_outlined,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (isSelected1)
                                    DeliveryAddressContent(
                                      address: deliveryAddressController.text,
                                      onAddAddress: (
                                        String address,
                                        lng,
                                        lat,
                                      ) {
                                        setState(() {
                                          deliveryAddressController.text =
                                              address;
                                        });
                                      },
                                    ),
                                  if (isSelected2)
                                    PickupAddressContent(
                                      address: businessCache.businessLocations(
                                          cartCache.carts.first.vendorId),
                                    ),
                                  if (isSelected3)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Whats your subscription timeline',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            height: 60,
                                            width: double.infinity,
                                            child: DropdownButtonFormField(
                                              hint:
                                                  const Text("Select timeline"),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              items: timelineSubscription
                                                  .map(
                                                    (timeline) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: timeline,
                                                      child: Text(timeline),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (timeline) {
                                                setState(
                                                  () {
                                                    selectedTimeline =
                                                        timeline!;
                                                    selectedStartDate.text = '';
                                                    selectedEndDate.text = '';
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            'You choose either a week or a month',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color(
                                                        0xFF98A2B3)),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Whats your order preference',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge),
                                          const SizedBox(height: 10),
                                          SizedBox(
                                            height: 60,
                                            width: double.infinity,
                                            child: DropdownButtonFormField(
                                              hint: const Text(
                                                  "Select preference"),
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                disabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                errorBorder: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    width: 1,
                                                    color: Colors.black,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              items: orderPref
                                                  .map(
                                                    (timeline) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                      value: timeline,
                                                      child: Text(timeline),
                                                    ),
                                                  )
                                                  .toList(),
                                              onChanged: (s) {
                                                setState(
                                                  () {
                                                    selectedValue = s;
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          FoodBankTextField(
                                            labelText: "Start Date",
                                            hintText: "Select your start date",
                                            controller: selectedStartDate,
                                            readOnly: true,
                                            onTap: () async {
                                              final todayDate = DateTime.now();
                                              final selectedDate =
                                                  await showDatePicker(
                                                context: context,
                                                initialDate: todayDate,
                                                firstDate: todayDate,
                                                lastDate: DateTime.parse(
                                                    '${todayDate.year + 10}-${todayDate.month > 9 ? todayDate.month : '0${todayDate.month}'}-${todayDate.day > 9 ? todayDate.day : '0${todayDate.day}'}'),
                                              );
                                              if (selectedDate != null) {
                                                setState(
                                                  () {
                                                    selectedStartDate.text =
                                                        selectedDate
                                                            .toString()
                                                            .split(' ')
                                                            .first;
                                                    selectedEndDate
                                                        .text = DateTime.parse(
                                                            '${selectedDate.year}-${selectedDate.month > 9 ? selectedDate.month : '0${selectedDate.month}'}-${selectedDate.day + _selectedTimeline(selectedTimeline) > 9 ? selectedDate.day + _selectedTimeline(selectedTimeline) : '0${selectedDate.day + _selectedTimeline(selectedTimeline)}'}')
                                                        .toString()
                                                        .split(' ')
                                                        .first;
                                                  },
                                                );
                                              }
                                            },
                                            suffix: InkWell(
                                              onTap: () async {
                                                final todayDate =
                                                    DateTime.now();
                                                final selectedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: todayDate,
                                                  firstDate: todayDate,
                                                  lastDate: DateTime.parse(
                                                      '${todayDate.year + 10}-${todayDate.month > 9 ? todayDate.month : '0${todayDate.month}'}-${todayDate.day > 9 ? todayDate.day : '0${todayDate.day}'}'),
                                                );
                                                if (selectedDate != null) {
                                                  setState(
                                                    () {
                                                      selectedStartDate.text =
                                                          selectedDate
                                                              .toString()
                                                              .split(' ')
                                                              .first;
                                                      selectedEndDate
                                                          .text = DateTime.parse(
                                                              '${selectedDate.year}-${selectedDate.month > 9 ? selectedDate.month : '0${selectedDate.month}'}-${selectedDate.day + _selectedTimeline(selectedTimeline) > 9 ? selectedDate.day + _selectedTimeline(selectedTimeline) : '0${selectedDate.day + _selectedTimeline(selectedTimeline)}'}')
                                                          .toString()
                                                          .split(' ')
                                                          .first;
                                                    },
                                                  );
                                                }
                                              },
                                              child: const Icon(
                                                Icons.calendar_today,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          FoodBankTextField(
                                            labelText: "End Date",
                                            hintText: "Select your end date",
                                            controller: selectedEndDate,
                                            readOnly: true,
                                            // onTap: selectedStartDate.text == ""
                                            //     ? null
                                            // : () async {
                                            //     final startDate = DateTime.parse(
                                            //         selectedStartDate.text);
                                            //     final todayDate = DateTime.parse(
                                            //         '${startDate.year}-${startDate.month > 9 ? startDate.month : '0${startDate.month}'}-${startDate.day + _selectedTimeline(selectedTimeline) > 9 ? startDate.day + _selectedTimeline(selectedTimeline) : '0${startDate.day + _selectedTimeline(selectedTimeline)}'}');
                                            //     final selectedDate =
                                            //         await showDatePicker(
                                            //       context: context,
                                            //       initialDate: todayDate,
                                            //       firstDate: todayDate,
                                            //       lastDate: DateTime.parse(
                                            //           '${todayDate.year + 10}-${todayDate.month > 9 ? todayDate.month : '0${todayDate.month}'}-${todayDate.day > 9 ? todayDate.day : '0${todayDate.day}'}'),
                                            //     );
                                            //     if (selectedDate != null) {
                                            //       setState(
                                            //         () {
                                            //           selectedEndDate.text =
                                            //               selectedDate
                                            //                   .toString()
                                            //                   .split(' ')
                                            //                   .first;
                                            //         },
                                            //       );
                                            //     }
                                            //   },
                                            // suffix: InkWell(
                                            //   onTap: () async {
                                            // final startDate = DateTime.parse(
                                            //     selectedStartDate.text);
                                            // final todayDate = DateTime.parse(
                                            //     '${startDate.year}-${startDate.month > 9 ? startDate.month : '0${startDate.month}'}-${startDate.day + _selectedTimeline(selectedTimeline) > 9 ? startDate.day + _selectedTimeline(selectedTimeline) : '0${startDate.day + _selectedTimeline(selectedTimeline)}'}');

                                            // final selectedDate =
                                            //     await showDatePicker(
                                            //   context: context,
                                            //   initialDate: todayDate,
                                            //   firstDate: todayDate,
                                            //   lastDate: DateTime.parse(
                                            //       '${todayDate.year + 10}-${todayDate.month > 9 ? todayDate.month : '0${todayDate.month}'}-${todayDate.day > 9 ? todayDate.day : '0${todayDate.day}'}'),
                                            // );
                                            // if (selectedDate != null) {
                                            //   setState(
                                            //     () {
                                            //       selectedEndDate.text =
                                            //           selectedDate
                                            //               .toString()
                                            //               .split(' ')
                                            //               .first;
                                            //     },
                                            //   );
                                            // }
                                            //   },
                                            //   child: const Icon(
                                            //     Icons.calendar_today,
                                            //     color: Colors.grey,
                                            //   ),
                                            // ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  const SizedBox(height: 20),
                                  const Divider(
                                    thickness: 0.5,
                                  ),
                                  toController.text.isNotEmpty
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          width: double.infinity,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Send as gift to:",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(fontSize: 16),
                                              ),
                                              const SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Full Name: ${toController.text.capitalize()} ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                      ),
                                                      Text(
                                                        "Phone Number: ${toPhoneController.text} ",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .headlineMedium
                                                            ?.copyWith(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        isScrollControlled:
                                                            true,
                                                        isDismissible: false,
                                                        useSafeArea: true,
                                                        builder: (context) {
                                                          return SingleChildScrollView(
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom,
                                                              ),
                                                              child:
                                                                  SendAsAGiftBottomSheet(
                                                                senderAndRReceiver:
                                                                    (
                                                                  from,
                                                                  to,
                                                                  phone,
                                                                  address,
                                                                ) {
                                                                  setState(
                                                                    () {
                                                                      fromController
                                                                              .text =
                                                                          from;
                                                                      toController
                                                                          .text = to;
                                                                      toPhoneController
                                                                              .text =
                                                                          phone;
                                                                      deliveryAddressController
                                                                              .text =
                                                                          address;
                                                                    },
                                                                  );
                                                                },
                                                                to: toController
                                                                    .text,
                                                                toPhone:
                                                                    toPhoneController
                                                                        .text,
                                                                address:
                                                                    deliveryAddressController
                                                                        .text,
                                                                isPickup: isSelected2 ||
                                                                    selectedSubDeliveryType ==
                                                                        "Pickup",
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 24,
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: const Color(
                                                              0xFFF56630)),
                                                      child: Center(
                                                          child: Text(
                                                        'Change',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyLarge
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .white),
                                                      )),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      : SendGiftsOption(
                                          giftInfo: (from, to, phone, address) {
                                            setState(
                                              () {
                                                fromController.text = from;
                                                toController.text = to;
                                                toPhoneController.text = phone;
                                                deliveryAddressController.text =
                                                    address;
                                              },
                                            );
                                          },
                                          to: toController.text,
                                          phone: toPhoneController.text,
                                          address:
                                              deliveryAddressController.text,
                                          isPickUp: isSelected2 ||
                                              selectedSubDeliveryType ==
                                                  "Pickup",
                                        ),
                                  const Divider(
                                    thickness: 0.5,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                        Text(
                                          'Sub-total',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        Text(
                                          calculateTotal().$2 == 0
                                              ? '₦${(cartCache.fees()).toString().formatAmount()}'
                                              : '₦${((cartCache.fees() * calculateTotal().$2) * _selectedValue(selectedValue!)).toString().formatAmount()}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      const Color(0xFF98A2B3)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Delivery fee',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        Text(
                                          '₦${(isSelected2 || selectedSubDeliveryType == "Pickup" && (!isSelected1)) ? 0 : newDeliveryFee.toString().formatAmount()}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      const Color(0xFF98A2B3)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 15),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge
                                              ?.copyWith(
                                                fontSize: 16,
                                              ),
                                        ),
                                        Text(
                                          '₦${calculateTotal().$1.toString().formatAmount()}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineSmall
                                              ?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF98A2B3),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
          bottomNavigationBar: !cartCache.isCartsEmpty
              ? BottomAppBar(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  child: BlocConsumer<CheckoutBloc, CheckoutState>(
                    listener: (context, state) {
                      print(state);
                      if (state is CheckingOutSuccessful) {
                        setState(() {
                          order = state.res.order;
                        });
                        if (state.res.paymentUrl != null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PaymentPageForCheckout(
                                url: state.res.paymentUrl!,
                                paymentUrl: "https://api-dev.foodbank.africa",
                                onDismiss: (txUrl) {
                                  context.read<CheckoutBloc>().add(
                                        VerifyTransactionEvent(
                                          state.res.transactionRef!,
                                        ),
                                      );
                                },
                              ),
                            ),
                          );
                        } else {
                          context.read<BagBloc>().add(
                                RemoveAllCartEvent(),
                              );

                          context.go(
                            HoldOnTightScreen.route,
                            extra: state.res.order!.id.toString(),
                          );
                        }
                      } else if (state is CheckingOutFail) {
                        if (state.error.toLowerCase() == "unauthenticated") {
                          context.buildError(state.error);
                          CacheStore().remove(key: CacheKey.token);
                          Future.delayed(const Duration(seconds: 2), () {
                            context.go(SignInScreen.route);
                          });
                        } else if (state.error.toLowerCase() ==
                            "insufficient balance") {
                          context.push(EmptyWalletMessageScreen.route);
                        } else {
                          context.buildError(state.error);
                        }
                      } else if (state is VerifyTransactionSuccessful) {
                        context.read<BagBloc>().add(
                              RemoveAllCartEvent(),
                            );

                        context.go(
                          HoldOnTightScreen.route,
                          extra: order!.id.toString(),
                        );
                      }
                    },
                    builder: (context, state) => state is CheckingOut
                        ? const Center(
                            child: CustomIndicator(
                            color: Color(0xFFF56630),
                          ))
                        : Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  borderRadius: 30,
                                  onTap: () {
                                    if ((isSelected1 ||
                                            (selectedSubDeliveryType ==
                                                    "Delivery" &&
                                                isSelected3)) &&
                                        deliveryLocationController
                                            .text.isEmpty) {
                                      context.buildError(
                                          "Nearest Delivery Location is required.");
                                      return;
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          insetPadding: const EdgeInsets.all(0),
                                          content: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Will you like to continue your payment with card?",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .headlineSmall
                                                          ?.copyWith(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            color: const Color(
                                                                0xFF000000),
                                                          ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 36,
                                                            width: 153,
                                                            child:
                                                                OpenElevatedButton(
                                                              onPressed: () {
                                                                context.pop();
                                                              },
                                                              child: Center(
                                                                child: Text(
                                                                    'Cancel',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 36,
                                                            width: 153,
                                                            child: CustomButton(
                                                              onTap: () {
                                                                _onPay(true);
                                                              },
                                                              text: 'Continue',
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
                                  text: "Pay with card",
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: OpenElevatedButton(
                                  borderRadius: 30,
                                  onPressed: () {
                                    if ((isSelected1 ||
                                            (selectedSubDeliveryType ==
                                                    "Delivery" &&
                                                isSelected3)) &&
                                        deliveryLocationController
                                            .text.isEmpty) {
                                      context.buildError(
                                          "Nearest Delivery Location is required.");
                                      return;
                                    }
                                    if (deliveryAddressController
                                            .text.isEmpty &&
                                        !isSelected2) {
                                      context.buildError(
                                          "Delivery address is required.");
                                      return;
                                    }
                                    if (isSelected3 &&
                                        (selectedStartDate.text.isEmpty ||
                                            selectedEndDate.text.isEmpty ||
                                            selectedTimeline.isEmpty ||
                                            selectedSubDeliveryType.isEmpty ||
                                            selectedValue == null)) {
                                      context.buildError(
                                          "All fields are required.");
                                      return;
                                    }
                                    if ((num.parse(userCache.wallet.balance!) -
                                            calculateTotal().$1)
                                        .toString()
                                        .startsWith("-")) {
                                      context
                                          .push(EmptyWalletMessageScreen.route);
                                      return;
                                    }
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          contentPadding:
                                              const EdgeInsets.all(0),
                                          insetPadding: const EdgeInsets.all(0),
                                          content: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
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
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color(
                                                                0xFF000000),
                                                          ),
                                                    ),
                                                    const Divider(
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(height: 5),
                                                    ...cartCache.carts
                                                        .map((cart) {
                                                      return Builder(
                                                          builder: (context) {
                                                        return KeyPairValue(
                                                          "${cart.name}\n₦${cart.price.toString().formatAmount()}",
                                                          "x${cart.quantity} QTY",
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
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: const Color(
                                                                0xFF000000),
                                                          ),
                                                    ),
                                                    const SizedBox(height: 5),
                                                    KeyPairValue(
                                                      "Wallet Balance",
                                                      "₦${userCache.wallet.balance!.toString().formatAmount()}",
                                                    ),
                                                    KeyPairValue(
                                                      "Delivery Fee",
                                                      '₦${(isSelected2 || selectedSubDeliveryType == "Pickup" && (!isSelected1)) ? 0 : newDeliveryFee.toString().formatAmount()}',
                                                    ),
                                                    KeyPairValue(
                                                      "Total Order Amount",
                                                      "₦${calculateTotal().$1.toString().formatAmount()}",
                                                    ),
                                                    KeyPairValue(
                                                      "New Balance",
                                                      "₦${((num.parse(userCache.wallet.balance!) - calculateTotal().$1).toString()).toString().formatAmount()}",
                                                    ),
                                                    const SizedBox(height: 20),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 36,
                                                            width: 153,
                                                            child:
                                                                OpenElevatedButton(
                                                              onPressed: () {
                                                                context.pop();
                                                              },
                                                              child: Center(
                                                                child: Text(
                                                                    'Back',
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 20),
                                                        Expanded(
                                                          child: SizedBox(
                                                            height: 36,
                                                            width: 153,
                                                            child: CustomButton(
                                                              onTap: () =>
                                                                  _onPay(false),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (state is CheckingOut) ...{
                                        const CustomIndicator(),
                                      } else ...{
                                        // SvgPicture.asset(
                                        //   'assets/icons/wallet.svg',
                                        //   color: Colors.white,
                                        // ),
                                        const Text('  Pay with wallet')
                                      },
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }

  void _onPay(bool payWithCard) {
    final subTotal = cartCache.fees();
    context.pop();
    final (branchId, businessId) =
        businessCache.businessBranchId(cartCache.carts.first.vendorId);
    context.read<CheckoutBloc>().add(
          CheckingOutEvent(
            isCard: payWithCard,
            branchId: branchId,
            businessId: businessId,
            address: deliveryAddressController.text,
            deliveryLocation: deliveryLocationId,
            deliveryFee: newDeliveryFee,
            products: cartCache.toJson(),
            type: isSelected1
                ? "delivery"
                : isSelected2
                    ? "pickup"
                    : "reoccurring",
            subTotal: (subTotal * _selectedTimeline(selectedTimeline)) *
                _selectedValue(selectedValue!),
            total: selectedSubDeliveryType == "Pickup" || isSelected2
                ? (subTotal * _selectedTimeline(selectedTimeline)) *
                    _selectedValue(selectedValue!)
                : newDeliveryFee +
                    (subTotal * _selectedTimeline(selectedTimeline)) *
                        _selectedValue(selectedValue!),
            vendorId: cartCache.carts.first.vendorId!.toString(),
            from: fromController.text,
            to: toController.text,
            toPhone: toPhoneController.text,
            startDate: selectedStartDate.text,
            endDate: selectedEndDate.text,
            subTimeline: _selectedTimeline(selectedTimeline),
            subDeliveryType: selectedSubDeliveryType,
            subPreference: _selectedValue(selectedValue!),
          ),
        );
  }
}

class SendGiftsOption extends StatelessWidget {
  const SendGiftsOption({
    super.key,
    required this.giftInfo,
    required this.to,
    required this.phone,
    required this.address,
    this.isPickUp = false,
  });
  final Function(String, String, String, String) giftInfo;
  final String to, phone, address;
  final bool isPickUp;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          isDismissible: false,
          useSafeArea: true,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: SendAsAGiftBottomSheet(
                  senderAndRReceiver: giftInfo,
                  to: to,
                  toPhone: phone,
                  address: address,
                  isPickup: isPickUp,
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  height: 40,
                  width: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0xFFFFECE5)),
                  child: SvgPicture.asset(
                    'assets/icons/inactive-gift-icon.svg',
                    color: const Color(0xFFF56630),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sending as a gift',
                        style: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 5),
                    Text(
                      'Need to send as a gift ?',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF98A2B3)),
                    ),
                  ],
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF98A2B3),
            )
          ],
        ),
      ),
    );
  }
}

class DeliveryAddressContent extends StatefulWidget {
  const DeliveryAddressContent({
    super.key,
    this.address,
    required this.onAddAddress,
    this.horizontalPadding = 20,
  });
  final String? address;
  final double horizontalPadding;
  final Function(String, double, double) onAddAddress;

  @override
  State<DeliveryAddressContent> createState() => _DeliveryAddressContentState();
}

class _DeliveryAddressContentState extends State<DeliveryAddressContent> {
  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Delivery Address',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 24,
                      width: 24,
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFFFECE5)),
                      child: SvgPicture.asset('assets/icons/location-icon.svg'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        widget.address!.isEmpty
                            ? 'Enter your delivery address'
                            : (widget.address ?? ''),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    isDismissible: false,
                    useSafeArea: true,
                    builder: (context) {
                      return EnterDeliveryAddressBottomSheet(
                        controller: controller,
                        onAdd: (lat, lng) {
                          widget.onAddAddress(controller.text, lng, lat);

                          context.pop();
                        },
                      );
                    },
                  );
                },
                child: Container(
                  height: 24,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: const Color(0xFFF56630)),
                  child: Center(
                      child: Text(
                    widget.address!.isEmpty ? 'Enter Address' : 'Change',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white),
                  )),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class PickupAddressContent extends StatelessWidget {
  const PickupAddressContent({
    super.key,
    required this.address,
  });
  final String address;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Pickup Address',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 20),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFFFECE5)),
                      child: SvgPicture.asset('assets/icons/building-icon.svg'),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      // width: 100,
                      child: Text(
                        address,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 24,
                width: 102,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFF56630),
                ),
                child: Center(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Navigate ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: Colors.white),
                    ),
                    SvgPicture.asset('assets/icons/navigate.svg')
                  ],
                )),
              )
            ],
          )
        ],
      ),
    );
  }
}

class SingleCartBag extends StatefulWidget {
  const SingleCartBag({
    super.key,
    required this.cart,
  });
  final Bag cart;

  @override
  State<SingleCartBag> createState() => _SingleCartBagState();
}

class _SingleCartBagState extends State<SingleCartBag> {
  final CartCache cartCache = CartCache.instance;
  late Debouncer _debouncer;
  int qty = 1;
  int oldQTY = 1;

  @override
  void initState() {
    setState(
      () {
        qty = widget.cart.quantity!;
        oldQTY = widget.cart.quantity!;
      },
    );
    _debouncer = Debouncer(
      const Duration(milliseconds: 500),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BagBloc, BagState>(
      listener: (context, state) {
        if (state is AddingToCartSuccessful) {
          context.read<BagBloc>().add(
                GetCartsEvent(),
              );
        } else if (state is AddingToCartFail) {
          context.buildError("Fail to perform request.");
        } else if (state is GettingCartSuccessful) {
          cartCache.carts = state.carts;
        } else if (state is IncrementingQTYSuccessful) {
          context.read<BagBloc>().add(
                GetCartsEvent(),
              );
        } else if (state is DecrementingQTYSuccessful) {
          context.read<BagBloc>().add(
                GetCartsEvent(),
              );
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: 5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CustomCacheImage(
                        image: widget.cart.images ?? '',
                        // scale: 2.4,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.cart.name!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        widget.cart.description ?? '',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF98A2B3),
                                ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₦${(num.parse(widget.cart.price!) * num.parse(widget.cart.quantity.toString())).toString().formatAmount()}',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(width: 35),
                            InkWell(
                              onTap: () {
                                context.read<BagBloc>().add(RemoveCartEvent(
                                      cartCache
                                          .indexOf(widget.cart.id!.toString()),
                                    ));
                              },
                              child: Text(
                                'Remove',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: state is RemovingToCart
                                          ? Colors.grey
                                          : null,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          qty = qty == 1 ? qty : --qty;
                        },
                      );

                      _debouncer.call(() {
                        context.read<BagBloc>().add(
                              DecreaseQTYEvent(
                                cartCache.indexOf(widget.cart.id!.toString()),
                                Bag(
                                  address: widget.cart.address,
                                  images: widget.cart.images,
                                  price: widget.cart.price,
                                  id: widget.cart.id,
                                  vendorId: widget.cart.vendorId,
                                  name: widget.cart.name,
                                  quantity: widget.cart.quantity! == 1
                                      ? widget.cart.quantity
                                      : widget.cart.quantity! - 1,
                                ),
                              ),
                            );
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/icons/minus.svg',
                    ),
                  ),
                  Text(
                    '   $qty  ',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          qty++;
                        },
                      );

                      _debouncer.call(() {
                        context.read<BagBloc>().add(
                              IncreaseQTYEvent(
                                cartCache.indexOf(widget.cart.id!.toString()),
                                Bag(
                                  address: widget.cart.address,
                                  images: widget.cart.images,
                                  price: widget.cart.price,
                                  id: widget.cart.id,
                                  name: widget.cart.name,
                                  vendorId: widget.cart.vendorId,
                                  quantity: widget.cart.quantity! + 1,
                                ),
                              ),
                            );
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/icons/plus.svg',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
