import 'package:food_bank/core/errors/failure.dart';
import 'package:food_bank/screens/user_account_screens/checkout/models/checkout_model.dart';
import 'package:food_bank/screens/user_account_screens/checkout/services/checkout_service.dart';
import 'package:fpdart/fpdart.dart';

import '../../home/my_bag_page/models/donation_model.dart';
import '../models/donate_model.dart' hide Donation;

class CheckoutFacade {
  final CheckoutService _checkoutService;
  CheckoutFacade({required CheckoutService checkoutService})
      : _checkoutService = checkoutService;

  Future<Either<Failure, CheckoutModel>> chekout({
    required List<Map<String, dynamic>> products,
    required String address,
    required String branchId,
    required String businessId,
    required String deliveryLocation,
    required num subTotal,
    required num total,
    required num deliveryFee,
    required String type,
    required String vendorId,
    required String from,
    required String to,
    required String toPhone,
    required String startDate,
    required String endDate,
    required int subTimeline,
    required String subDeliveryType,
    required int subPreference,
    required bool isCard,
  }) {
    return _checkoutService
        .checkout(
          products: products,
          branchId: branchId,
          businessId: businessId,
          address: address,
          deliveryLocation: deliveryLocation,
          subTotal: subTotal,
          total: total,
          deliveryFee: deliveryFee,
          type: type,
          vendorId: vendorId,
          from: from,
          to: to,
          toPhone: toPhone,
          startDate: startDate,
          endDate: endDate,
          subDeliveryType: subDeliveryType,
          subPreference: subPreference,
          subTimeline: subTimeline,
          isCard: isCard,
        )
        .run();
  }

  Future<Either<Failure, DonateCheckout>> donating({
    required List<Map<String, dynamic>> products,
    required String type,
    required String vendorId,
    required String privateDonation,
    required num noOfPeople,
    required bool isAnonymous,
    required String branchId,
    required String businessId,
  }) {
    return _checkoutService
        .donating(
          products: products,
          type: type,
          vendorId: vendorId,
          noOfPeople: noOfPeople,
          isAnonymous: isAnonymous,
          privateDonation: privateDonation,
          branchId: branchId,
          businessId: businessId,
        )
        .run();
  }

  Future<Either<Failure, DonationsResponse>> getDonation(int pageNumber) {
    return _checkoutService.getDonation(pageNumber).run();
  }

  Future<Either<Failure, String>> redeem({
    required String address,
    required num donationId,
  }) {
    return _checkoutService
        .redeem(
          address: address,
          donationId: donationId,
        )
        .run();
  }

  Future<Either<Failure, String>> redeemPrivateDonation({
    required String address,
    required num donationId,
    required String redeemCode,
  }) {
    return _checkoutService
        .redeemPrivateDonation(
          address: address,
          donationId: donationId,
          redeemCode: redeemCode,
        )
        .run();
  }

  Future<Either<Failure, Donation>> searchForDonation(String redeemCode) {
    return _checkoutService.searchForDonation(redeemCode).run();
  }

  Future<Either<Failure, String>> verifyTransaction(
      {required String transactionRef}) {
    return _checkoutService
        .verifyTransaction(transactionRef: transactionRef)
        .run();
  }
}
