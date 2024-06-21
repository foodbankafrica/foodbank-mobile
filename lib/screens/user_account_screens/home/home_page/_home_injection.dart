part of '../../../../core/injections.dart';

class HomeInjection extends ServiceInjection {
  @override
  Future<void> register() async {
    sl.registerFactory<BusinessBloc>(
      () => BusinessBloc(
        businessFacade: sl(),
      ),
    );

    sl.registerLazySingleton<BusinessFacade>(
      () => BusinessFacade(
        businessService: sl(),
      ),
    );

    sl.registerLazySingleton<BusinessService>(
      () => BusinessServiceImpl(
        businessRemoteSource: sl(),
        networkInfo: sl(),
      ),
    );

    sl.registerLazySingleton<BusinessRemoteSource>(
      () => BusinessRemoteSourceImpl(
        apiClient: sl(),
      ),
    );
  }
}
