import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/core/errors/failure.dart';
import 'package:food_bank/core/networks/do_internet_check.dart';
import 'package:food_bank/core/networks/internet_info.dart';
import 'package:food_bank/core/utils/handle_error.dart';
import 'package:food_bank/screens/user_account_screens/checkout/data_source/checkout_remote_source.dart';
import 'package:fpdart/fpdart.dart';

import '../../home/my_bag_page/models/donation_model.dart';
import '../models/checkout_model.dart';
import '../models/donate_model.dart' hide Donation;

abstract class CheckoutService {
  TaskEither<Failure, CheckoutModel> checkout({
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
  });
  TaskEither<Failure, String> verifyTransaction(
      {required String transactionRef});
  TaskEither<Failure, DonateCheckout> donating({
    required List<Map<String, dynamic>> products,
    required String type,
    required String vendorId,
    required String privateDonation,
    required num noOfPeople,
    required bool isAnonymous,
    required String branchId,
    required String businessId,
  });
  TaskEither<Failure, DonationsResponse> getDonation(int pageNumber);
  TaskEither<Failure, String> redeem({
    required String address,
    required num donationId,
  });
  TaskEither<Failure, String> redeemPrivateDonation({
    required String address,
    required num donationId,
    required String redeemCode,
  });
  TaskEither<Failure, Donation> searchForDonation(String redeemCode);
}

class CheckoutServiceImpl extends CheckoutService
    with HandleError, DoInternetCheck {
  final NetworkInfo _networkInfo;
  final CheckoutRemoteSource _checkoutRemoteSource;

  CheckoutServiceImpl({
    required NetworkInfo networkInfo,
    required CheckoutRemoteSource checkoutRemoteSource,
  })  : _networkInfo = networkInfo,
        _checkoutRemoteSource = checkoutRemoteSource;

  @override
  TaskEither<Failure, CheckoutModel> checkout({
    required List<Map<String, dynamic>> products,
    required String branchId,
    required String businessId,
    required String address,
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
    return TaskEither.tryCatch(
      () async => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _checkoutRemoteSource.checkout(
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
          endDate: startDate,
          subDeliveryType: subDeliveryType,
          subPreference: subPreference,
          subTimeline: subTimeline,
          isCard: isCard,
        );
        return res;
      }),
      (error, stackTrace) {
        "error $error, stackTrace $stackTrace".log();
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, DonateCheckout> donating({
    required List<Map<String, dynamic>> products,
    required String type,
    required String vendorId,
    required String privateDonation,
    required num noOfPeople,
    required bool isAnonymous,
    required String branchId,
    required String businessId,
  }) {
    return TaskEither.tryCatch(
      () async => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _checkoutRemoteSource.donating(
          products: products,
          type: type,
          vendorId: vendorId,
          noOfPeople: noOfPeople,
          isAnonymous: isAnonymous,
          privateDonation: privateDonation,
          branchId: branchId,
          businessId: businessId,
        );
        return res;
      }),
      (error, stackTrace) {
        "error $error, stackTrace $stackTrace".log();
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, DonationsResponse> getDonation(int pageNumber) {
    return TaskEither.tryCatch(
      () async => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _checkoutRemoteSource.getDonation(pageNumber);
        return res;
      }),
      (error, stackTrace) {
        "error $error, stackTrace $stackTrace".log();
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, String> redeem({
    required String address,
    required num donationId,
  }) {
    return TaskEither.tryCatch(
      () async => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _checkoutRemoteSource.redeem(
          address: address,
          donationId: donationId,
        );
        return res;
      }),
      (error, stackTrace) {
        "error $error, stackTrace $stackTrace".log();
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, String> redeemPrivateDonation({
    required String address,
    required num donationId,
    required String redeemCode,
  }) {
    return TaskEither.tryCatch(
      () async => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _checkoutRemoteSource.redeemPrivateDonation(
          address: address,
          donationId: donationId,
          redeemCode: redeemCode,
        );
        return res;
      }),
      (error, stackTrace) {
        "error $error, stackTrace $stackTrace".log();
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, Donation> searchForDonation(String redeemCode) {
    return TaskEither.tryCatch(
      () async => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _checkoutRemoteSource.searchForDonation(redeemCode);
        return res;
      }),
      (error, stackTrace) {
        "error $error, stackTrace $stackTrace".log();
        return handleError(error);
      },
    );
  }

  @override
  TaskEither<Failure, String> verifyTransaction(
      {required String transactionRef}) {
    return TaskEither.tryCatch(
      () async => checkInternetThenMakeRequest(_networkInfo, request: () async {
        final res = await _checkoutRemoteSource.verifyTransaction(
            transactionRef: transactionRef);
        return res;
      }),
      (error, stackTrace) {
        "error $error, stackTrace $stackTrace".log();
        return handleError(error);
      },
    );
  }
}
