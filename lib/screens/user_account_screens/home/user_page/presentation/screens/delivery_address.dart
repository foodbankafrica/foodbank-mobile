// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/bottom_sheets/enter_delivery_address_sheet.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/bloc/address_bloc/address_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/cache/cache_key.dart';
import '../../../../../../core/cache/cache_store.dart';
import '../../../../auth/presentation/screens/signin_screen.dart';
import '../../cache/address_cache.dart';
import '../../models/address_model.dart';

class DeliveryAddressPage extends StatefulWidget {
  static String name = 'delivery-address';
  static String route = '/delivery-address';
  const DeliveryAddressPage({super.key});

  @override
  State<DeliveryAddressPage> createState() => _DeliveryAddressPageState();
}

class _DeliveryAddressPageState extends State<DeliveryAddressPage> {
  final TextEditingController addressController = TextEditingController();
  final AddressCache addressCache = AddressCache.instance;
  List<Address> addresses = [];
  @override
  initState() {
    if (addressCache.isEmpty()) {
      context.read<AddressBloc>().add(GetAddressEvent());
    } else {
      setState(() {
        addresses = addressCache.addresses;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Delivery Address ',
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          print(state);
          if (state is GettingAddressesSuccessful) {
            addressCache.addresses = state.addressesResponse.addresses!;
            setState(() {
              addresses = addressCache.addresses;
            });
          } else if (state is DeletingAddressSuccessful) {
            context.toast(content: "Address deleted successful.");
            context.read<AddressBloc>().add(GetAddressEvent());
          } else if (state is DeletingAddressFail) {
            if (state.error.toLowerCase() == "unauthenticated") {
              context.buildError(state.error);
              CacheStore().remove(key: CacheKey.token);
              Future.delayed(const Duration(seconds: 2), () {
                context.go(SignInScreen.route);
              });
            } else {
              context.buildError(state.error);
            }
          } else if (state is AddingAddressSuccessful) {
            context.read<AddressBloc>().add(GetAddressEvent());
          } else if (state is MarkingDefaultAddressFail) {
            if (state.error.toLowerCase() == "unauthenticated") {
              context.buildError(state.error);
              CacheStore().remove(key: CacheKey.token);
              Future.delayed(const Duration(seconds: 2), () {
                context.go(SignInScreen.route);
              });
            } else {
              context.buildError(state.error);
            }
          } else if (state is MarkingDefaultAddressSuccessful) {
            context.read<AddressBloc>().add(GetAddressEvent());
          }
        },
        builder: (context, state) {
          if (state is GettingAddresses) {
            return const Center(
              child: CustomIndicator(
                color: Color(0xFFF56630),
              ),
            );
          }
          if (state is GettingAddressesFail) {
            return RetryWidget(
              error: state.error,
              onTap: () {
                context.read<AddressBloc>().add(GetAddressEvent());
              },
            );
          }
          if (addresses.isEmpty) {
            return NotFound(
              message: "Delivery address Empty",
              buttonText: "Add New",
              onTap: _addNewAddress,
              showButton: true,
            );
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 5, 16, 20),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const Divider(
                          thickness: 0.8,
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: addresses.length,
                            itemBuilder: (context, i) {
                              final address = addresses[i];
                              print(address.longitude);
                              return AddressTemplate(
                                address: address.address!,
                                isDefault: address.isDefault == '1' ||
                                    address.isDefault == 1,
                                onDelete: () {
                                  context.read<AddressBloc>().add(
                                        DeleteAddressEvent(
                                          addressId: address.id.toString(),
                                        ),
                                      );
                                },
                                onMarkAsDefault: () {
                                  context.read<AddressBloc>().add(
                                        MarkAddressDefaultEvent(
                                          addressId: address.id.toString(),
                                        ),
                                      );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    isLoading: state is DeletingAddress ||
                        state is MarkingDefaultAddress,
                    onTap: _addNewAddress,
                    child: const Text('Add New'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  _addNewAddress() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      useSafeArea: true,
      builder: (context) {
        return BlocConsumer<AddressBloc, AddressState>(
          listener: (context, state) {
            print(state);
            if (state is AddingAddressFail) {
              if (state.error.toLowerCase() == "unauthenticated") {
                context.buildError(state.error);
                CacheStore().remove(key: CacheKey.token);
                Future.delayed(const Duration(seconds: 2), () {
                  context.go(SignInScreen.route);
                });
              } else {
                context.buildError(state.error);
              }
            } else if (state is AddingAddressSuccessful) {
              context.pop();
              context.toast(content: "Address added successfully!");
              context.read<AddressBloc>().add(GetAddressEvent());
            }
          },
          builder: (context, state) {
            return EnterDeliveryAddressBottomSheet(
              controller: addressController,
              isLoading: state is AddingAddress,
              onAdd: (lat, lng) {
                context.read<AddressBloc>().add(
                      AddAddressEvent(
                        address: addressController.text,
                        latitude: lat,
                        longitude: lng,
                      ),
                    );
              },
            );
          },
        );
      },
    );
  }
}

class AddressTemplate extends StatelessWidget {
  const AddressTemplate({
    super.key,
    required this.address,
    required this.isDefault,
    required this.onDelete,
    required this.onMarkAsDefault,
  });
  final String address;
  final bool isDefault;
  final Function() onDelete;
  final Function() onMarkAsDefault;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 0),
      child: Column(
        children: [
          const Divider(thickness: 0.8),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        address,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      InkWell(
                        onTap: isDefault ? null : onMarkAsDefault,
                        child: Column(
                          children: [
                            const SizedBox(height: 5),
                            isDefault
                                ? Text(
                                    'Default',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color: Colors.green,
                                        ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(1.2),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(3),
                                      color: const Color(0xFFF56630),
                                    ),
                                    child: Text(
                                      'Mark as default ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: onDelete,
                  child: Container(
                    height: 30,
                    width: 30,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0xFFFFECE5)),
                    child: SvgPicture.asset(
                      'assets/icons/delete.svg',
                      color: const Color(0xFFF56630),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(thickness: 0.8),
        ],
      ),
    );
  }
}

// ElevatedButton(onPressed: (){
//             showModalBottomSheet(
//                               context: context,
//                               isScrollControlled: true,
//                               isDismissible: false,
//                               useSafeArea: true,
//                               builder: (context) {
//                                 return const UpdateAvatarBottomSheet();
//                               });
//           }, child: const Text('Add New'),),