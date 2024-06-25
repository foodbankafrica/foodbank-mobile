// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../../common/bottom_sheets/delivery_address_sheet.dart';
import '../../../core/cache/cache_key.dart';
import '../../../core/cache/cache_store.dart';
import '../../user_account_screens/auth/cache/user_cache.dart';
import '../../user_account_screens/auth/presentation/bloc/auth_bloc.dart';
import '../../user_account_screens/auth/presentation/screens/signin_screen.dart';
import '../../user_account_screens/home/home_page/presentation/bloc/business_bloc.dart';
import '../../user_account_screens/home/home_page/presentation/screens/search_screen.dart';
import '../../user_account_screens/home/home_page/presentation/screens/user_home_page.dart';
import '../../user_account_screens/home/my_bag_page/cache/cart_cache.dart';
import '../../user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';
import '../../user_account_screens/home/user_page/cache/address_cache.dart';
import '../../user_account_screens/home/user_page/presentation/bloc/address_bloc/address_bloc.dart';

class DonorHomePage extends StatefulWidget {
  static String name = 'donor-home-page';
  static String route = '/donor-home-page';
  const DonorHomePage({super.key});

  @override
  State<DonorHomePage> createState() => _DonorHomePageState();
}

class _DonorHomePageState extends State<DonorHomePage> {
  final UserCache userCache = UserCache.instance;
  String currentFilter = "All";
  final CartCache cartCache = CartCache.instance;
  final AddressCache addressCache = AddressCache.instance;

  @override
  void initState() {
    context.read<AuthBloc>().add(GetMeEvent());
    context.read<AddressBloc>().add(GetAddressEvent());
    context.read<BagBloc>().add(GetCartsEvent());
    super.initState();
  }

  Future<void> onRefresh() async {
    context.read<BusinessBloc>().add(GetBusinessesEvent(
          filteredBy: "",
          addressId: addressCache.defaultAddressId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocConsumer<AddressBloc, AddressState>(
                        listener: (context, state) {
                          if (state is GettingAddressesSuccessful) {
                            addressCache.addresses =
                                state.addressesResponse.addresses!;
                          } else if (state is GettingAddressesFail) {
                            if (state.error.toLowerCase() ==
                                "unauthenticated") {
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
                          return CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              userCache.user.avatar ??
                                  'https://firebasestorage.googleapis.com/v0/b/amam-appilication-store.appspot.com/o/avatar%2Favatar-1.png?alt=media&token=e39f17aa-d4e4-4d1d-9cb5-8adf712fab04',
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          BlocConsumer<BagBloc, BagState>(
                            listener: (context, state) {
                              if (state is GettingCartSuccessful) {
                                cartCache.carts = state.carts;
                              }
                            },
                            builder: (context, state) {
                              return GestureDetector(
                                onTap: () {
                                  context.push(
                                    SearchScreen.route,
                                    extra: true,
                                  );
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/search.svg',
                                  height: 24,
                                  width: 24,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          InkWell(
                            onTap: () {
                              if (userCache.isAuthenticated) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  useSafeArea: true,
                                  builder: (context) {
                                    return DeliveryAddressBottomSheet(
                                      onSelected: (address) {
                                        context.read<BusinessBloc>().add(
                                              GetBusinessesEvent(
                                                filteredBy: "",
                                                addressId:
                                                    address.id.toString(),
                                              ),
                                            );
                                        context.pop();
                                      },
                                    );
                                  },
                                );
                              }
                            },
                            child: Container(
                              height: 24,
                              width: 76,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xFFF56630)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/location-icon.svg',
                                    color: Colors.white,
                                  ),
                                  Text(
                                    ' Where',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  BlocConsumer<AuthBloc, AuthState>(
                    listener: (context, state) {
                      if (state is GettingMeSuccessful) {
                        userCache.updateCache(
                          user: state.user.user!,
                          wallet: state.user.wallet,
                          virtualAccounts: state.user.virtualAccounts,
                          kyc: state.user.kyc,
                        );
                      } else if (state is GettingMeFail) {
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
                      return Text(
                        'What are you donating \ntoday ?',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headlineMedium,
                      );
                    },
                  ),
                  // const SizedBox(height: 10),
                  // SingleChildScrollView(
                  //   scrollDirection: Axis.horizontal,
                  //   child: Row(
                  //     children: [
                  //       "All",
                  //       "Food",
                  //     ]
                  //         .map(
                  //           (el) => HomeOptionFilter(
                  //             isSelected: currentFilter == el,
                  //             onTap: () {
                  //               setState(() {
                  //                 currentFilter = el;
                  //               });

                  //               context
                  //                   .read<BusinessBloc>()
                  //                   .add(GetBusinessesEvent(
                  //                     filteredBy:
                  //                         el == "All" ? "" : el.toLowerCase(),
                  //                   ));
                  //             },
                  //             title: el,
                  //           ),
                  //         )
                  //         .toList(),
                  //   ),
                  // ),
                  const SizedBox(height: 10),
                  Text(
                    'These are the restaurants around you.',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: const Color(0xFF98A2B3)),
                  ),
                  const SizedBox(height: 10),
                  const BusinessesWidget(isFromDonor: true),
                  const SizedBox(height: 35),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeOptionFilter extends StatelessWidget {
  const HomeOptionFilter({
    super.key,
    this.title,
    this.isSelected,
    this.onTap,
  });
  final String? title;
  final bool? isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 80,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected == true
                ? const Color(0xFFF56630)
                : const Color(0xFFD0D5DD),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$title',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF475367),
                  ),
            ),
            isSelected == true
                ? const Row(
                    children: [
                      SizedBox(width: 5),
                      Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF475367),
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class FoodBankRestuarant extends StatelessWidget {
  const FoodBankRestuarant({
    super.key,
    this.restuarantName,
    this.onTap,
  });

  final String? restuarantName;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              height: 182,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: const DecorationImage(
                  image: AssetImage('assets/images/lagos_buka.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$restuarantName',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/clock-icon.svg'),
                        Text(
                          '  10-15 mins  ',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF7E8392),
                                  ),
                        ),
                        SvgPicture.asset('assets/icons/money-icon.svg'),
                        Text(
                          '  From ₦2,000',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF7E8392),
                                  ),
                        )
                      ],
                    )
                  ],
                ),
                Image.asset('assets/images/food-logo.png'),
              ],
            )
          ],
        ),
      ),
    );
  }
}
