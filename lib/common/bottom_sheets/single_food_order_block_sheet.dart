// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:food_bank/common/widgets.dart';
// import 'package:food_bank/config/extensions/custom_extensions.dart';
// import 'package:food_bank/screens/user_account_screens/home/my_bag_page/models/cart.dart';
// import 'package:go_router/go_router.dart';

// import '../../screens/user_account_screens/checkout/presentation/bloc/checkout_bloc.dart';
// import '../../screens/user_account_screens/empty_wallet_message_screen.dart';
// import '../../screens/user_account_screens/hold_on_tight_screen.dart';
// import '../../screens/user_account_screens/home/my_bag_page/cache/cart_cache.dart';
// import '../../screens/user_account_screens/home/my_bag_page/models/bag_model.dart';
// import '../../screens/user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';
// import '../../screens/user_account_screens/home/user_page/cache/address_cache.dart';
// import '../../screens/user_account_screens/my_bag_screen.dart';

// class SingleFoodOrderBottomSheet extends StatefulWidget {
//   const SingleFoodOrderBottomSheet({
//     super.key,
//     required this.cart,
//   });
//   final CartItems cart;

//   @override
//   State<SingleFoodOrderBottomSheet> createState() =>
//       _SingleFoodOrderBottomSheetState();
// }

// class _SingleFoodOrderBottomSheetState
//     extends State<SingleFoodOrderBottomSheet> {
//   final CartCache cartCache = CartCache.instance;
//   final AddressCache addressCache = AddressCache.instance;
//   TextEditingController deliveryAddressController = TextEditingController();
//   Product? cart;
//   int qty = 1;

//   @override
//   void initState() {
//     setState(
//       () {
//         cart = widget.cart.product;
//         qty = widget.cart.quantity!;
//       },
//     );
//     deliveryAddressController.text = addressCache.addresses[0].address ?? '';
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         const FoodBankBottomSheetAppBar(
//           title: '',
//         ),
//         Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 height: 28,
//                 width: 100,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: const Color(0xFFFFECE5),
//                 ),
//                 child: Center(
//                     child: Text('Checkout',
//                         style: Theme.of(context).textTheme.bodyMedium)),
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.only(top: 10, left: 10, right: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'My Bag Summary',
//                       style: Theme.of(context)
//                           .textTheme
//                           .headlineMedium
//                           ?.copyWith(fontSize: 20),
//                     ),
//                     const SizedBox(height: 10),
//                     BlocConsumer<BagBloc, BagState>(
//                       listener: (context, state) {
//                         if (state is GettingCartSuccessful) {
//                           cartCache.carts = state.carts;
//                           setState(
//                             () {
//                               cart = cartCache
//                                   .getCart(cart!.id!.toString())
//                                   .product;
//                               qty = widget.cart.quantity!;
//                             },
//                           );
//                         } else if (state is AddingToCartSuccessful) {
//                           context.read<BagBloc>().add(
//                                 GetCartsEvent(),
//                               );
//                         } else if (state is IncrementingQTYSuccessful) {
//                           context.read<BagBloc>().add(
//                                 GetCartsEvent(),
//                               );
//                         } else if (state is DecrementingQTYSuccessful) {
//                           context.read<BagBloc>().add(
//                                 GetCartsEvent(),
//                               );
//                         } else if (state is RemovingToCartSuccessful) {
//                           context.read<BagBloc>().add(
//                                 GetCartsEvent(),
//                               );
//                         }
//                       },
//                       builder: (context, state) {
//                         return Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Row(
//                               children: [
//                                 Image.asset(
//                                   'assets/images/jollof.png',
//                                   scale: 2.4,
//                                 ),
//                                 const SizedBox(width: 20),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(cart!.name!,
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyLarge),
//                                     const SizedBox(height: 5),
//                                     Text(
//                                       cart!.description!,
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .headlineSmall
//                                           ?.copyWith(
//                                               fontSize: 10,
//                                               fontWeight: FontWeight.w400,
//                                               color: const Color(0xFF98A2B3)),
//                                     ),
//                                     const SizedBox(height: 5),
//                                     Text('₦6${cart!.price!}',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyMedium
//                                             ?.copyWith(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w400)),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                             Row(
//                               children: [
//                                 InkWell(
//                                   onTap: () {
//                                     setState(
//                                       () {
//                                         qty = qty < 2 ? qty : qty--;
//                                       },
//                                     );
//                                     context.read<BagBloc>().add(
//                                           AddingCartEvent(
//                                             cart!.id!,
//                                             qty,
//                                           ),
//                                         );
//                                   },
//                                   child: SvgPicture.asset(
//                                     'assets/icons/minus.svg',
//                                   ),
//                                 ),
//                                 Text(
//                                   '   $qty   ',
//                                   style:
//                                       Theme.of(context).textTheme.headlineSmall,
//                                 ),
//                                 InkWell(
//                                   onTap: () {
//                                     setState(
//                                       () {
//                                         qty++;
//                                       },
//                                     );
//                                     context.read<BagBloc>().add(
//                                           AddingCartEvent(
//                                             cart!.id!,
//                                             qty,
//                                           ),
//                                         );
//                                   },
//                                   child: SvgPicture.asset(
//                                     'assets/icons/plus.svg',
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         );
//                       },
//                     ),
//                     const SizedBox(height: 5),
//                     const Divider(
//                       thickness: 0.5,
//                     ),
//                     const SizedBox(height: 30),
//                     DeliveryAddressContent(
//                       address: deliveryAddressController.text,
//                       horizontalPadding: 0,
//                       onAddAddress: (String address, lng, lat) {
//                         setState(() {
//                           deliveryAddressController.text = address;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 30),
//               BlocConsumer<CheckoutBloc, CheckoutState>(
//                 listener: (context, state) {
//                   if (state is CheckingOutSuccessful) {
//                     context.pop(context);
//                     context.read<BagBloc>().add(RemoveCartEvent(cart!.id!));
//                     context.go(
//                       HoldOnTightScreen.route,
//                       extra: state.res.order!.id.toString(),
//                     );
//                   } else if (state is CheckingOutFail) {
//                     if (state.error.toLowerCase() == "insufficient balance") {
//                       context.push(EmptyWalletMessageScreen.route);
//                     } else {
//                       context.buildError(state.error);
//                     }
//                   }
//                 },
//                 builder: (context, state) => CustomButton(
//                   isLoading: state is CheckingOut,
//                   onTap: () {
//                     final (_, fee, _) = cartCache.fees();
//                     num subtotal =
//                         num.parse(cart!.price!) * widget.cart.quantity!;
//                     num total = subtotal + fee;
//                     context.read<CheckoutBloc>().add(
//                           CheckingOutEvent(
//                             address: addressCache.addresses.first.address!,
//                             deliveryFee: fee,
//                             products: [cart!.toJson()],
//                             type: "delivery",
//                             subTotal: subtotal,
//                             total: total,
//                             vendorId: cartCache
//                                 .carts.cartItems!.first.product!.vendorId
//                                 .toString(),
//                           ),
//                         );
//                   },
//                   text: 'Checkout',
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
