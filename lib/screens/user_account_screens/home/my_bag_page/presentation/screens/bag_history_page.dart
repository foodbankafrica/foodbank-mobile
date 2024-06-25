import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/cache/cart_cache.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/models/order_model.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/screens/view_order_summary_screen.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/screens/view_reoccurring_order_summary_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../../common/bottom_sheets/three_step_order_in_progress_sheet.dart';
import '../../../../../../core/cache/cache_key.dart';
import '../../../../../../core/cache/cache_store.dart';
import '../../../../auth/presentation/screens/signin_screen.dart';
import '../../cache/order_cache.dart';

class BagHistoryPage extends StatefulWidget {
  static String name = 'bag-history-page';
  static String route = '/bag-history-page';
  const BagHistoryPage({super.key});

  @override
  State<BagHistoryPage> createState() => _BagHistoryPageState();
}

class _BagHistoryPageState extends State<BagHistoryPage> {
  final OrderCache orderCache = OrderCache.instance;
  final CartCache cartCache = CartCache.instance;
  List<Order> baggedOrders = [];
  List<Order> reoccurringOrders = [];
  List<Order> completedOrders = [];
  bool isSelected1 = true;
  bool isSelected2 = false;
  bool isSelected3 = false;

  void changeState1() {
    setState(() {
      isSelected1 = true;
    });
    if (isSelected1 == true) {
      isSelected2 = false;
      isSelected3 = false;
    }
  }

  void changeState2() {
    setState(() {
      isSelected2 = true;
    });
    if (isSelected2 == true) {
      isSelected1 = false;
      isSelected3 = false;
    }
  }

  void changeState3() {
    setState(() {
      isSelected3 = true;
    });
    if (isSelected3 == true) {
      isSelected1 = false;
      isSelected2 = false;
    }
  }

  @override
  void initState() {
    if (orderCache.isOrdersEmpty) {
      context.read<BagBloc>().add(GetOrdersEvent(1));
    } else {
      _setOrder(orderCache.orders);
    }
    super.initState();
  }

