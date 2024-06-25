// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/donor_account_screens/donor_my_bag_screen.dart';
import 'package:go_router/go_router.dart';

import '../user_account_screens/checkout/presentation/screens/checkout_screen.dart';
import '../user_account_screens/home/home_page/models/buisness_model.dart';
import '../user_account_screens/home/home_page/presentation/bloc/business_bloc.dart';
import '../user_account_screens/home/my_bag_page/cache/cart_cache.dart';
import '../user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';

class DonorCheckoutScreen extends StatefulWidget {
  static String name = 'donor-checkout';
  static String route = '/donor-checkout';
  const DonorCheckoutScreen({super.key});

  @override
  State<DonorCheckoutScreen> createState() => _DonorCheckoutScreenState();
}

class _DonorCheckoutScreenState extends State<DonorCheckoutScreen>
    with SingleTickerProviderStateMixin {
  Businesses? business;
  List bags = [];
  bool loading = true;
  List<String> tabString = ["All"];

  final CartCache cartCache = CartCache.instance;
  String currentCategory = "all";

  @override
  void initState() {
    Future.delayed(
      Duration.zero,
      () {
        for (var cat in business!.productCategories!) {
          tabString.add(cat.name!);
        }
        context.read<BusinessBloc>().add(
              GetProductsEvent(
                vendorId: business!.business!.userId!.toString(),
                branchId: business!.branch!.id!.toString(),
                category: currentCategory,
              ),
            );
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

  Future<void> _refresh() async {
    context.read<BusinessBloc>().add(
          GetProductsEvent(
            vendorId: business!.business!.userId!.toString(),
            branchId: business!.branch!.id!.toString(),
            category: currentCategory,
          ),
        );
    context.read<BagBloc>().add(GetCartsEvent());
  }

  @override
  Widget build(BuildContext context) {
    business = GoRouterState.of(context).extra as Businesses;
    return Scaffold(
      appBar: FoodBankAppBar(
        title: business!.business!.businessName,
        end: Image.asset(
          'assets/images/food-logo.png',
          scale: 1.8,
        ),
      ),
      body: loading
          ? const Center(
              child: CustomIndicator(
                color: Color(0xFFF56630),
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
                              SvgPicture.asset('assets/icons/clock-icon.svg'),
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
                              SvgPicture.asset('assets/icons/money-icon.svg'),
                              Expanded(
                                child: Text(
                                  '  Food starts at ₦2,000',
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
                                isDonor: true,
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
                    if (!cartCache.isCartsEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                              onPressed: () {
                                context.push(DonorMyBagScreen.route);
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
                                    '   ${cartCache.carts.length} Items in bag worth ₦${cartCache.fees().toString().formatAmount()}',
                                  )
                                ],
                              )),
                        ),
                      )
                  ],
                ),
              ),
            ),
    );
  }
}
