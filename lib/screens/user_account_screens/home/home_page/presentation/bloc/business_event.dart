part of './business_bloc.dart';

abstract class BusinessEvent {}

class GetBusinessesEvent extends BusinessEvent {
  final String filteredBy;
  final String? addressId;
  GetBusinessesEvent({
    required this.filteredBy,
    this.addressId,
  });
}

class GetGuestBusinessesEvent extends BusinessEvent {
  final String address;
  final String latitude;
  final String longitude;
  GetGuestBusinessesEvent({
    required this.address,
    required this.latitude,
    required this.longitude,
  });
}

class GetTransactionsEvent extends BusinessEvent {
  final int page;
  GetTransactionsEvent(this.page);
}

class GetProductsEvent extends BusinessEvent {
  final String vendorId;
  final String category;
  GetProductsEvent({
    required this.vendorId,
    required this.category,
  });
}

class GetGuestProductsEvent extends BusinessEvent {
  final String vendorId;
  GetGuestProductsEvent({
    required this.vendorId,
  });
}

class SearchEvent extends BusinessEvent {
  final String searchTerms;
  SearchEvent(this.searchTerms);
}
