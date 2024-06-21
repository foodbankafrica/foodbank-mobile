import '../models/buisness_model.dart';

List<Businesses>? _businesses;

class BusinessCache {
  BusinessCache._();
  static BusinessCache? _instance;

  static get instance => _instance ?? BusinessCache._();

  List<Businesses> get businesses => _businesses ?? [];

  set businesses(List<Businesses> businesses) {
    _businesses = businesses;
  }

  bool get isEmpty => (_businesses ?? []).isEmpty;
  List<DeliveryLocation> deliveryLocations(businessId) {
    List<DeliveryLocation> deliveryAddress = [];
    for (var business in (_businesses ?? [])) {
      for (var location
          in business.deliveryLocations as List<DeliveryLocation>) {
        if (location.userId == int.parse(businessId.toString())) {
          deliveryAddress.add(location);
        }
      }
    }
    return deliveryAddress;
  }

  String businessLocations(businessId) {
    for (Businesses business in (_businesses ?? [])) {
      if (business.business!.userId == int.parse(businessId.toString())) {
        return business.branch!.address ?? 'unknown';
      }
    }
    return '';
  }

  (String, String) businessBranchId(businessId) {
    for (Businesses business in (_businesses ?? [])) {
      print(business.business!.userId);
      if (business.branch!.userId! == int.parse(businessId.toString())) {
        return (
          business.branch!.id!.toString(),
          business.business!.id.toString()
        );
      }
    }
    return ('', '');
  }
}
