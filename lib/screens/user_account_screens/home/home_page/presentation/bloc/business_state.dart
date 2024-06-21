part of './business_bloc.dart';

abstract class BusinessState {}

class BusinessesInitial extends BusinessState {}

class GettingBusinesses extends BusinessState {}

class GettingBusinessesSuccessful extends BusinessState {
  final BusinessResponse businessResponse;
  GettingBusinessesSuccessful(this.businessResponse);
}

class GettingBusinessesFail extends BusinessState {
  final String error;
  GettingBusinessesFail(this.error);
}

class GettingProducts extends BusinessState {}

class GettingProductsSuccessful extends BusinessState {
  final ProductResponse productResponse;
  GettingProductsSuccessful(this.productResponse);
}

class GettingProductsFail extends BusinessState {
  final String error;
  GettingProductsFail(this.error);
}

class Searching extends BusinessState {}

class SearchingSuccessful extends BusinessState {
  final BusinessResponse results;
  SearchingSuccessful(this.results);
}

class SearchingFail extends BusinessState {
  final String error;
  SearchingFail(this.error);
}

class GetTransactions extends BusinessState {}

class GetTransactionsSuccessful extends BusinessState {
  final TransactionResponse data;
  GetTransactionsSuccessful(this.data);
}

class GetTransactionsFail extends BusinessState {
  final String error;
  GetTransactionsFail(this.error);
}
