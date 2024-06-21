import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/core/errors/failure.dart';
import 'package:food_bank/core/networks/do_internet_check.dart';
import 'package:food_bank/core/utils/handle_error.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../../core/networks/internet_info.dart';
import '../data_source/kyc/kyc_remote_source.dart';

abstract class KycService {
  TaskEither<Failure, String> kyc({
    required String bvn,
    required String dob,
    required String address,
    required String gender,
    required String phone,
  });
}

class KycServiceImpl extends KycService with HandleError, DoInternetCheck {
  final NetworkInfo _networkInfo;
  final KycRemote _kycRemote;

  KycServiceImpl({
    required NetworkInfo networkInfo,
    required KycRemote kycRemote,
  })  : _kycRemote = kycRemote,
        _networkInfo = networkInfo;
  @override
  TaskEither<Failure, String> kyc({
    required String bvn,
    required String dob,
    required String address,
    required String gender,
    required String phone,
  }) {
    return TaskEither.tryCatch(
      () => checkInternetThenMakeRequest(
        _networkInfo,
        request: () async {
          final res = await _kycRemote.kyc(
            bvn: bvn,
            dob: dob,
            address: address,
            gender: gender,
            phone: phone,
          );
          return res;
        },
      ),
      (error, stackTrace) {
        "error $error, stackTrack $stackTrace".log();
        return handleError(error);
      },
    );
  }
}
