import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/screens/user_account_screens/checkout/app/checkout_facade.dart';
import 'package:food_bank/screens/user_account_screens/checkout/models/checkout_model.dart';

import '../../../home/my_bag_page/models/donation_model.dart';
import '../../models/donate_model.dart' hide Donation;

part './checkout_event.dart';
part './checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutFacade _checkoutFacade;
  CheckoutBloc({required CheckoutFacade checkoutFacade})
      : _checkoutFacade = checkoutFacade,
        super(
          CheckoutInitial(),
        ) {
    on<CheckoutEvent>(
      (event, emit) async {
        if (event is CheckingOutEvent) {
          emit(CheckingOut());
          final failureOrSuccess = await _checkoutFacade.chekout(
            isCard: event.isCard,
            businessId: event.businessId,
            branchId: event.branchId,
            products: event.products,
            address: event.address,
            deliveryLocation: event.deliveryLocation,
            subTotal: event.subTotal,
            total: event.total,
            deliveryFee: event.deliveryFee,
            type: event.type,
            vendorId: event.vendorId,
            from: event.from ?? "",
            to: event.to ?? "",
            toPhone: event.toPhone ?? "",
            startDate: event.startDate ?? "",
            endDate: event.endDate ?? "",
            subDeliveryType: event.subDeliveryType ?? "",
            subPreference: event.subPreference ?? 0,
            subTimeline: event.subTimeline ?? 0,
          );
          failureOrSuccess.fold(
            (error) => emit(CheckingOutFail(error: error.message)),
            (res) => emit(CheckingOutSuccessful(res)),
          );
        }

        if (event is DonatingEvent) {
          emit(CreatingDonation());
          final failureOrSuccess = await _checkoutFacade.donating(
            products: event.products,
            type: event.type,
            vendorId: event.vendorId,
            noOfPeople: event.noOfPeople,
            isAnonymous: event.isAnonymous,
            privateDonation: event.privateDonation,
            branchId: event.branchId,
            businessId: event.businessId,
          );
          failureOrSuccess.fold(
            (error) => emit(CreatingDonationFail(error: error.message)),
            (res) => emit(CreatingDonationSuccessful(res)),
          );
        }
        if (event is GettingDonationsEvent) {
          emit(GettingDonationsOut());
          final failureOrSuccess =
              await _checkoutFacade.getDonation(event.pageNumber);
          failureOrSuccess.fold(
            (error) => emit(GettingDonationsFail(error: error.message)),
            (res) => emit(GettingDonationsSuccessful(res)),
          );
        }
        if (event is RedeemingDonationEvent) {
          emit(RedeemingDonation());
          final failureOrSuccess = await _checkoutFacade.redeem(
            address: event.address,
            donationId: event.donationId,
          );
          failureOrSuccess.fold(
            (error) => emit(RedeemingDonationFail(error: error.message)),
            (res) => emit(RedeemingDonationSuccessful(res)),
          );
        }
        if (event is RedeemingPrivateDonationEvent) {
          emit(RedeemingDonation());
          final failureOrSuccess = await _checkoutFacade.redeemPrivateDonation(
            address: event.address,
            donationId: event.donationId,
            redeemCode: event.redeemCode,
          );
          failureOrSuccess.fold(
            (error) => emit(RedeemingDonationFail(error: error.message)),
            (res) => emit(RedeemingDonationSuccessful(res)),
          );
        }
        if (event is SearchingForDonationEvent) {
          emit(SearchingForDonation());
          final failureOrSuccess = await _checkoutFacade.searchForDonation(
            event.redeemCode,
          );
          failureOrSuccess.fold(
            (error) => emit(SearchingForDonationFail(error: error.message)),
            (res) => emit(SearchingForDonationSuccessful(res)),
          );
        }
        if (event is VerifyTransactionEvent) {
          emit(VerifyTransaction());
          final failureOrSuccess = await _checkoutFacade.verifyTransaction(
            transactionRef: event.transactionRef,
          );
          failureOrSuccess.fold(
            (error) => emit(VerifyTransactionFail(error: error.message)),
            (res) => emit(VerifyTransactionSuccessful(res)),
          );
        }
      },
    );
  }
}
