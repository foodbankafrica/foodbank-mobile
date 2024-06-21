class TransactionResponse {
  Transactions? transactions;

  TransactionResponse({this.transactions});

  TransactionResponse.fromJson(Map<String, dynamic> json) {
    transactions = json['transactions'] != null
        ? Transactions.fromJson(json['transactions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (transactions != null) {
      data['transactions'] = transactions!.toJson();
    }
    return data;
  }
}

class Transactions {
  int? currentPage;
  List<Transaction>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  dynamic nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  Transactions(
      {this.currentPage,
      this.data,
      this.firstPageUrl,
      this.from,
      this.lastPage,
      this.lastPageUrl,
      this.links,
      this.nextPageUrl,
      this.path,
      this.perPage,
      this.prevPageUrl,
      this.to,
      this.total});

  Transactions.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Transaction>[];
      json['data'].forEach((v) {
        data!.add(Transaction.fromJson(v));
      });
    }
    firstPageUrl = json['first_page_url'];
    from = json['from'];
    lastPage = json['last_page'];
    lastPageUrl = json['last_page_url'];
    if (json['links'] != null) {
      links = <Links>[];
      json['links'].forEach((v) {
        links!.add(Links.fromJson(v));
      });
    }
    nextPageUrl = json['next_page_url'];
    path = json['path'];
    perPage = json['per_page'];
    prevPageUrl = json['prev_page_url'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current_page'] = currentPage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['first_page_url'] = firstPageUrl;
    data['from'] = from;
    data['last_page'] = lastPage;
    data['last_page_url'] = lastPageUrl;
    if (links != null) {
      data['links'] = links!.map((v) => v.toJson()).toList();
    }
    data['next_page_url'] = nextPageUrl;
    data['path'] = path;
    data['per_page'] = perPage;
    data['prev_page_url'] = prevPageUrl;
    data['to'] = to;
    data['total'] = total;
    return data;
  }
}

class Transaction {
  int? id;
  int? userId;
  int? orderId;
  dynamic donationId;
  String? description;
  dynamic narration;
  String? reference;
  int? amount;
  int? totalAmount;
  int? totalCharge;
  dynamic fromId;
  String? type;
  String? status;
  String? channel;
  String? createdAt;
  String? updatedAt;
  Order? order;
  dynamic donation;

  Transaction(
      {this.id,
      this.userId,
      this.orderId,
      this.donationId,
      this.description,
      this.narration,
      this.reference,
      this.amount,
      this.totalAmount,
      this.totalCharge,
      this.fromId,
      this.type,
      this.status,
      this.channel,
      this.createdAt,
      this.updatedAt,
      this.order,
      this.donation});

  Transaction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    orderId = json['order_id'];
    donationId = json['donation_id'];
    description = json['description'];
    narration = json['narration'];
    reference = json['reference'];
    amount = json['amount'];
    totalAmount = json['total_amount'];
    totalCharge = json['total_charge'];
    fromId = json['from_id'];
    type = json['type'];
    status = json['status'];
    channel = json['channel'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    order = json['order'] != null ? Order.fromJson(json['order']) : null;
    donation = json['donation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['order_id'] = orderId;
    data['donation_id'] = donationId;
    data['description'] = description;
    data['narration'] = narration;
    data['reference'] = reference;
    data['amount'] = amount;
    data['total_amount'] = totalAmount;
    data['total_charge'] = totalCharge;
    data['from_id'] = fromId;
    data['type'] = type;
    data['status'] = status;
    data['channel'] = channel;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (order != null) {
      data['order'] = order!.toJson();
    }
    data['donation'] = donation;
    return data;
  }
}

class Order {
  int? id;
  int? userId;
  int? vendorId;
  dynamic donationId;
  String? orderCode;
  String? subTotal;
  String? deliveryFee;
  String? deliveryAddress;
  dynamic pickupAddress;
  String? total;
  String? type;
  int? isGift;
  String? status;
  int? isReoccuring;
  dynamic subTimeline;
  int? daysCompleted;
  dynamic subDeliveryType;
  dynamic subPreference;
  dynamic subStartDate;
  dynamic subEndDate;
  dynamic totalNoOfTimes;
  String? createdAt;
  String? updatedAt;

  Order(
      {this.id,
      this.userId,
      this.vendorId,
      this.donationId,
      this.orderCode,
      this.subTotal,
      this.deliveryFee,
      this.deliveryAddress,
      this.pickupAddress,
      this.total,
      this.type,
      this.isGift,
      this.status,
      this.isReoccuring,
      this.subTimeline,
      this.daysCompleted,
      this.subDeliveryType,
      this.subPreference,
      this.subStartDate,
      this.subEndDate,
      this.totalNoOfTimes,
      this.createdAt,
      this.updatedAt});

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    donationId = json['donation_id'];
    orderCode = json['order_code'];
    subTotal = json['sub_total'];
    deliveryFee = json['delivery_fee'];
    deliveryAddress = json['delivery_address'];
    pickupAddress = json['pickup_address'];
    total = json['total'];
    type = json['type'];
    isGift = json['is_gift'];
    status = json['status'];
    isReoccuring = json['is_reoccuring'];
    subTimeline = json['sub_timeline'];
    daysCompleted = json['days_completed'];
    subDeliveryType = json['sub_delivery_type'];
    subPreference = json['sub_preference'];
    subStartDate = json['sub_start_date'];
    subEndDate = json['sub_end_date'];
    totalNoOfTimes = json['total_no_of_times'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['donation_id'] = donationId;
    data['order_code'] = orderCode;
    data['sub_total'] = subTotal;
    data['delivery_fee'] = deliveryFee;
    data['delivery_address'] = deliveryAddress;
    data['pickup_address'] = pickupAddress;
    data['total'] = total;
    data['type'] = type;
    data['is_gift'] = isGift;
    data['status'] = status;
    data['is_reoccuring'] = isReoccuring;
    data['sub_timeline'] = subTimeline;
    data['days_completed'] = daysCompleted;
    data['sub_delivery_type'] = subDeliveryType;
    data['sub_preference'] = subPreference;
    data['sub_start_date'] = subStartDate;
    data['sub_end_date'] = subEndDate;
    data['total_no_of_times'] = totalNoOfTimes;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Links {
  String? url;
  String? label;
  bool? active;

  Links({this.url, this.label, this.active});

  Links.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    label = json['label'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['label'] = label;
    data['active'] = active;
    return data;
  }
}
