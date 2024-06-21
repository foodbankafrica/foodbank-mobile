import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/kyc_facade.dart';

part 'kyc_event.dart';
part 'kyc_state.dart';

class KycBloc extends Bloc<KycEvent, KycState> {
  final KycFacade _kycFacade;
  KycBloc({
    required KycFacade kycFacade,
  })  : _kycFacade = kycFacade,
        super(KycInitial()) {
    on<VerificationEvent>(_addAddress);
  }
  void _addAddress(VerificationEvent event, Emitter<KycState> emit) async {
    emit(Verifying());
    final failureOrSuccess = await _kycFacade.kyc(
      bvn: event.bvn,
      dob: event.dob,
      address: event.address,
      gender: event.gender,
      phone: event.phone,
    );
    failureOrSuccess.fold(
      (error) => emit(VerificationFail(error.message)),
      (message) => emit(VerificationSuccessful(message)),
    );
  }
}
