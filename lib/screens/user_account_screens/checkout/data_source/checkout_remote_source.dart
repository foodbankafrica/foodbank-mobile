import 'package:food_bank/core/errors/custom_exeption.dart';
import 'package:food_bank/screens/user_account_screens/checkout/data_source/checkout_endpoint.dart';
import 'package:food_bank/screens/user_account_screens/checkout/models/checkout_model.dart';
import 'package:food_bank/screens/user_account_screens/checkout/models/donate_model.dart'
    hide Donation;

import '../../../../core/networks/api_clients.dart';
import '../../home/my_bag_page/models/donation_model.dart';

abstract class CheckoutRemoteSource {
  Future<CheckoutModel> checkout({
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
  Future<String> verifyTransaction({
    required String transactionRef,
  });
  Future<DonateCheckout> donating({
    required List<Map<String, dynamic>> products,
    required String type,
    required String vendorId,
    required String privateDonation,
    required num noOfPeople,
    required bool isAnonymous,
  });
  Future<String> redeem({
    required String address,
    required num donationId,
  });
  Future<String> redeemPrivateDonation({
    required String address,
    required num donationId,
    required String redeemCode,
  });
  Future<DonationsResponse> getDonation(int pageNumber);
  Future<Donation> searchForDonation(String redeemCode);
}

class CheckoutRemoteSourceImpl implements CheckoutRemoteSource {
  final ApiClient _apiClient;

  CheckoutRemoteSourceImpl({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  @override
  Future<CheckoutModel> checkout({
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
  }) async {
    final isGift = to.isEmpty ? 0 : 1;
    final res = await _apiClient.post(
      url: isCard
          ? CheckoutEndpoint.checkoutWithCard
          : CheckoutEndpoint.checkout,
      body: type == "reoccurring"
          ? subDeliveryType.toLowerCase() == "pickup"
              ? {
                  "products": products,
                  "branch_id": branchId,
                  "business_id": businessId,
                  "sub_total": subTotal,
                  "total": total,
                  "delivery_fee": deliveryFee,
                  "type": type,
                  "vendor_id": vendorId,
                  "from": from,
                  "to": to,
                  "to_phone": toPhone,
                  "sub_delivery_type": subDeliveryType.toLowerCase(),
                  "sub_timeline":
                      subTimeline, //in days  7 for weekly, 14 for bi weekly, 30 monthly
                  "sub_preference": subPreference,
                  "sub_start_date": startDate,
                  "sub_end_date": endDate,
                  "is_gift": isGift,
                }
              : {
                  "products": products, "branch_id": branchId,
                  "business_id": businessId,
                  "delivery_location": deliveryLocation,
                  "address": address,
                  "sub_total": subTotal,
                  "total": total,
                  "delivery_fee": deliveryFee,
                  "type": type,
                  "vendor_id": vendorId,
                  "from": from,
                  "to": to,
                  "to_phone": toPhone,
                  "sub_delivery_type": subDeliveryType.toLowerCase(),
                  "sub_timeline":
                      subTimeline, //in days  7 for weekly, 14 for bi weekly, 30 monthly
                  "sub_preference": subPreference,
                  "sub_start_date": startDate,
                  "sub_end_date": endDate,
                  "is_gift": isGift,
                }
          : type == "pickup"
              ? {
                  "products": products,
                  "business_id": businessId,
                  "branch_id": branchId,
                  "sub_total": subTotal,
                  "total": total,
                  "delivery_fee": deliveryFee,
                  "type": type,
                  "vendor_id": vendorId,
                  "from": from,
                  "to": to,
                  "to_phone": toPhone,
                  "is_gift": isGift,
                }
              : {
                  "products": products,
                  "branch_id": branchId,
                  "business_id": businessId,
                  "sub_total": subTotal,
                  "delivery_location": deliveryLocation,
                  "address": address,
                  "total": total,
                  "delivery_fee": deliveryFee,
                  "type": type,
                  "vendor_id": vendorId,
                  "from": from,
                  "to": to,
                  "to_phone": toPhone,
                  "is_gift": isGift,
                },
    );
    if (res.isSuccessful) {
      return CheckoutModel.fromJson(res.data);
    }
    throw CustomException(message: res.error!);
  }

  @override
  Future<DonateCheckout> donating({
    required List<Map<String, dynamic>> products,
    required String type,
    required String vendorId,
    required String privateDonation,
    required num noOfPeople,
    required bool isAnonymous,
  }) async {
    final res = await _apiClient.post(url: CheckoutEndpoint.donation, body: {
      "products": products,
      "type": type,
      "vendor_id": vendorId,
      "no_of_people": noOfPeople,
      "is_anonymous": isAnonymous,
      "is_private": privateDonation,
    });
    if (res.isSuccessful) {
      return DonateCheckout.fromJson(res.data);
    }
    throw CustomException(message: res.error!);
  }

  @override
  Future<DonationsResponse> getDonation(int pageNumber) async {
    final res = await _apiClient.get(
      url: CheckoutEndpoint.getDonations(pageNumber),
    );
    if (res.isSuccessful) {
      return DonationsResponse.fromJson(res.data);
    }
    throw CustomException(message: res.error!);
  }

  @override
  Future<String> redeem({
    required String address,
    required num donationId,
  }) async {
    final res = await _apiClient.post(url: CheckoutEndpoint.redeem, body: {
      "donation_id": donationId,
      "address": address,
    });
    if (res.isSuccessful) {
      return res.message!;
    }
    throw CustomException(message: res.error!);
  }

  @override
  Future<String> redeemPrivateDonation({
    required String address,
    required num donationId,
    required String redeemCode,
  }) async {
    final res = await _apiClient
        .post(url: CheckoutEndpoint.redeemPrivateDonation, body: {
      "donation_id": donationId,
      "redeem_code": redeemCode,
      "address": address,
    });
    if (res.isSuccessful) {
      return res.message!;
    }
    throw CustomException(message: res.error!);
  }

  @override
  Future<Donation> searchForDonation(String redeemCode) async {
    final res = await _apiClient.get(
      url: CheckoutEndpoint.searchForDonation(redeemCode),
    );
    if (res.isSuccessful) {
      return Donation.fromJson(res.data["donation"]);
    }
    throw CustomException(message: res.error!);
  }

  @override
  Future<String> verifyTransaction({required String transactionRef}) async {
    final res = await _apiClient.get(
      url: CheckoutEndpoint.verifyTransaction(transactionRef),
    );
    if (res.isSuccessful) {
      return res.message!;
    }
    throw CustomException(message: res.error!);
  }
}
