import 'package:flutter_dotenv/flutter_dotenv.dart';

class CheckoutEndpoint {
  static String baseURL = '${dotenv.env['API_BASE_URL']}/m/v1';
  static String checkout = '$baseURL/checkout';
  static String checkoutWithCard = '$baseURL/checkout/card';
  static String verifyTransaction(String ref) =>
      '${dotenv.env['API_BASE_URL']}/api/squadco/card-callback/$ref';
  static String donation = '$baseURL/donation';
  static String getDonations(int pageNumber) =>
      '$baseURL/donation?page=$pageNumber';
  static String redeem = '$baseURL/donation/redeem';
  static String searchForDonation(String redeemCode) =>
      '$baseURL/donation/redeem?redeem_code=$redeemCode';
  static String redeemPrivateDonation = '$baseURL/donation/redeem/private';
}
