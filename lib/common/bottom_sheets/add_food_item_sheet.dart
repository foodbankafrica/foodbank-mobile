import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/donor_account_screens/donor_my_bag_screen.dart';
import 'package:food_bank/screens/user_account_screens/auth/cache/user_cache.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/utils/debouncer.dart';
import '../../screens/user_account_screens/home/home_page/models/product_model.dart';
import '../../screens/user_account_screens/home/my_bag_page/cache/cart_cache.dart';
import '../../screens/user_account_screens/home/my_bag_page/models/bag_model.dart';
import '../../screens/user_account_screens/home/my_bag_page/models/cart.dart'
    show CartItems;
import '../../screens/user_account_screens/my_bag_screen.dart';

class AddFoodItemBottomSheet extends StatefulWidget {
  const AddFoodItemBottomSheet({
    super.key,
    this.product,
    this.businessName,
    this.businessAddress,
    required this.isDonor,
  });
  final String? businessName, businessAddress;
  final Product? product;
  final bool isDonor;

  @override
  State<AddFoodItemBottomSheet> createState() => _AddFoodItemBottomSheetState();
}

class _AddFoodItemBottomSheetState extends State<AddFoodItemBottomSheet> {
  final CartCache cartCache = CartCache.instance;
  final UserCache userCache = UserCache.instance;
  late Debouncer _debouncer;
  int qty = 1;
  int oldQTY = 1;
  Bag? bag;

  @override
  void initState() {
    setState(() {
      bag = cartCache.getCart(widget.product!.id.toString());
      qty = bag!.quantity!;
    });
    _debouncer = Debouncer(
      const Duration(milliseconds: 500),
    );
    super.initState();
  }

