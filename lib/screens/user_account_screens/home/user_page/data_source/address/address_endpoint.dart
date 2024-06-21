class AddressEndpoint {
  static const String baseURL = "https://api-dev.foodbank.africa/m";

  static const String addAddress = '$baseURL/v1/addresses';
  static const String addresses = '$baseURL/v1/addresses';
  static String markDefault(String id) => '$baseURL/v1/addresses/$id/default';
  static String updateAddress(String id) => '$baseURL/v1/addresses/$id/update';
  static String deleteAddress(String id) => '$baseURL/v1/addresses/$id/delete';
  static String searchAddress(String address) =>
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyAyYEFe4MMHwD-zNVVpfWKIRcFiE-e2TN8';
}
