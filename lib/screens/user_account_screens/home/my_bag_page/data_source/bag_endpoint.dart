class BagEndpoint {
  static const baseURL = "https://api-dev.foodbank.africa/m/v1";
  static String orderList(int pageNumber) => '$baseURL/orders?page=$pageNumber';
  static String addBag = '$baseURL/cart';
  static String getBags = '$baseURL/cart';
  static String removeAllBag = '$baseURL/clear-cart';
  static String updateBag(String id) => '$baseURL/cart/$id';
  static String removeBag(int id) => '$baseURL/cart/$id';
  static String order(String id) => '$baseURL/orders/$id';
  static String setFulfilled(String id) => '$baseURL/orders/$id/set-fulfilled';
  static String confirmOrderFulFilled(String id) =>
      '$baseURL/orders/$id/set-fulfilled';
}
