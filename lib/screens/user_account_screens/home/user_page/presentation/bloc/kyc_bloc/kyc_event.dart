part of 'kyc_bloc.dart';

abstract class KycEvent {}

class VerificationEvent extends KycEvent {
  final String bvn, dob, address, gender, phone;
  VerificationEvent({
    required this.bvn,
    required this.dob,
    required this.address,
    required this.gender,
    required this.phone,
  });
}
