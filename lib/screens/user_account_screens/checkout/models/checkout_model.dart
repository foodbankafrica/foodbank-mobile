class CheckoutModel {
  Order? order;
  List<OrderProducts>? orderProducts;
  String? walletBalance;
  String? transactionRef;
  String? paymentUrl;

  CheckoutModel({this.order, this.orderProducts, this.walletBalance});

  CheckoutModel.fromJson(Map<String, dynamic> json) {
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    if (json['order_products'] != null) {
      orderProducts = <OrderProducts>[];
      json['order_products'].forEach((v) {
        orderProducts!.add(OrderProducts.fromJson(v));
      });
    }
    walletBalance = json['wallet_balance'];
    paymentUrl = json['payment_url'];
    transactionRef = json['transaction_ref'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (order != null) {
      data['order'] = order!.toJson();
    }
    if (orderProducts != null) {
      data['order_products'] = orderProducts!.map((v) => v.toJson()).toList();
    }
    data['wallet_balance'] = walletBalance;
    data['transaction_ref'] = transactionRef;
    data['payment_url'] = paymentUrl;
    return data;
  }
}

class Order {
  int? userId;
  dynamic vendorId;
  String? orderCode;
  int? subTotal;
  int? deliveryFee;
  int? total;
  String? type;
  String? updatedAt;
  String? createdAt;
  int? id;

  Order(
      {this.userId,
      this.vendorId,
      this.orderCode,
      this.subTotal,
      this.deliveryFee,
      this.total,
      this.type,
      this.updatedAt,
      this.createdAt,
      this.id});

  Order.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    orderCode = json['order_code'];
    subTotal = json['sub_total'];
    deliveryFee = json['delivery_fee'];
    total = json['total'];
    type = json['type'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['order_code'] = orderCode;
    data['sub_total'] = subTotal;
    data['delivery_fee'] = deliveryFee;
    data['total'] = total;
    data['type'] = type;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

class OrderProducts {
  int? orderId;
  int? productId;
  String? price;
  dynamic quantity;
  int? totalPrice;
  String? updatedAt;
  String? createdAt;
  int? id;

  OrderProducts(
      {this.orderId,
      this.productId,
      this.price,
      this.quantity,
      this.totalPrice,
      this.updatedAt,
      this.createdAt,
      this.id});

  OrderProducts.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    productId = json['product_id'];
    price = json['price'];
    quantity = json['quantity'];
    totalPrice = json['total_price'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['product_id'] = productId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['total_price'] = totalPrice;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}
