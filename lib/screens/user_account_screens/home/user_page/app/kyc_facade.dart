import 'package:fpdart/fpdart.dart';

import '../../../../../core/errors/failure.dart';
import '../services/kyc_service.dart';

class KycFacade {
  final KycService _kycService;
  KycFacade({required KycService kycService}) : _kycService = kycService;

  Future<Either<Failure, String>> kyc({
    required String bvn,
    required String dob,
    required String address,
    required String gender,
    required String phone,
  }) {
    return _kycService
        .kyc(
          bvn: bvn,
          dob: dob,
          address: address,
          gender: gender,
          phone: phone,
        )
        .run();
  }
}
