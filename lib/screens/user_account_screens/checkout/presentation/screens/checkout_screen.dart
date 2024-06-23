// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/bottom_sheets/add_food_item_sheet.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/models/product_model.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/bloc/business_bloc.dart';
import 'package:food_bank/screens/user_account_screens/my_bag_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/cache/user_cache.dart';
import '../../../home/home_page/models/buisness_model.dart';
import '../../../home/my_bag_page/cache/cart_cache.dart';
import '../../../home/my_bag_page/presentation/bloc/bag_bloc.dart';

class CheckoutScreen extends StatefulWidget {
  static String name = 'checkout';
  static String route = '/checkout';
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with SingleTickerProviderStateMixin {
  Businesses? business;
  bool loading = true;
  List bags = [];
  String currentCategory = "all";

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        if (userCache.isAuthenticated) {
          context.read<BusinessBloc>().add(
                GetProductsEvent(
                  vendorId: business!.business!.userId!.toString(),
                  branchId: business!.branch!.id!.toString(),
                  category: currentCategory,
                ),
              );
        } else {
          context.read<BusinessBloc>().add(
                GetGuestProductsEvent(
                  vendorId: business!.business!.userId!.toString(),
                ),
              );
        }
        Future.delayed(
          const Duration(milliseconds: 600),
          () {
            setState(
              () {
                loading = false;
              },
            );
          },
        );
      },
    );

    super.initState();
  }

  final CartCache cartCache = CartCache.instance;
  final UserCache userCache = UserCache.instance;

  Future<void> _refresh() async {
    if (userCache.isAuthenticated) {
      context.read<BusinessBloc>().add(
            GetProductsEvent(
              vendorId: business!.business!.userId!.toString(),
              branchId: business!.branch!.id!.toString(),
              category: currentCategory,
            ),
          );
    } else {
      context.read<BusinessBloc>().add(
            GetGuestProductsEvent(
              vendorId: business!.business!.userId!.toString(),
            ),
          );
    }
    context.read<BagBloc>().add(GetCartsEvent());
  }

  @override
  Widget build(BuildContext context) {
    business = GoRouterState.of(context).extra as Businesses;
    return Scaffold(
      appBar: FoodBankAppBar(
        title: business!.business!.businessName,
        end: Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.amber,
            borderRadius: BorderRadius.circular(100),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CustomCacheImage(
              image: business!.business!.logo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
      body: loading
          ? const Center(
              child: CustomIndicator(
                color: Color(0xFFEB5017),
              ),
            )
          : RefreshIndicator(
              onRefresh: _refresh,
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/clock-icon.svg',
                              ),
                              Expanded(
                                child: Text(
                                  '  Avg preparation time 10-15 mins   ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF7E8392),
                                      ),
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/icons/money-icon.svg',
                              ),
                              Expanded(
                                child: Text(
                                  '  Food starts at ₦${(business!.lowestAmount ?? '0').formatAmount()}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF7E8392),
                                      ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            width: 0.6,
                            color: Color.fromARGB(255, 127, 128, 134),
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        left: 25.0,
                        bottom: 10,
                        top: 10,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                context.read<BusinessBloc>().add(
                                      GetProductsEvent(
                                        vendorId: business!.business!.userId!
                                            .toString(),
                                        category: "all",
                                        branchId:
                                            business!.branch!.id!.toString(),
                                      ),
                                    );
                                setState(() {
                                  currentCategory = "all";
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 15),
                                child: Text(
                                  "All",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: currentCategory.toLowerCase() ==
                                                "all".toLowerCase()
                                            ? const Color(0xFFEB5017)
                                            : const Color(0xFF000000),
                                      ),
                                ),
                              ),
                            ),
                            ...business!.productCategories!.map(
                              (e) => InkWell(
                                onTap: () {
                                  context.read<BusinessBloc>().add(
                                        GetProductsEvent(
                                          vendorId: business!.business!.userId!
                                              .toString(),
                                          category: e.id.toString(),
                                          branchId:
                                              business!.branch!.id!.toString(),
                                        ),
                                      );
                                  setState(
                                    () {
                                      currentCategory = e.name!;
                                    },
                                  );
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 15),
                                  child: Text(
                                    e.name!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              currentCategory.toLowerCase() ==
                                                      e.name!.toLowerCase()
                                                  ? const Color(0xFFEB5017)
                                                  : const Color(0xFF000000),
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    BlocConsumer<BusinessBloc, BusinessState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is GettingProductsSuccessful) {
                          return Expanded(
                            child: SizedBox(
                              height: 500,
                              width: double.maxFinite,
                              child: TopSellerTab(
                                products: state.productResponse.products!.data!,
                                businessName: business!.business!.businessName,
                                businessAddress:
                                    (business!.business!.address ?? ''),
                              ),
                            ),
                          );
                        }
                        if (state is GettingProducts) {
                          return const Expanded(
                            child: Center(
                              child: Column(
                                children: [
                                  CustomIndicator(
                                    color: Color(0xFFEB5017),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return const Expanded(
                          child: SizedBox.shrink(),
                        );
                      },
                    ),
                    if (!cartCache.isCartsEmpty) ...{
                      if (userCache.isAuthenticated)
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
                                      borderRadius: BorderRadius.circular(45),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  onTap: () {},
                                  text: "Proceed To Buy",
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: OpenElevatedButton(
                                  onPressed: () {},
                                  child: const Text("Proceed To Donate"),
                                ),
                              ),
                            ],
                          ),
                        )
                    }
                  ],
                ),
              ),
            ),
    );
  }
}

class TopSellerTab extends StatefulWidget {
  const TopSellerTab({
    super.key,
    required this.products,
    this.isDonor = false,
    this.businessName,
    this.businessAddress,
  });
  final String? businessName, businessAddress;
  final List<Product> products;
  final bool isDonor;

  @override
  State<TopSellerTab> createState() => _TopSellerTabState();
}

class _TopSellerTabState extends State<TopSellerTab> {
  final CartCache cartCache = CartCache.instance;

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return const NotFound();
    }
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.products.length,
      itemBuilder: (context, index) {
        final product = widget.products[index];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CustomCacheImage(
                          image: product.productImages!.isNotEmpty
                              ? product.productImages!.first.path
                              : "",
                          width: 70,
                          height: 70,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name ?? '',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(
                                    0xFF98A2B3,
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        '₦${product.price.toString().formatAmount()}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            isDismissible: false,
                            useSafeArea: true,
                            builder: (context) {
                              return AddFoodItemBottomSheet(
                                product: product,
                                businessName: widget.businessName,
                                businessAddress: widget.businessName,
                                isDonor: widget.isDonor,
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 36,
                          // width: 60,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: cartCache
                                    .alreadyAddToCart(product.id.toString())
                                ? Colors.green
                                : const Color(0xFFEB5017),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              cartCache.alreadyAddToCart(product.id.toString())
                                  ? 'Remove'
                                  : 'Add',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider()
          ],
        );
      },
    );
  }
}
