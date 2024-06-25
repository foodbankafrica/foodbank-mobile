import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/bottom_sheets/delivery_address_sheet.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/donor_account_screens/donor_checkout_screen.dart';
import 'package:food_bank/screens/user_account_screens/auth/cache/user_cache.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/screens/search_screen.dart';
import 'package:food_bank/screens/user_account_screens/onboarding_screen.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/cache/cache_key.dart';
import '../../../../../../core/cache/cache_store.dart';
import '../../../../../../core/injections.dart';
import '../../../../../../core/push_notification/device_info.dart';
import '../../../../../../core/push_notification/notification_helper.dart';
import '../../../../../../core/push_notification/push_notification_service.dart';
import '../../../../auth/app/auth_facade.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../../auth/presentation/screens/signin_screen.dart';
import '../../../../checkout/presentation/screens/checkout_screen.dart';
import '../../../my_bag_page/cache/cart_cache.dart';
import '../../../my_bag_page/presentation/bloc/bag_bloc.dart';
import '../../../user_page/cache/address_cache.dart';
import '../../../user_page/presentation/bloc/address_bloc/address_bloc.dart';
import '../../cache/business_cache.dart';
import '../../models/buisness_model.dart';
import '../bloc/business_bloc.dart';
import 'redeem_screen.dart';

class HomePage extends StatefulWidget {
  static String name = 'home-page';
  static String route = '/home-page';
  const HomePage({
    super.key,
    this.arg,
  });
  final dynamic arg;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NotificationHelper? _notificationHelper;

  String currentFilter = "All";
  String? pickedAddress;
  final UserCache userCache = UserCache.instance;
  final CartCache cartCache = CartCache.instance;
  final AddressCache addressCache = AddressCache.instance;

  @override
  void initState() {
    context.read<AuthBloc>().add(GetMeEvent());
    if (userCache.isAuthenticated) {
      context.read<AddressBloc>().add(GetAddressEvent());
      context.read<BagBloc>().add(GetCartsEvent());

      _initPushNotifications();

      _notificationHelper = NotificationHelper(
        flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
      );
    }
    super.initState();
  }

  Future<void> onRefresh() async {
    context.read<BusinessBloc>().add(
          GetBusinessesEvent(
            filteredBy: "",
            addressId: addressCache.defaultAddressId,
          ),
        );
  }

  Future<void> _initPushNotifications() async {
    final pushNotificationService = PushNotificationService(
      FirebaseMessaging.instance,
      onMessage: _onFCMMessage,
      onTokenChanged: _onTokenChanged,
    );

    await pushNotificationService.init();
  }

  void _onFCMMessage(RemoteMessage value) {
    "FCM message: ${value.notification}".log();

    final notification = value.notification;

    if (notification != null) {
      _notificationHelper?.showNotification(
        title: notification.title ?? '',
        body: notification.body ?? '',
      );
    }
  }

  void _onTokenChanged(String pushToken) async {
    "FCM token: $pushToken".log();

    final startUpApi = sl<AuthFacade>();

    DeviceInfo? deviceInfo;

    final deviceInfoPlugin = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceInfo = DeviceInfo.fromAndroidDeviceInfo(androidInfo, pushToken);
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceInfo = DeviceInfo.fromIosDeviceInfo(iosInfo, pushToken);
    } else {
      return;
    }

    final res = await startUpApi.setFcmToken(deviceInfo.pushToken);

