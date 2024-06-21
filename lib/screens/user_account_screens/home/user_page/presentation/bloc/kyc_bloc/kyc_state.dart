part of 'kyc_bloc.dart';

abstract class KycState {}

class KycInitial extends KycState {}

class Verifying extends KycState {}

class VerificationSuccessful extends KycState {
  final String message;
  VerificationSuccessful(this.message);
}

class VerificationFail extends KycState {
  final String error;
  VerificationFail(this.error);
}
