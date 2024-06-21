import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/user_bottom_nav_bar.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../screens/user_account_screens/home/my_bag_page/models/order_model.dart';
import '../../screens/user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';
import '../../screens/user_account_screens/home/my_bag_page/presentation/screens/view_order_summary_screen.dart';

class ThreeStepOrderInProgressBottomSheet extends StatefulWidget {
  const ThreeStepOrderInProgressBottomSheet({
    super.key,
    required this.orderId,
    this.onClose,
  });
  final String orderId;
  final Function()? onClose;

  @override
  State<ThreeStepOrderInProgressBottomSheet> createState() =>
      _ThreeStepOrderInProgressBottomSheetState();
}

class _ThreeStepOrderInProgressBottomSheetState
    extends State<ThreeStepOrderInProgressBottomSheet> {
  Order order = Order();
  Timer? _timer;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Timer.periodic(
      const Duration(seconds: 5),
      (timer) {
        _timer = timer;
        context.read<BagBloc>().add(
              GetOrderEvent(widget.orderId),
            );
      },
    );
  }

  _statusColor(List<String> statuses) {
    for (var status in statuses) {
      if (order.status == status) {
        return const Color(0xFFF56630);
      }
      return const Color(0xFFD0D5DD);
    }
  }

  bool _isStatusActive(String status) {
    return status == (order.status ?? 'pending').toLowerCase();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  _confirm(int patchedNo) {
    context.read<BagBloc>().add(
          ConfirmOrderFilledEvent(
            widget.orderId,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<BagBloc, BagState>(
      listener: (context, state) {
        if (state is GettingOrderSuccessful) {
          setState(() {
            order = state.order;
            isLoading = false;
          });
          if (order.isFulfilled == 1) {
            context.read<BagBloc>().add(GetOrdersEvent(1));
            // context.pop();
          }
        } else if (state is ConfirmingOrderSuccessful) {
          context.read<BagBloc>().add(
                GetOrderEvent(widget.orderId),
              );
          context.pop();

          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return const AlertDialog(
                  backgroundColor: Colors.transparent,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 0,
                  ),
                  insetPadding: EdgeInsets.all(0),
                  content: RateOrder(),
                );
              });
        }
      },
      builder: (context, state) {
        if (isLoading) {
          return const Center(
            child: CustomIndicator(
              color: Color(0xFFF56630),
            ),
          );
        }
        return Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            FoodBankBottomSheetAppBar(
              title: 'Order In Progress',
              onClose: widget.onClose ??
                  () {
                    context.go(UserFoodBankBottomNavigator.route);
                  },
            ),
            const Divider(),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  SvgPicture.asset(
                    _isStatusActive("accepted") ||
                            _isStatusActive("processing") ||
                            _isStatusActive("delivered")
                        ? 'assets/icons/check_indicator.svg'
                        : "assets/icons/radio_indicator.svg",
                  ),
                  Container(
                    height: 2,
                    width: size.width * 0.02,
                    color: const Color(0xFFF56630),
                  ),
                  Container(
                    height: 2,
                    width: 86.16,
                    color: _statusColor(["processing", "delivered"]),
                  ),
                  SvgPicture.asset(
                    _isStatusActive("accepted") ||
                            _isStatusActive("processing") ||
                            _isStatusActive("delivered")
                        ? 'assets/icons/check_indicator.svg'
                        : "assets/icons/radio_indicator.svg",
                  ),
                  Container(
                    height: 2,
                    width: 86.16,
                    color: _statusColor(["delivered"]),
                  ),
                  Container(
                    height: 2,
                    width: size.width * 0.02,
                    color: _statusColor(["delivered", "picked-up", "pick-up"]),
                  ),
                  SvgPicture.asset(
                    _isStatusActive("delivered")
                        ? 'assets/icons/check_indicator.svg'
                        : "assets/icons/radio_indicator.svg",
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Order \nAccepted',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                )),
                    SizedBox(width: size.width * 0.16),
                    Text('Order \nProcessing',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                )),
                    SizedBox(width: size.width * 0.16),
                    Text(
                      'Order \nDelivered',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                    ),
                  ],
                ),
              ],
            ),
            if (_isStatusActive("pending")) const OrderIsAcceptedContent(),
            if (_isStatusActive("processing")) const SentForDeliveryContent(),
            if (_isStatusActive("delivered"))
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    Text(
                      'Order Delivered',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Your order is complete, Thank you for \nordering with us',
                      textAlign: TextAlign.center,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: const Color(0xFF98A2B3)),
                    ),
                    const SizedBox(height: 30),
                    if (state is ConfirmingOrder) ...{
                      const CustomIndicator(
                        color: Color(0xFFF56630),
                      ),
                    } else ...{
                      CustomButton(
                        isLoading: state is ConfirmingOrder,
                        onTap: () {
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
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "I confirm that i have receive my order.",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color:
                                                      const Color(0xFF000000),
                                                ),
                                            textAlign: TextAlign.center,
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
                                                          style:
                                                              Theme.of(context)
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
                                                      context.read<BagBloc>().add(
                                                          ConfirmOrderFilledEvent(
                                                              order.id!
                                                                  .toString()));
                                                    },
                                                    text: 'Confirm',
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
                        text: "Order Received",
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          _confirm(0);
                        },
                        child: const Text(
                          "Didn’t get my order.",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Color(0xFFF56630),
                          ),
                        ),
                      ),
                    },
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Text(
              order.pin ?? '',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Text(
              'Your confirmation code.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: const Color(0xFF98A2B3)),
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: () {
                context.pop();
                context.push(ViewOrderSummaryScreen.route, extra: order);
              },
              child: Text(
                'View Summary',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class RateOrder extends StatelessWidget {
  const RateOrder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                'How was your order ?',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: SvgPicture.asset('assets/icons/thumbs_up.svg'),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      context.pop();
                    },
                    child: SvgPicture.asset('assets/icons/thumbs_down.svg'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SentForDeliveryContent extends StatelessWidget {
  const SentForDeliveryContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        SvgPicture.asset(
          'assets/icons/sent_img.svg',
          height: 150,
        ),
        const SizedBox(height: 10),
        Text(
          'Sent For Delivery',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'The restaurant have sent out your \ndelivery',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: const Color(0xFF98A2B3)),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}

class OrderIsAcceptedContent extends StatelessWidget {
  const OrderIsAcceptedContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 100),
        SvgPicture.asset(
          'assets/icons/order_img.svg',
          height: 150,
        ),
        const SizedBox(height: 10),
        Text(
          'Your order is accepted',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'The restaurant have accepted your order \nwaiting to send it for delivery.',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: const Color(0xFF98A2B3)),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
