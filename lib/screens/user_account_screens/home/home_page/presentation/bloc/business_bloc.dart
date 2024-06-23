import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/app/business_facade.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/models/buisness_model.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/models/product_model.dart';

import '../../models/transaction_model.dart';

part './business_event.dart';
part './business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final BusinessFacade _businessFacade;

  BusinessBloc({required BusinessFacade businessFacade})
      : _businessFacade = businessFacade,
        super(BusinessesInitial()) {
    on<GetBusinessesEvent>(_getBusinesses);
    on<GetGuestBusinessesEvent>(_getGuestBusinesses);
    on<GetProductsEvent>(_getProducts);
    on<GetGuestProductsEvent>(_getGuestProducts);
    on<SearchEvent>(_search);
    on<GetTransactionsEvent>(_getTransactions);
  }

  void _getBusinesses(GetBusinessesEvent event, emit) async {
    emit(GettingBusinesses());
    final failureOrSuccess = await _businessFacade.getBusinesses(
      filteredBy: event.filteredBy,
      addressId: event.addressId,
    );
    failureOrSuccess.fold(
      (error) => emit(
        GettingBusinessesFail(error.message),
      ),
      (businessRes) => emit(
        GettingBusinessesSuccessful(businessRes),
      ),
    );
  }

  void _getGuestBusinesses(GetGuestBusinessesEvent event, emit) async {
    emit(GettingBusinesses());
    final failureOrSuccess = await _businessFacade.getGuestBusinesses(
      address: event.address,
      latitude: event.latitude,
      longitude: event.longitude,
    );
    failureOrSuccess.fold(
      (error) => emit(
        GettingBusinessesFail(error.message),
      ),
      (businessRes) => emit(
        GettingBusinessesSuccessful(businessRes),
      ),
    );
  }

  void _getProducts(GetProductsEvent event, emit) async {
    emit(GettingProducts());
    final failureOrSuccess = await _businessFacade.getProducts(
      vendorId: event.vendorId,
      category: event.category,
      branchId: event.branchId,
    );
    failureOrSuccess.fold(
      (error) => emit(
        GettingProductsFail(error.message),
      ),
      (products) => emit(
        GettingProductsSuccessful(products),
      ),
    );
  }

  void _getGuestProducts(GetGuestProductsEvent event, emit) async {
    emit(GettingProducts());
    final failureOrSuccess = await _businessFacade.guestProducts(
      vendorId: event.vendorId,
    );
    failureOrSuccess.fold(
      (error) => emit(
        GettingProductsFail(error.message),
      ),
      (products) => emit(
        GettingProductsSuccessful(products),
      ),
    );
  }

  void _search(SearchEvent event, emit) async {
    emit(Searching());
    final failureOrSuccess = await _businessFacade.search(event.searchTerms);
    failureOrSuccess.fold(
      (error) => emit(
        SearchingFail(error.message),
      ),
      (result) => emit(
        SearchingSuccessful(result),
      ),
    );
  }

  void _getTransactions(GetTransactionsEvent event, emit) async {
    emit(GetTransactions());
    final failureOrSuccess = await _businessFacade.getTransactions(event.page);
    failureOrSuccess.fold(
      (error) => emit(GetTransactionsFail(error.message)),
      (result) => emit(GetTransactionsSuccessful(result)),
    );
  }
}
