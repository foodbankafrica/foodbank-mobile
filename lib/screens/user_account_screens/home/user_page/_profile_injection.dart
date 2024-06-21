part of '../../../../core/injections.dart';

class ProfileInjection extends ServiceInjection {
  @override
  Future<void> register() async {
    sl.registerFactory<AddressBloc>(
      () => AddressBloc(
        addressFacade: sl(),
      ),
    );
    sl.registerFactory<KycBloc>(
      () => KycBloc(
        kycFacade: sl(),
      ),
    );

    sl.registerLazySingleton<AddressFacade>(
      () => AddressFacade(
        addressService: sl(),
      ),
    );
    sl.registerLazySingleton<KycFacade>(
      () => KycFacade(
        kycService: sl(),
      ),
    );

    sl.registerLazySingleton<AddressService>(
      () => AddressServiceImpl(
        networkInfo: sl(),
        addressRemote: sl(),
      ),
    );

    sl.registerLazySingleton<KycService>(
      () => KycServiceImpl(
        networkInfo: sl(),
        kycRemote: sl(),
      ),
    );

    sl.registerLazySingleton<AddressRemote>(
      () => AddressRemoteImpl(
        apiClient: sl(),
      ),
    );

    sl.registerLazySingleton<KycRemote>(
      () => KycRemoteImpl(
        apiClient: sl(),
      ),
    );
  }
}
