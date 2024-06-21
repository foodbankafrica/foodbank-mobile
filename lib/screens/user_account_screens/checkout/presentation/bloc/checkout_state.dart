part of './checkout_bloc.dart';

abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckingOut extends CheckoutState {}

class CheckingOutSuccessful extends CheckoutState {
  final CheckoutModel res;
  CheckingOutSuccessful(this.res);
}

class CheckingOutFail extends CheckoutState {
  final String error;
  CheckingOutFail({required this.error});
}

class CreatingDonation extends CheckoutState {}

class CreatingDonationSuccessful extends CheckoutState {
  final DonateCheckout res;
  CreatingDonationSuccessful(this.res);
}

class CreatingDonationFail extends CheckoutState {
  final String error;
  CreatingDonationFail({required this.error});
}

class GettingDonationsOut extends CheckoutState {}

class GettingDonationsSuccessful extends CheckoutState {
  final DonationsResponse res;
  GettingDonationsSuccessful(this.res);
}

class GettingDonationsFail extends CheckoutState {
  final String error;
  GettingDonationsFail({required this.error});
}

class RedeemingDonation extends CheckoutState {}

class RedeemingDonationSuccessful extends CheckoutState {
  final String res;
  RedeemingDonationSuccessful(this.res);
}

class RedeemingDonationFail extends CheckoutState {
  final String error;
  RedeemingDonationFail({required this.error});
}

class SearchingForDonation extends CheckoutState {}

class SearchingForDonationSuccessful extends CheckoutState {
  final Donation res;
  SearchingForDonationSuccessful(this.res);
}

class SearchingForDonationFail extends CheckoutState {
  final String error;
  SearchingForDonationFail({required this.error});
}

class VerifyTransaction extends CheckoutState {}

class VerifyTransactionSuccessful extends CheckoutState {
  final String message;
  VerifyTransactionSuccessful(this.message);
}

class VerifyTransactionFail extends CheckoutState {
  final String error;
  VerifyTransactionFail({required this.error});
}