    res.fold(
      (l) => "Error registering device: $l".log(),
      (r) => "Device registered successfully".log(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
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
                        builder: (context, state) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Delivery to',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: const Color(0xFFD0D5DD),
                                  ),
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
                                          setState(() {
                                            pickedAddress =
                                                address.address!.writeTo(30);
                                          });
                                          context.pop();
                                        },
                                      );
                                    },
                                  );
                                } else {
                                  context.go(OnboardingScreen.route);
                                }
                              },
                              child: Row(
                                children: [
                                  Text(
                                    state is GettingAddresses
                                        ? "Loading..."
                                        : addressCache.addresses.isEmpty
                                            ? "No address"
                                            : pickedAddress ??
                                                addressCache.defaultAddress,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                    color: Color(0xFFD0D5DD),
                                    size: 18,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      if (userCache.isAuthenticated)
                        BlocConsumer<BagBloc, BagState>(
                          listener: (context, state) {
                            if (state is GettingCartSuccessful) {
                              cartCache.carts = state.carts;
                            }
                          },
                          builder: (context, state) => Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    context.push(RedeemScreen.route);
                                  },
                                  child: SvgPicture.asset(
                                      'assets/icons/scan-icon.svg')),
                              const SizedBox(width: 30),
                              GestureDetector(
                                onTap: () {
                                  context.push(SearchScreen.route);
                                },
                                child: SvgPicture.asset(
                                  'assets/icons/search.svg',
                                  height: 24,
                                  width: 24,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        )
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
                        'What are you ordering\ntoday ?',
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.headlineMedium,
                      );
                    },
                  ),
                  // if (userCache.isAuthenticated) const SizedBox(height: 10),
                  // if (userCache.isAuthenticated)
                  //   SingleChildScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     child: Row(
                  //       children: ["All", "Food"]
                  //           .map(
                  //             (el) => HomeOptionFilter(
                  //               isSelected: currentFilter == el,
                  //               onTap: () {
                  //                 setState(() {
                  //                   currentFilter = el;
                  //                 });

                  //                 context
                  //                     .read<BusinessBloc>()
                  //                     .add(GetBusinessesEvent(
                  //                       filteredBy:
                  //                           el == "All" ? "" : el.toLowerCase(),
                  //                     ));
                  //               },
                  //               title: el,
                  //             ),
                  //           )
                  //           .toList(),
                  //     ),
                  //   ),
                  const SizedBox(height: 10),
                  Text(
                    'These are the businesses around you.',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(color: const Color(0xFF98A2B3)),
                  ),
                  const SizedBox(height: 10),
                  BusinessesWidget(arg: widget.arg),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FoodBankRestaurant extends StatelessWidget {
  const FoodBankRestaurant({
    super.key,
    this.restaurantName,
    this.logo,
    this.lowestAmount,
    this.onTap,
  });

  final String? restaurantName, logo, lowestAmount;
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
                color: Colors.black12,
                image: DecorationImage(
                  image: NetworkImage(
                    logo != null &&
                            (logo!.startsWith('https://') ||
                                logo!.startsWith('http://'))
                        ? logo!
                        : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRI3jBn0EKhYA1azZY-2H2abjhDObry5na8XjOAPSLY1y_s6GjLJ-lADihMRGIG_gxEtgM&usqp=CAU',
                    scale: 1.2,
                  ),
                  fit: BoxFit.contain,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .75,
                      child: Text(
                        '$restaurantName',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (lowestAmount != null)
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
                            '  From ₦${lowestAmount!.formatAmount()}',
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
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CustomCacheImage(
                      image: logo,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BusinessesWidget extends StatefulWidget {
  const BusinessesWidget({
    super.key,
    this.isFromDonor = false,
    this.arg,
  });
  final bool isFromDonor;
  final dynamic arg;

  @override
  State<BusinessesWidget> createState() => _BusinessesWidgetState();
}

class _BusinessesWidgetState extends State<BusinessesWidget> {
  List<Businesses> businesses = [];
  final UserCache userCache = UserCache.instance;
  final BusinessCache businessCache = BusinessCache.instance;
  final AddressCache addressCache = AddressCache.instance;

  @override
  void initState() {
    if (widget.arg != null || !userCache.isAuthenticated) {
      context.read<BusinessBloc>().add(
            GetGuestBusinessesEvent(
              address: widget.arg["address"],
              latitude: widget.arg["latitude"],
              longitude: widget.arg["longitude"],
            ),
          );
    } else {
      if (businessCache.isEmpty) {
        context.read<BusinessBloc>().add(GetBusinessesEvent(
              filteredBy: "",
              addressId: addressCache.defaultAddressId,
            ));
      } else {
        setState(() {
          businesses = businessCache.businesses;
        });
      }
    }
    super.initState();
  }

  @override
  build(BuildContext context) {
    print(widget.arg);
    return BlocConsumer<BusinessBloc, BusinessState>(
      listener: (context, state) {
        if (state is GettingBusinessesSuccessful) {
          businessCache.businesses = state.businessResponse.businesses!;
          setState(() {
            businesses = businessCache.businesses;
          });
        } else if (state is GettingBusinessesFail) {
          if (state.error.toLowerCase() == "unauthenticated") {
            context.buildError(state.error);
            context.logout();
          } else {
            context.buildError(state.error);
          }
        }
      },
      builder: (context, state) {
        if (state is GettingBusinesses) {
          return const Center(
            child: CustomIndicator(
              color: Color(0xFFF56630),
            ),
          );
        }
        if (state is GettingBusinessesFail) {
          return RetryWidget(
            error: state.error,
            onTap: () {
              context.read<BusinessBloc>().add(GetBusinessesEvent(
                    filteredBy: "",
                    addressId: addressCache.defaultAddressId,
                  ));
            },
          );
        }
        if (businesses.isEmpty) {
          return const NotFound(
            message: "No Business Found",
            showButton: false,
          );
        }
        return Column(
            children: businesses.map((business) {
          return FoodBankRestaurant(
            onTap: () {
              context.push(
                widget.isFromDonor
                    ? DonorCheckoutScreen.route
                    : CheckoutScreen.route,
                extra: business,
              );
            },
            restaurantName: business.business!.businessName,
            logo: business.business!.logo,
            lowestAmount: business.lowestAmount,
          );
        }).toList());
      },
    );
  }
}
