part of '../../../../core/injections.dart';

class BagInjection extends ServiceInjection {
  @override
  Future<void> register() async {
    sl.registerFactory<BagBloc>(
      () => BagBloc(
        bagFacade: sl(),
      ),
    );

    sl.registerLazySingleton<BagFacade>(
      () => BagFacade(
        bagService: sl(),
      ),
    );

    sl.registerLazySingleton<BagService>(
      () => BagServiceImpl(
        bagLocalSource: sl(),
        networkInfo: sl(),
        bagRemoteSource: sl(),
      ),
    );

    sl.registerLazySingleton<BagLocalSource>(
      () => BagLocalSourceImpl(
        bagDatabaseHelper: sl(),
      ),
    );

    sl.registerLazySingleton<BagRemoteSource>(
      () => BagRemoteSourceImpl(
        apiClient: sl(),
      ),
    );
  }
}
