import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../models/order_model.dart';

class ViewReoccurringOrderSummaryScreen extends StatelessWidget {
  static String name = 'view-reoccurring-order-summary';
  static String route = '/view-reoccurring-order-summary';
  const ViewReoccurringOrderSummaryScreen({super.key});

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
                  ...[
                    {
                      "title": 'Order Type',
                      "subtitle": (order.type ?? '').toUpperCase(),
                    },
                    {
                      "title": 'No. of order remaining',
                      "subtitle": "${order.totalNoOfTimes ?? ""}",
                    },
                    {
                      "title": "No. of order per day",
                      "subtitle": "${order.subPreference ?? ""}",
                    },
                    {
                      "title": "Start Date",
                      "subtitle": DateTime.parse(order.subStartDate ??
                              DateTime.now().toIso8601String())
                          .dateOnly(),
                    },
                    {
                      "title": "End Date",
                      "subtitle": DateTime.parse(order.subEndDate ??
                              DateTime.now().toIso8601String())
                          .dateOnly(),
                    },
                    {
                      "title": "Sub-total",
                      "subtitle":
                          '₦${(num.parse(order.total!) - num.parse(order.deliveryFee!)).toString().formatAmount()}',
                    },
                    {
                      "title": "Delivery fee",
                      "subtitle":
                          '₦${order.deliveryFee.toString().formatAmount() ?? ""}',
                    },
                    {
                      "title": "Total",
                      "subtitle": '₦${order.total.toString().formatAmount()}',
                    },
                    {
                      "title": "Order At",
                      "subtitle": DateTime.parse(order.createdAt!).dateOnly()
                    }
                  ].map(
                    (e) {
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e["title"]!,
                                  style: Theme.of(context).textTheme.bodyLarge),
                              Text(
                                e["subtitle"]!,
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
                        ],
                      );
                    },
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
