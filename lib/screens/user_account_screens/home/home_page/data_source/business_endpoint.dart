import 'package:flutter_dotenv/flutter_dotenv.dart';

class BusinessEndpoint {
  static String baseURL = '${dotenv.env['API_BASE_URL']}/m/v1';
  static String search(String searchTerm) =>
      "$baseURL/businesses?search=$searchTerm";
  static String transactions(int pageNumber) =>
      "$baseURL/transactions?page=$pageNumber";
  static String businesses({required String filteredBy, String? addressId}) =>
      "$baseURL/businesses?type=$filteredBy&${addressId != null ? 'address_id=$addressId' : ''}";
  static String guestBusinesses =
      "https://api-dev.foodbank.africa/guest/v1/businesses";
  static products(
    String id,
    String category,
    String branchId,
  ) =>
      "$baseURL/businesses/$id/products?category=${category.toLowerCase()}&store_branch_id=$branchId";
  static guestProducts(String id) =>
      "https://api-dev.foodbank.africa/guest/v1/businesses/$id/products/";
}
