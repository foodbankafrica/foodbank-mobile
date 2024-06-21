import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/models/address_model.dart';

import '../../../app/address_facade.dart';
import '../../../models/search_address.dart';

part './address_event.dart';
part './address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressFacade _addressFacade;
  AddressBloc({
    required AddressFacade addressFacade,
  })  : _addressFacade = addressFacade,
        super(AddressInitial()) {
    on<AddAddressEvent>(_addAddress);
    on<UpdateAddressEvent>(_updateAddress);
    on<GetAddressEvent>(_getAddresses);
    on<DeleteAddressEvent>(_deleteAddress);
    on<SearchAddressEvent>(_searchAddress);
    on<MarkAddressDefaultEvent>(_markDefault);
  }
  void _addAddress(AddAddressEvent event, Emitter<AddressState> emit) async {
    emit(AddingAddress());
    final failureOrSuccess = await _addressFacade.addAddress(
      address: event.address,
      latitude: event.latitude,
      longitude: event.longitude,
    );
    failureOrSuccess.fold(
      (error) => emit(AddingAddressFail(error.message)),
      (message) => emit(AddingAddressSuccessful(message)),
    );
  }

  void _updateAddress(
      UpdateAddressEvent event, Emitter<AddressState> emit) async {
    emit(UpdatingAddress());
    final failureOrSuccess = await _addressFacade.updateAddress(
      addressId: event.addressId,
      address: event.address,
    );
    failureOrSuccess.fold(
      (error) => emit(UpdatingAddressFail(error.message)),
      (message) => emit(UpdatingAddressSuccessful(message)),
    );
  }

  void _deleteAddress(
      DeleteAddressEvent event, Emitter<AddressState> emit) async {
    emit(DeletingAddress());
    final failureOrSuccess = await _addressFacade.deleteAddress(
      addressId: event.addressId,
    );
    failureOrSuccess.fold(
      (error) => emit(DeletingAddressFail(error.message)),
      (message) => emit(DeletingAddressSuccessful(message)),
    );
  }

  void _markDefault(
      MarkAddressDefaultEvent event, Emitter<AddressState> emit) async {
    emit(MarkingDefaultAddress());
    final failureOrSuccess = await _addressFacade.markAddressDefault(
      addressId: event.addressId,
    );
    failureOrSuccess.fold(
      (error) => emit(MarkingDefaultAddressFail(error.message)),
      (message) => emit(MarkingDefaultAddressSuccessful(message)),
    );
  }

  void _searchAddress(
      SearchAddressEvent event, Emitter<AddressState> emit) async {
    emit(SearchingAddress());
    final failureOrSuccess =
        await _addressFacade.searchAddress(searchAddress: event.address);
    failureOrSuccess.fold(
      (error) => emit(SearchingAddressFail(error.message)),
      (message) => emit(SearchingAddressSuccessful(message)),
    );
  }

  void _getAddresses(GetAddressEvent event, Emitter<AddressState> emit) async {
    emit(GettingAddresses());
    final failureOrSuccess = await _addressFacade.getAddresses();
    failureOrSuccess.fold(
      (error) => emit(GettingAddressesFail(error.message)),
      (addresses) => emit(GettingAddressesSuccessful(addresses)),
    );
  }
}
