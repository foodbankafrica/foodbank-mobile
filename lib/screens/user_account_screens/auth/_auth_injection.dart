part of '../../../core/injections.dart';

class AuthInjection extends ServiceInjection {
  @override
  Future<void> register() async {
    sl.registerFactory<AuthBloc>(
      () => AuthBloc(
        authFacade: sl(),
      ),
    );

    sl.registerLazySingleton<AuthRemoteSource>(
      () => AuthRemoteSourceImpl(
        apiClient: sl(),
        cacheStore: sl(),
      ),
    );

    sl.registerLazySingleton<AuthService>(
      () => AuthServiceImpl(
        authRemoteSource: sl(),
        networkInfo: sl(),
      ),
    );

    sl.registerLazySingleton<AuthFacade>(
      () => AuthFacade(
        authService: sl(),
      ),
    );
  }
}
