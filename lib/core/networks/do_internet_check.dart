import '../errors/failure.dart';
import 'internet_info.dart';

mixin DoInternetCheck {
  Future<T> checkInternetThenMakeRequest<T>(
    NetworkInfo networkInfo, {
    required Future<T> Function() request,
  }) async {
    if (await networkInfo.isConnected) {
      return await request();
    } else {
      throw const NoInternetFailure();
    }
  }
}
