import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/models/address_model.dart';

List<Address>? _addresses;

class AddressCache {
  AddressCache._();
  static AddressCache? _instance;

  static AddressCache get instance => _instance ?? AddressCache._();

  List<Address> get addresses => _addresses ?? [];

  set addresses(List<Address> addresses) {
    _addresses = addresses;
  }

  bool isEmpty() => (_addresses ?? []).isEmpty;

  String get defaultAddress {
    return _addresses == null || _addresses!.isEmpty
        ? ""
        : (_addresses!
                    .firstWhere(
                        (element) =>
                            element.isDefault == '1' || element.isDefault == 1,
                        orElse: () => Address())
                    .address ??
                _addresses!.first.address ??
                '')
            .writeTo(25);
  }

  String get defaultAddressId {
    return _addresses == null || _addresses!.isEmpty
        ? ""
        : (_addresses!
                    .firstWhere(
                        (element) =>
                            element.isDefault == '1' || element.isDefault == 1,
                        orElse: () => Address())
                    .id ??
                _addresses!.first.id ??
                '')
            .toString();
  }
}
