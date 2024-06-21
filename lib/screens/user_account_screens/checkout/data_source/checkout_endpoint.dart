class CheckoutEndpoint {
  static const baseURL = "https://api-dev.foodbank.africa/m/v1";
  static const checkout = '$baseURL/checkout';
  static const checkoutWithCard = '$baseURL/checkout/card';
  static String verifyTransaction(String ref) =>
      'https://api-dev.foodbank.africa/api/squadco/card-callback/${ref}';
  static const donation = '$baseURL/donation';
  static String getDonations(int pageNumber) =>
      '$baseURL/donation?page=$pageNumber';
  static const redeem = '$baseURL/donation/redeem';
  static String searchForDonation(String redeemCode) =>
      '$baseURL/donation/redeem?redeem_code=$redeemCode';
  static const redeemPrivateDonation = '$baseURL/donation/redeem/private';
}
