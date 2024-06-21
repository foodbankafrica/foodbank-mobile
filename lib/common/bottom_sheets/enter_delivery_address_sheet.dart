// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/bloc/address_bloc/address_bloc.dart';
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

  @override
  void dispose() {
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddressBloc, AddressState>(
      listener: (context, state) {
        print(state);
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
              googleAPIKey: "AIzaSyAyYEFe4MMHwD-zNVVpfWKIRcFiE-e2TN8",
              inputDecoration: InputDecoration(
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
              countries: ["ng"], // optional by default null is set
              isLatLngRequired:
                  true, // if you required coordinates from place detail
              getPlaceDetailWithLatLng: (Prediction prediction) {
                // this method will return latlng with place detail
                print("placeDetails" + prediction.lng.toString());
              }, // this callback is called when isLatLngRequired is true
              itemClick: (Prediction prediction) {
                addressController.text = prediction.description!;
                addressController.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: prediction.description!.length,
                  ),
                );
                setState(
                  () {
                    widget.controller!.text = prediction.description ?? '';
                  },
                );
                final latitude = double.parse(prediction.lat ?? "0");
                final longitude = double.parse(prediction.lng ?? "0");
                widget.onAdd!(latitude, longitude);
              },
              // if we want to make custom list item builder
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
              // if you want to add seperator between list items
              seperatedBuilder: const Divider(),
              // want to show close icon
              isCrossBtnShown: true,
              // optional container padding
              containerHorizontalPadding: 10,
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

                        print(
                            "${locations.first.latitude}${locations.first.longitude}");
                        if (locations.isNotEmpty) {
                          setState(
                            () {
                              widget.controller!.text = addressController.text;
                            },
                          );
                          final latitude = locations.first.latitude;
                          final longitude = locations.first.longitude;
                          widget.onAdd!(latitude, longitude);
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
                ],
              ),
            ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