  _setOrder(List<Order> ord) {
    setState(() {
      baggedOrders = orderCache.filteredOrder("pending");
      reoccurringOrders = orderCache.filteredOrder("reoccurring");
      completedOrders = orderCache.filteredOrder("delivered");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(title: "Order History"),
      body: BlocConsumer<BagBloc, BagState>(
        listener: (context, state) {
          if (state is GettingOrdersSuccessful) {
            orderCache.orders = state.orders.orders!.data!;
            _setOrder(state.orders.orders!.data!);
          } else if (state is GettingOrdersFail) {
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
        builder: (context, state) {
          return SingleChildScrollView(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(64),
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
                                    borderRadius: BorderRadius.circular(32),
                                    color: isSelected1 == true
                                        ? Colors.black
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Ongoing',
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
                                    borderRadius: BorderRadius.circular(32),
                                    color: isSelected2 == true
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
                                            color: isSelected2 == true
                                                ? Colors.white
                                                : Colors.black,
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
                                    borderRadius: BorderRadius.circular(32),
                                    color: isSelected3 == true
                                        ? Colors.black
                                        : null,
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Completed',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: isSelected3 == true
                                                ? Colors.white
                                                : Colors.black,
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
                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Column(
                        children: [
                          if (isSelected1 == true) ...{
                            const MyOnGoingBags(),
                          } else if (isSelected2 == true) ...{
                            const MyReoccurringOrders(),
                          } else if (isSelected3 == true) ...{
                            const CompletedOrders(),
                          },
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MyReoccurringOrders extends StatefulWidget {
  const MyReoccurringOrders({
    super.key,
  });

  @override
  State<MyReoccurringOrders> createState() => _MyReoccurringOrdersState();
}

class _MyReoccurringOrdersState extends State<MyReoccurringOrders> {
  final PagingController<int, Order> _pagingController =
      PagingController(firstPageKey: 1);
  final OrderCache orderCache = OrderCache.instance;

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        context.read<BagBloc>().add(GetOrdersEvent(pageKey));
      },
    );

    super.initState();
  }

  Future<void> refresh() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BagBloc, BagState>(
      listener: (context, state) {
        if (state is GettingOrdersSuccessful) {
          orderCache.orders = state.orders.orders!.data ?? [];
          final isLastPage = (state.orders.orders!.data ?? []).length <
              (state.orders.orders!.perPage ?? 8);
          if (isLastPage) {
            _pagingController.appendLastPage(state.orders.orders!.data!);
          } else {
            final nextPageKey = (state.orders.orders!.currentPage ?? 0) + 1;
            _pagingController.appendPage(
                state.orders.orders!.data!, nextPageKey);
          }
        } else if (state is GettingOrdersFail) {
          if (state.error.toLowerCase() == "unauthenticated") {
            context.buildError(state.error);
            context.logout();
          } else {
            context.buildError(state.error);
          }
        }
      },
      builder: (context, state) {
        return Expanded(
          child: RefreshIndicator(
            onRefresh: refresh,
            color: const Color(0xFFEB5017),
            child: PagedListView<int, Order>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Order>(
                firstPageProgressIndicatorBuilder: (_) => const CustomIndicator(
                  color: Color(0xFFEB5017),
                ),
                newPageProgressIndicatorBuilder: (_) => const CustomIndicator(
                  color: Color(0xFFEB5017),
                ),
                noItemsFoundIndicatorBuilder: (_) => const NotFound(
                  message: 'Your bag is empty',
                ),
                itemBuilder: (context, order, index) {
                  if (order.status!.toLowerCase() == "delivered" ||
                      order.type != "reoccurring") {
                    return const SizedBox.shrink();
                  }
                  return ReoccuringList(
                    order: order,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class CompletedOrders extends StatefulWidget {
  const CompletedOrders({
    super.key,
  });

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

class _CompletedOrdersState extends State<CompletedOrders> {
  final PagingController<int, Order> _pagingController =
      PagingController(firstPageKey: 1);
  final OrderCache orderCache = OrderCache.instance;

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        context.read<BagBloc>().add(GetOrdersEvent(pageKey));
      },
    );

    super.initState();
  }

  Future<void> refresh() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BagBloc, BagState>(listener: (context, state) {
      if (state is GettingOrdersSuccessful) {
        orderCache.orders = state.orders.orders!.data ?? [];
        final isLastPage = (state.orders.orders!.data ?? []).length <
            (state.orders.orders!.perPage ?? 8);
        if (isLastPage) {
          _pagingController.appendLastPage(state.orders.orders!.data!);
        } else {
          final nextPageKey = (state.orders.orders!.currentPage ?? 0) + 1;
          _pagingController.appendPage(state.orders.orders!.data!, nextPageKey);
        }
      }
    }, builder: (context, state) {
      if (state is GettingOrdersFail) {
        return RetryWidget(
          error: state.error,
          onTap: () {
            context.read<BagBloc>().add(GetOrdersEvent(1));
          },
        );
      }
      return Expanded(
        child: RefreshIndicator(
          onRefresh: refresh,
          color: const Color(0xFFEB5017),
          child: PagedListView<int, Order>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Order>(
              firstPageProgressIndicatorBuilder: (_) => const CustomIndicator(
                color: Color(0xFFEB5017),
              ),
              newPageProgressIndicatorBuilder: (_) => const CustomIndicator(
                color: Color(0xFFEB5017),
              ),
              noItemsFoundIndicatorBuilder: (_) => const NotFound(
                message: 'Your bag is empty',
              ),
              itemBuilder: (context, order, index) {
                if (order.isFulfilled != 1) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                order.orderCode!.writeTo(12),
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 15),
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
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '₦${order.total.toString().formatAmount()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF98A2B3)),
                              ),
                              const SizedBox(height: 15),
                              SizedBox(
                                height: 36,
                                width: 110,
                                child: OpenElevatedButton(
                                  onPressed: () {
                                    context.push(ViewOrderSummaryScreen.route,
                                        extra: order);
                                  },
                                  child: Center(
                                    child: Text('View Order',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(thickness: 0.5),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}

class MyOnGoingBags extends StatefulWidget {
  const MyOnGoingBags({
    super.key,
  });

  @override
  State<MyOnGoingBags> createState() => _MyOnGoingBagsState();
}

class _MyOnGoingBagsState extends State<MyOnGoingBags> {
  final PagingController<int, Order> _pagingController =
      PagingController(firstPageKey: 1);
  final OrderCache orderCache = OrderCache.instance;

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        context.read<BagBloc>().add(GetOrdersEvent(pageKey));
      },
    );

    super.initState();
  }

  Future<void> refresh() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BagBloc, BagState>(
      listener: (context, state) {
        if (state is GettingOrdersSuccessful) {
          orderCache.orders = state.orders.orders!.data ?? [];
          final isLastPage = (state.orders.orders!.data ?? []).length <
              (state.orders.orders!.perPage ?? 8);
          if (isLastPage) {
            _pagingController.appendLastPage(state.orders.orders!.data!);
          } else {
            final nextPageKey = (state.orders.orders!.currentPage ?? 0) + 1;
            _pagingController.appendPage(
                state.orders.orders!.data!, nextPageKey);
          }
        } else if (state is GettingOrdersFail) {
          if (state.error.toLowerCase() == "unauthenticated") {
            context.buildError(state.error);
            context.logout();
          } else {
            context.buildError(state.error);
          }
        }
      },
      builder: (context, state) {
        if (state is GettingOrdersFail) {
          return RetryWidget(
            error: state.error,
            onTap: () {
              context.read<BagBloc>().add(GetOrdersEvent(1));
            },
          );
        }
        return Expanded(
          child: RefreshIndicator(
            onRefresh: refresh,
            color: const Color(0xFFEB5017),
            child: PagedListView<int, Order>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Order>(
                firstPageProgressIndicatorBuilder: (_) => const CustomIndicator(
                  color: Color(0xFFEB5017),
                ),
                newPageProgressIndicatorBuilder: (_) => const CustomIndicator(
                  color: Color(0xFFEB5017),
                ),
                noItemsFoundIndicatorBuilder: (_) => const NotFound(
                  message: 'Your bag is empty',
                ),
                itemBuilder: (context, order, index) {
                  if (order.isFulfilled == 1 || order.type == "reoccurring") {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: order.orderProducts!
                        .map(
                          (prod) => MyBagList(
                            prod: prod,
                            onTap: () {
                              if (order.status == "undeliverable") {
                                context.push(ViewOrderSummaryScreen.route,
                                    extra: order);
                              } else {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  useSafeArea: true,
                                  builder: (context) {
                                    return ThreeStepOrderInProgressBottomSheet(
                                      orderId: order.id!.toString(),
                                      onClose: () {
                                        context.pop();
                                      },
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        )
                        .toList(),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class ReoccuringList extends StatelessWidget {
  const ReoccuringList({
    super.key,
    required this.order,
  });
  final Order order;

  @override
  Widget build(BuildContext context) {
    final num fromDay =
        DateTime.parse(order.subStartDate).compareTo(DateTime.now()) -
            num.parse(order.subTimeline);
    return Container(
      height: 248,
      width: 350,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFFFFFFF),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ordering Status',
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Day ${order.totalNoOfTimes} ',
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                  text: '•',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 16)),
                              TextSpan(
                                  text: ' Of ${order.subTimeline}',
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ]),
                      ),
                    ],
                  ),
                  Text(
                      '${fromDay.toString().startsWith("-") ? "100" : ((fromDay / num.parse(order.subTimeline)) * 100).toInt()}%',
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
              const SizedBox(height: 10),
              ...order.orderProducts!.map((prod) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CustomCacheImage(
                            image: (prod.products!.images ?? []).isNotEmpty
                                ? prod.products!.images!.first.path
                                : "",
                            width: 60,
                            height: 60,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prod.products!.name!,
                                style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: 5),
                            Text(
                              prod.products!.description!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF98A2B3)),
                            ),
                            const SizedBox(height: 5),
                            Text(
                                '₦${(num.parse(prod.products!.price!) * num.parse(prod.quantity!)).toString().formatAmount()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ],
                    ),
                    // Row(
                    //   children: [
                    //     Container(
                    //       height: 30,
                    //       width: 30,
                    //       decoration: const BoxDecoration(
                    //           shape: BoxShape.circle, color: Color(0xFFFFECE5)),
                    //       child: const Center(
                    //           child: Icon(Icons.remove,
                    //               size: 18, color: Color(0xFFEB5017))),
                    //     ),
                    //     Text(
                    //       '  1  ',
                    //       style: Theme.of(context).textTheme.headlineSmall,
                    //     ),
                    //     Container(
                    //       height: 30,
                    //       width: 30,
                    //       decoration: const BoxDecoration(
                    //           shape: BoxShape.circle, color: Color(0xFFFFECE5)),
                    //       child: const Center(
                    //           child: Icon(Icons.add,
                    //               size: 18, color: Color(0xFFEB5017))),
                    //     )
                    //   ],
                    // ),
                  ],
                );
              }),
              const SizedBox(height: 8),
              const Divider(thickness: 0.5),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: OpenElevatedButton(
                        onPressed: () {},
                        child: Text(
                          'Pause Order',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: const Color(0xFFEB5017),
                                  ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: CustomButton(
                        onTap: () {
                          context.push(
                            ViewReoccurringOrderSummaryScreen.route,
                            extra: order,
                          );
                        },
                        child: Text(
                          'View Order',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ),
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

class MyBagList extends StatelessWidget {
  const MyBagList({
    super.key,
    required this.prod,
    required this.onTap,
  });
  final OrderProducts prod;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFFFFFFF),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: CustomCacheImage(
                            image: prod.products!.images!.isNotEmpty
                                ? prod.products!.images!.first.path
                                : "",
                            width: 60,
                            height: 60,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(prod.products!.name!,
                                style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(height: 5),
                            Text(
                              prod.products!.description!,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF98A2B3)),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              '₦${prod.products!.price.toString().formatAmount()}',
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
                      'x${prod.quantity}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
