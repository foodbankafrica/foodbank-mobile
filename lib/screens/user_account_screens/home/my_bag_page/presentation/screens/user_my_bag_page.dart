import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/cache/cart_cache.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/models/bag_model.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../my_bag_screen.dart';
import '../../models/cart.dart';
import 'bag_history_page.dart';

class MyBagPage extends StatefulWidget {
  static String name = 'my-bag-page';
  static String route = '/my-bag-page';
  const MyBagPage({super.key});

  @override
  State<MyBagPage> createState() => _MyBagPageState();
}

class _MyBagPageState extends State<MyBagPage> {
  final CartCache cartCache = CartCache.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<BagBloc, BagState>(
        listener: (context, state) {
          // print(state);
          if (state is GettingCartSuccessful) {
            cartCache.carts = state.carts;
          } else if (state is RemovingToCartSuccessful) {
            context.read<BagBloc>().add(
                  GetCartsEvent(),
                );
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'My Bag',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontSize: 20),
                        ),
                        InkWell(
                          onTap: () {
                            context.push(BagHistoryPage.route);
                          },
                          child: Text(
                            'Order History',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: 15,
                                  color: const Color(0xFFEB5017),
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: MediaQuery.of(context).size.height - 170,
                      child: Column(
                        children: [
                          if (cartCache.isCartsEmpty)
                            const NotFound(
                              message: 'Your bag is empty',
                            )
                          else ...{
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: cartCache.carts.map(
                                    (cart) {
                                      return MyBagList(cart: cart);
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ElevatedButton(
                                    onPressed: () {
                                      context.push(MyBagScreen.route);
                                    },
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(45),
                                        ),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                            'assets/icons/inactive-shopping-icon.svg',
                                            color: Colors.white),
                                        Text(
                                          '   ${cartCache.carts.length} Items in bag worth ₦${cartCache.fees().$3.toString().formatAmount()}',
                                        )
                                      ],
                                    )),
                              ),
                            ),
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

class MyBagList extends StatefulWidget {
  const MyBagList({
    super.key,
    required this.cart,
  });
  final Bag cart;

  @override
  State<MyBagList> createState() => _MyBagListState();
}

class _MyBagListState extends State<MyBagList> {
  final CartCache cartCache = CartCache.instance;
  int qty = 1;

  @override
  void initState() {
    setState(
      () {
        qty = widget.cart.quantity!;
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 172,
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
                        borderRadius: BorderRadius.circular(10),
                        child: CustomCacheImage(
                          image: widget.cart.images ?? "",
                          height: 50,
                          width: 80,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.cart.name!,
                              style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 5),
                          Text(
                            widget.cart.description ?? '',
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
                              '₦${widget.cart.price.toString().formatAmount()}',
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
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     setState(
                      //       () {
                      //         qty = qty < 2 ? qty : qty - 1;
                      //       },
                      //     );
                      //     context.read<BagBloc>().add(
                      //           AddingCartEvent(
                      //             bag!.id!,
                      //             qty,
                      //           ),
                      //         );
                      //   },
                      //   child: Container(
                      //     height: 30,
                      //     width: 30,
                      //     decoration: const BoxDecoration(
                      //         shape: BoxShape.circle, color: Color(0xFFFFECE5)),
                      //     child: const Center(
                      //         child: Icon(Icons.remove,
                      //             size: 18, color: Color(0xFFEB5017))),
                      //   ),
                      // ),
                      Text(
                        ' x$qty ',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      // InkWell(
                      //   onTap: () {
                      //     setState(
                      //       () {
                      //         qty++;
                      //       },
                      //     );
                      //     context.read<BagBloc>().add(
                      //           AddingCartEvent(
                      //             bag!.id!,
                      //             qty,
                      //           ),
                      //         );
                      //   },
                      //   child: Container(
                      //     height: 30,
                      //     width: 30,
                      //     decoration: const BoxDecoration(
                      //         shape: BoxShape.circle, color: Color(0xFFFFECE5)),
                      //     child: const Center(
                      //         child: Icon(Icons.add,
                      //             size: 18, color: Color(0xFFEB5017))),
                      //   ),
                      // )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      width: 153,
                      child: OpenElevatedButton(
                        onPressed: () {
                          context.read<BagBloc>().add(
                                RemoveCartEvent(
                                  cartCache.indexOf(widget.cart.id!.toString()),
                                ),
                              );
                        },
                        child: Center(
                          child: Text('Remove item',
                              style: Theme.of(context).textTheme.bodyMedium),
                        ),
                      ),
                    ),
                  ),
                  // const SizedBox(width: 20),
                  // Expanded(
                  //   child: SizedBox(
                  //     height: 36,
                  //     width: 153,
                  //     child: CustomButton(
                  //       onTap: () {
                  //         showModalBottomSheet(
                  //           context: context,
                  //           isScrollControlled: true,
                  //           isDismissible: false,
                  //           useSafeArea: true,
                  //           builder: (context) {
                  //             return SingleFoodOrderBottomSheet(
                  //               cart: bag,
                  //             );
                  //           },
                  //         );
                  //       },
                  //       text: 'Pay',
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