  @override
  void dispose() {
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BagBloc, BagState>(
      listener: (context, state) {
        print("From add bag $state");
        if (state is GettingCartSuccessful) {
          cartCache.carts = state.carts;
        } else if (state is AddingToCartSuccessful) {
          context.read<BagBloc>().add(
                GetCartsEvent(),
              );
        } else if (state is RemovingToCartSuccessful) {
          context.read<BagBloc>().add(
                GetCartsEvent(),
              );

          Future.delayed(
            const Duration(milliseconds: 1000),
            () {
              // context.pop();
            },
          );
          setState(
            () {
              qty = 1;
            },
          );
        } else if (state is AddingToCartFail) {
          context.pop();
          context.buildError(state.error);
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
        return SizedBox(
          height: MediaQuery.of(context).size.height * .7,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    FoodBankBottomSheetAppBar(
                      title: widget.businessName,
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Container(
                            height: 182,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFECE5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: CustomCacheImage(
                                image: widget.product!.productImages!.isNotEmpty
                                    ? widget.product!.productImages!.first.path
                                    : "",
                                // scale: 2.4,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(widget.product!.name ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                      const SizedBox(height: 10),
                                      Text(
                                        widget.product!.description ?? '',
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₦${widget.product!.price.toString().formatAmount()}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(
                                            () {
                                              qty = qty == 1 ? qty : --qty;
                                            },
                                          );
                                          if (cartCache.alreadyAddToCart(
                                              widget.product!.id.toString())) {
                                            _debouncer.call(() {
                                              context.read<BagBloc>().add(
                                                    DecreaseQTYEvent(
                                                      cartCache.indexOf(widget
                                                          .product!.id!
                                                          .toString()),
                                                      Bag(
                                                        address:
                                                            "widget.product!.address",
                                                        images: widget
                                                            .product!.images,
                                                        price: widget
                                                            .product!.price,
                                                        id: widget.product!.id,
                                                        name: widget
                                                            .product!.name,
                                                        vendorId: widget
                                                            .product!.userId
                                                            .toString(),
                                                        quantity: qty,
                                                      ),
                                                    ),
                                                  );
                                            });
                                            return;
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          'assets/icons/minus.svg',
                                        ),
                                      ),
                                      Text(
                                        '   $qty   ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(
                                            () {
                                              qty++;
                                            },
                                          );
                                          if (cartCache.alreadyAddToCart(
                                              widget.product!.id.toString())) {
                                            _debouncer.call(() {
                                              context.read<BagBloc>().add(
                                                    IncreaseQTYEvent(
                                                      cartCache.indexOf(widget
                                                          .product!.id!
                                                          .toString()),
                                                      Bag(
                                                        address:
                                                            "widget.product!.address",
                                                        images: widget
                                                            .product!.images,
                                                        price: widget
                                                            .product!.price,
                                                        id: widget.product!.id,
                                                        name: widget
                                                            .product!.name,
                                                        vendorId: widget
                                                            .product!.userId
                                                            .toString(),
                                                        quantity: qty,
                                                      ),
                                                    ),
                                                  );
                                            });
                                            return;
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          'assets/icons/plus.svg',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      thickness: 0.5,
                    ),
                    // if (1 > 7)
                    //   Padding(
                    //     padding: const EdgeInsets.all(20.0),
                    //     child: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text(
                    //           'Add Ons',
                    //           style: Theme.of(context)
                    //               .textTheme
                    //               .displayLarge
                    //               ?.copyWith(fontSize: 20),
                    //         ),
                    //         const SizedBox(height: 10),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text('More Rice',
                    //                     style: Theme.of(context)
                    //                         .textTheme
                    //                         .bodyLarge),
                    //                 const SizedBox(height: 10),
                    //                 Text(
                    //                   'More portion added to the jollof rice',
                    //                   style: Theme.of(context)
                    //                       .textTheme
                    //                       .headlineSmall
                    //                       ?.copyWith(
                    //                           fontSize: 10,
                    //                           fontWeight: FontWeight.w400,
                    //                           color: const Color(0xFF98A2B3)),
                    //                 ),
                    //               ],
                    //             ),
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.end,
                    //               children: [
                    //                 Checkbox(
                    //                     value: false, onChanged: (value) {}),
                    //                 Text(
                    //                   '₦60.99',
                    //                   style: Theme.of(context)
                    //                       .textTheme
                    //                       .bodyMedium
                    //                       ?.copyWith(
                    //                         fontSize: 12,
                    //                         fontWeight: FontWeight.w400,
                    //                       ),
                    //                 ),
                    //                 const SizedBox(height: 10),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //         const SizedBox(height: 20),
                    //         Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.start,
                    //               children: [
                    //                 Text('Plantain',
                    //                     style: Theme.of(context)
                    //                         .textTheme
                    //                         .bodyLarge),
                    //                 const SizedBox(height: 10),
                    //                 Text(
                    //                   'One spoon of plantain',
                    //                   style: Theme.of(context)
                    //                       .textTheme
                    //                       .headlineSmall
                    //                       ?.copyWith(
                    //                           fontSize: 10,
                    //                           fontWeight: FontWeight.w400,
                    //                           color: const Color(0xFF98A2B3)),
                    //                 ),
                    //               ],
                    //             ),
                    //             Column(
                    //               crossAxisAlignment: CrossAxisAlignment.end,
                    //               children: [
                    //                 Checkbox(
                    //                     value: true, onChanged: (value) {}),
                    //                 Text(
                    //                   '₦20.99',
                    //                   style: Theme.of(context)
                    //                       .textTheme
                    //                       .bodyMedium
                    //                       ?.copyWith(
                    //                         fontSize: 12,
                    //                         fontWeight: FontWeight.w400,
                    //                       ),
                    //                 ),
                    //                 const SizedBox(height: 10),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomButton(
                      isLoading: state is AddingToCart ||
                          state is RemovingToCart ||
                          state is GettingCart,
                      color: cartCache
                              .alreadyAddToCart(widget.product!.id.toString())
                          ? Colors.green
                          : null,
                      onTap: () {
                        if (cartCache
                            .alreadyAddToCart(widget.product!.id.toString())) {
                          context.read<BagBloc>().add(
                                RemoveCartEvent(
                                  cartCache
                                      .indexOf(widget.product!.id!.toString())!,
                                ),
                              );
                        } else {
                          if (cartCache.isCartsEmpty ||
                              widget.product!.userId!.toString().toString() ==
                                  cartCache.carts.first.vendorId.toString()) {
                            final carts = cartCache.carts;
                            carts.add(Bag(
                              address: "",
                              images: widget.product!.productImages!.first.path,
                              price: widget.product!.price,
                              id: widget.product!.id,
                              name: widget.product!.name,
                              vendorId: widget.product!.userId!.toString(),
                              quantity: qty,
                            ));
                            context.read<BagBloc>().add(
                                  AddingCartEvent(carts),
                                );
                          } else {
                            context.buildError(
                              "You already have bagged products from another vendor.",
                            );
                            return;
                          }
                        }
                      },
                      text: cartCache
                              .alreadyAddToCart(widget.product!.id.toString())
                          ? 'Remove from bag'
                          : 'Add to bag',
                    ),
                    const SizedBox(height: 10),
                    if (cartCache
                        .alreadyAddToCart(widget.product!.id.toString()))
                      CustomButton(
                        onTap: () {
                          context.push(
                            widget.isDonor
                                ? DonorMyBagScreen.route
                                : MyBagScreen.route,
                          );
                        },
                        text: 'Proceed To Buy',
                      ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
