import 'package:flutter_dotenv/flutter_dotenv.dart';

class AddressEndpoint {
  static String baseURL = '${dotenv.env['API_BASE_URL']}/m';

  static String addAddress = '$baseURL/v1/addresses';
  static String addresses = '$baseURL/v1/addresses';
  static String markDefault(String id) => '$baseURL/v1/addresses/$id/default';
  static String updateAddress(String id) => '$baseURL/v1/addresses/$id/update';
  static String deleteAddress(String id) => '$baseURL/v1/addresses/$id/delete';
  static String searchAddress(String address) =>
      'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=${dotenv.env['GOOGLE_MAP_API_KEY'] ?? ''}';
}
