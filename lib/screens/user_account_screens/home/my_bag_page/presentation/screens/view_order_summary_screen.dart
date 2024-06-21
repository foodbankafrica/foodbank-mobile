import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../models/order_model.dart';
import '../bloc/bag_bloc.dart';

class ViewOrderSummaryScreen extends StatelessWidget {
  static String name = 'view-order-summary';
  static String route = '/view-order-summary';
  const ViewOrderSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = GoRouterState.of(context).extra as Order;
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'My Order',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(thickness: 0.6),
                  const SizedBox(height: 10),
                  Text(
                    'Order summary',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontSize: 20),
                  ),
                  const SizedBox(height: 20),
                  ...order.orderProducts!.map(
                    (prod) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  prod.products!.name!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(fontSize: 14),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  prod.products!.description!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xFF98A2B3)),
                                ),
                              ],
                            ),
                            Text('₦${prod.price.toString().formatAmount()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontSize: 16)),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                  if (order.status == "delivered" &&
                      order.isFulfilled != 1) ...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "I have received my order",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF000000),
                              ),
                        ),
                        SizedBox(
                          height: 36,
                          width: 153,
                          child: BlocConsumer<BagBloc, BagState>(
                            listener: (context, state) {
                              if (state is ConfirmingOrderSuccessful) {
                                context.toast(content: state.message);
                                // context.pop();
                              } else if (state is ConfirmingOrderFail) {
                                context.buildError(state.error);
                              }
                            },
                            builder: (context, state) {
                              return CustomButton(
                                onTap: state is ConfirmingOrder
                                    ? null
                                    : () {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Colors.transparent,
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              insetPadding:
                                                  const EdgeInsets.all(0),
                                              content: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "I confirm that i have receive my order.",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headlineSmall
                                                                  ?.copyWith(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: const Color(
                                                                        0xFF000000),
                                                                  ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        const SizedBox(
                                                            height: 20),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: SizedBox(
                                                                height: 36,
                                                                width: 153,
                                                                child:
                                                                    OpenElevatedButton(
                                                                  onPressed:
                                                                      () {
                                                                    context
                                                                        .pop();
                                                                  },
                                                                  child: Center(
                                                                    child: Text(
                                                                        'Cancel',
                                                                        style: Theme.of(context)
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
                                                                child:
                                                                    CustomButton(
                                                                  onTap: () {
                                                                    context
                                                                        .pop();
                                                                    context
                                                                        .read<
                                                                            BagBloc>()
                                                                        .add(ConfirmOrderFilledEvent(order
                                                                            .id!
                                                                            .toString()));
                                                                  },
                                                                  text:
                                                                      'Confirm',
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
                                text: "Confirm",
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  },
                  if (order.isFulfilled != 1) ...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Confirmation pin',
                            style: Theme.of(context).textTheme.bodyLarge),
                        Text(
                          order.pin ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF98A2B3)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  },
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Address',
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        order.deliveryAddress ?? "",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF98A2B3)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Date',
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        DateTime.parse(order.createdAt!).dateOnly(),
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF98A2B3)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Status',
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        order.status!.toUpperCase(),
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: order.status == "delivered" ||
                                          order.status == "fulfilled"
                                      ? const Color(0xFF98A2B3)
                                      : Colors.red,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Sub-total',
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        '₦${(num.parse(order.total!) - num.parse(order.deliveryFee!)).toString().formatAmount()}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF98A2B3)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Delivery Fee',
                          style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        '₦${order.deliveryFee.toString().formatAmount() ?? ""}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF98A2B3)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 16,
                                  )),
                      Text(
                        '₦${order.total.toString().formatAmount()}',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF98A2B3)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Text('Report Order',
                        style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
