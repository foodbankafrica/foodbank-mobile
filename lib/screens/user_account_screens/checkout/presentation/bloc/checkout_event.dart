part of './checkout_bloc.dart';

abstract class CheckoutEvent {}

class CheckingOutEvent extends CheckoutEvent {
  final List<Map<String, dynamic>> products;
  final String address;
  final String branchId, businessId;
  final String deliveryLocation;
  final num subTotal;
  final num total;
  final num deliveryFee;
  final String type;
  final String vendorId;
  final bool isCard;
  final String? from, to, toPhone, startDate, subDeliveryType, endDate;
  final int? subTimeline, subPreference;

  CheckingOutEvent({
    required this.address,
    required this.branchId,
    required this.businessId,
    required this.deliveryLocation,
    required this.deliveryFee,
    required this.products,
    required this.type,
    required this.subTotal,
    required this.total,
    required this.vendorId,
    this.from,
    this.toPhone,
    this.to,
    this.startDate,
    this.endDate,
    this.subDeliveryType,
    this.subPreference,
    this.subTimeline,
    required this.isCard,
  });
}

class DonatingEvent extends CheckoutEvent {
  final List<Map<String, dynamic>> products;
  final num noOfPeople;
  final bool isAnonymous;
  final String type;
  final String vendorId;
  final String branchId, businessId;
  final String privateDonation;

  DonatingEvent({
    required this.isAnonymous,
    required this.noOfPeople,
    required this.privateDonation,
    required this.products,
    required this.type,
    required this.vendorId,
    required this.branchId,
    required this.businessId,
  });
}

class RedeemingDonationEvent extends CheckoutEvent {
  final num donationId;
  final String address;

  RedeemingDonationEvent({
    required this.address,
    required this.donationId,
  });
}

class RedeemingPrivateDonationEvent extends CheckoutEvent {
  final num donationId;
  final String address;
  final String redeemCode;

  RedeemingPrivateDonationEvent({
    required this.address,
    required this.donationId,
    required this.redeemCode,
  });
}

class GettingDonationsEvent extends CheckoutEvent {
  final int pageNumber;
  GettingDonationsEvent(this.pageNumber);
}

class SearchingForDonationEvent extends CheckoutEvent {
  final String redeemCode;
  SearchingForDonationEvent(this.redeemCode);
}

class VerifyTransactionEvent extends CheckoutEvent {
  final String transactionRef;
  VerifyTransactionEvent(this.transactionRef);
}
