part of 'package:food_bank/core/injections.dart';

class CheckoutInjection extends ServiceInjection {
  @override
  Future<void> register() async {
    sl.registerFactory<CheckoutBloc>(
      () => CheckoutBloc(
        checkoutFacade: sl(),
      ),
    );

    sl.registerLazySingleton<CheckoutFacade>(
      () => CheckoutFacade(
        checkoutService: sl(),
      ),
    );

    sl.registerLazySingleton<CheckoutService>(
      () => CheckoutServiceImpl(
        networkInfo: sl(),
        checkoutRemoteSource: sl(),
      ),
    );

    sl.registerLazySingleton<CheckoutRemoteSource>(
      () => CheckoutRemoteSourceImpl(
        apiClient: sl(),
      ),
    );
  }
}
