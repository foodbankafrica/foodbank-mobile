// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/core/utils/helper_func.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/bloc/address_bloc/address_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

import 'package:geocoding/geocoding.dart';

class EnterDeliveryAddressBottomSheet extends StatefulWidget {
  const EnterDeliveryAddressBottomSheet({
    super.key,
    this.onAdd,
    this.controller,
    this.isLoading = false,
  });
  final Function(double, double)? onAdd;
  final TextEditingController? controller;
  final bool isLoading;

  @override
  State<EnterDeliveryAddressBottomSheet> createState() =>
      _EnterDeliveryAddressBottomSheetState();
}

class _EnterDeliveryAddressBottomSheetState
    extends State<EnterDeliveryAddressBottomSheet> {
  final TextEditingController addressController = TextEditingController();
  double? latitude, longitude;

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state is AddingAddressFail) {
          if (state.error.toLowerCase() == "unauthenticated") {
            context.buildError(state.error);
            context.logout();
          } else {
            context.buildError(state.error);
          }
        }
      },
      builder: (context, state) => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const FoodBankBottomSheetAppBar(
            title: 'Enter Delivery Address',
          ),
          const Divider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: addressController,
              googleAPIKey: dotenv.env['GOOGLE_MAP_API_KEY'] ?? '',
              inputDecoration: InputDecoration(
                hintText: "Enter your full delivery address",
                prefixIcon: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 14),
                      child: SizedBox(
                        child: SvgPicture.asset('assets/icons/search.svg'),
                      ),
                    ),
                  ],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6),
                  borderSide: BorderSide.none,
                ),
              ),
              // debounceTime: 800, // default 600 ms,
              countries: const ["ng"], // optional by default null is set
              isLatLngRequired:
                  true, // if you required coordinates from place detail
              getPlaceDetailWithLatLng: (Prediction prediction) {
                setState(
                  () {
                    widget.controller!.text = prediction.description ?? '';
                    latitude = double.parse(prediction.lat!);
                    longitude = double.parse(prediction.lng!);
                  },
                );
              },
              itemClick: (Prediction prediction) {
                addressController.text = prediction.description!;
                addressController.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: prediction.description!.length,
                  ),
                );
              },
              itemBuilder: (context, index, Prediction prediction) {
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(
                        width: 7,
                      ),
                      Expanded(
                        child: Text(
                          prediction.description ?? "",
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                        ),
                      )
                    ],
                  ),
                );
              },
              seperatedBuilder: const Divider(),
              isCrossBtnShown: true,
              containerHorizontalPadding: 10,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: InkWell(
              onTap: () async {
                try {
                  final myCurrentLocation = await useCurrentLocation();
                  if (myCurrentLocation.$1.isNotEmpty) {
                    setState(
                      () {
                        widget.controller!.text = myCurrentLocation.$1;
                        latitude = myCurrentLocation.$2;
                        longitude = myCurrentLocation.$3;
                      },
                    );
                    widget.onAdd!(latitude!, longitude!);
                    // context.pop();
                  }
                } catch (e) {
                  context.buildError("Enter a valid location.");
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).primaryColor,
                    width: 0.8,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    const SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: Text(
                        "Use current location",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          if (addressController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cannot Find My Address?",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.amber[900],
                        ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      try {
                        List<Location> locations =
                            await locationFromAddress(addressController.text);
                        if (locations.isNotEmpty) {
                          setState(
                            () {
                              widget.controller!.text = addressController.text;
                              latitude = locations.first.latitude;
                              longitude = locations.first.longitude;
                            },
                          );
                        }
                      } catch (e) {
                        context.buildError("Enter a valid location.");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 0.8,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on),
                          const SizedBox(
                            width: 7,
                          ),
                          Expanded(
                            child: Text(
                              addressController.text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(
                    isLoading: state is AddingAddress,
                    onTap: () {
                      widget.onAdd!(latitude!, longitude!);
                    },
                    text: "Submit Address",
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
