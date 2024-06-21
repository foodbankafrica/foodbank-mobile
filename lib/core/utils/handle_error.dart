import '../errors/custom_exeption.dart';
import '../errors/failure.dart';
import 'package:http/http.dart';

mixin HandleError {
  Failure handleError(Object error) {
    print(error.runtimeType);
    switch (error.runtimeType) {
      case const (NoInternetFailure):
        return const NoInternetFailure();
      case const (CustomException):
        return ServerFailure(message: (error as CustomException).message);
      case const (ClientException):
        return ServerFailure(message: (error as ClientException).message);
      default:
        return const ServerFailure(message: "Something went wrong");
    }
  }
}
