import 'package:food_bank/core/cache/cache_store.dart';
import 'package:food_bank/core/networks/api_clients.dart';
import 'package:food_bank/core/networks/internet_info.dart';
import 'package:food_bank/screens/user_account_screens/checkout/app/checkout_facade.dart';
import 'package:food_bank/screens/user_account_screens/checkout/data_source/checkout_remote_source.dart';
import 'package:food_bank/screens/user_account_screens/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:food_bank/screens/user_account_screens/checkout/services/checkout_service.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/app/business_facade.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/data_source/business_remote_data_source.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/services/business_services.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/data_source/bag_remote_source.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/app/address_facade.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/data_source/address/address_remote_source.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/bloc/address_bloc/address_bloc.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/services/address_service.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/services/kyc_service.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../screens/user_account_screens/auth/app/auth_facade.dart';
import '../screens/user_account_screens/auth/data_source/auth_remote_source.dart';
import '../screens/user_account_screens/auth/presentation/bloc/auth_bloc.dart';
import '../screens/user_account_screens/auth/services/auth_services.dart';
import '../screens/user_account_screens/home/home_page/presentation/bloc/business_bloc.dart';
import '../screens/user_account_screens/home/my_bag_page/app/bag_facade.dart';
import '../screens/user_account_screens/home/my_bag_page/data_source/bag_db_helper.dart';
import '../screens/user_account_screens/home/my_bag_page/data_source/data_local_source.dart';
import '../screens/user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';
import '../screens/user_account_screens/home/my_bag_page/services/bag_service.dart';
import '../screens/user_account_screens/home/user_page/app/kyc_facade.dart';
import '../screens/user_account_screens/home/user_page/data_source/kyc/kyc_remote_source.dart';
import '../screens/user_account_screens/home/user_page/presentation/bloc/kyc_bloc/kyc_bloc.dart';

part '../screens/user_account_screens/auth/_auth_injection.dart';
part '../screens/user_account_screens/home/user_page/_profile_injection.dart';
part '../screens/user_account_screens/home/home_page/_home_injection.dart';
part '../screens/user_account_screens/home/my_bag_page/_bag_injections.dart';
part '../screens/user_account_screens/checkout/_chckout_injection.dart';

final sl = GetIt.instance;

abstract class ServiceInjection {
  Future<void> register();
}

Future<void> initInjection(List<ServiceInjection> services) async {
  for (var service in services) {
    await service.register();
  }

  sl.registerLazySingleton<InternetConnection>(
    () => InternetConnection(),
  );

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      internetConnection: sl(),
    ),
  );

  sl.registerLazySingleton<CacheStore>(
    () => CacheStore(),
  );

  sl.registerLazySingleton<ApiClient>(
    () => ApiClientImpl(
      cacheStore: sl(),
    ),
  );

  sl.registerLazySingleton<BagDatabaseHelper>(
    () => BagDatabaseHelper(),
  );
}
