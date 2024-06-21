import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  final String message;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.stackTrace,
  });

  @override
  List<Object?> get props => [message, stackTrace];
}

class NoInternetFailure extends Failure {
  const NoInternetFailure({super.message = "No internet connection."});
}

class UnExpectedValueFailure extends Failure {
  const UnExpectedValueFailure({required super.message});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

class NoUserSignInFailure extends Failure {
  const NoUserSignInFailure({super.message = "No user sign in"});
}
