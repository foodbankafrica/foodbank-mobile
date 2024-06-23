class BusinessResponse {
  List<Businesses>? businesses;

  BusinessResponse({this.businesses});

  BusinessResponse.fromJson(Map<String, dynamic> json) {
    if (json['businesses'] != null) {
      businesses = <Businesses>[];
      json['businesses'].forEach((v) {
        businesses!.add(Businesses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (businesses != null) {
      data['businesses'] = businesses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Businesses {
  Business? business;
  OperationalDetails? operationalDetails;
  PaymentDetails? paymentDetails;
  List<ProductCategories>? productCategories;
  List<DeliveryLocation>? deliveryLocations;
  dynamic distance;
  String? lowestAmount;
  Branch? branch;

  Businesses({
    this.business,
    this.operationalDetails,
    this.deliveryLocations,
    this.paymentDetails,
    this.productCategories,
    this.branch,
    this.distance,
    this.lowestAmount,
  });

  Businesses.fromJson(Map<String, dynamic> json) {
    print(json["lowest_amount"]);
    business =
        json['business'] != null ? Business.fromJson(json['business']) : null;
    operationalDetails = json['operational_details'] != null
        ? OperationalDetails.fromJson(json['operational_details'])
        : null;
    paymentDetails = json['payment_details'] != null
        ? PaymentDetails.fromJson(json['payment_details'])
        : null;
    if (json['product_categories'] != null) {
      productCategories = <ProductCategories>[];
      json['product_categories'].forEach((v) {
        productCategories!.add(ProductCategories.fromJson(v));
      });
    }
    if (json['delivery_locations'] != null) {
      deliveryLocations = <DeliveryLocation>[];
      json['delivery_locations'].forEach((v) {
        deliveryLocations!.add(DeliveryLocation.fromJson(v));
      });
    }
    branch =
        json['branch'] != null ? Branch.fromJson(json['branch']) : null;
    distance = json["distance"];
    lowestAmount = json["lowest_amount"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (business != null) {
      data['business'] = business!.toJson();
    }
    if (operationalDetails != null) {
      data['operational_details'] = operationalDetails!.toJson();
    }
    if (paymentDetails != null) {
      data['payment_details'] = paymentDetails!.toJson();
    }
    if (productCategories != null) {
      data['product_categories'] =
          productCategories!.map((v) => v.toJson()).toList();
    }
    if (deliveryLocations != null) {
      data['delivery_locations'] =
          deliveryLocations!.map((v) => v.toJson()).toList();
    }

    if (branch != null) {
      data['branch'] = branch!.toJson();
    }
    data["distance"] = distance;
    data["lowest_amount"] = lowestAmount;
    return data;
  }
}

class Business {
  int? id;
  dynamic userId;
  String? businessName;
  String? address;
  String? cacNumber;
  String? taxIdentificationNumber;
  dynamic cacCertificate;
  String? logo;
  dynamic type;
  String? createdAt;
  String? updatedAt;

  Business(
      {this.id,
      this.userId,
      this.businessName,
      this.address,
      this.cacNumber,
      this.taxIdentificationNumber,
      this.cacCertificate,
      this.logo,
      this.type,
      this.createdAt,
      this.updatedAt});

  Business.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    businessName = json['business_name'];
    address = json['address'];
    cacNumber = json['cac_number'];
    taxIdentificationNumber = json['tax_identification_number'];
    cacCertificate = json['cac_certificate'];
    logo = json['logo'];
    type = json['type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['business_name'] = businessName;
    data['address'] = address;
    data['cac_number'] = cacNumber;
    data['tax_identification_number'] = taxIdentificationNumber;
    data['cac_certificate'] = cacCertificate;
    data['logo'] = logo;
    data['type'] = type;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class OperationalDetails {
  int? id;
  dynamic userId;
  String? days;
  String? openTime;
  String? closeTime;
  dynamic businessMenuTypeId;
  String? deliveryOptions;
  String? createdAt;
  String? updatedAt;

  OperationalDetails(
      {this.id,
      this.userId,
      this.days,
      this.openTime,
      this.closeTime,
      this.businessMenuTypeId,
      this.deliveryOptions,
      this.createdAt,
      this.updatedAt});

  OperationalDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    days = json['days'];
    openTime = json['open_time'];
    closeTime = json['close_time'];
    businessMenuTypeId = json['business_menu_type_id'];
    deliveryOptions = json['delivery_options'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['days'] = days;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['business_menu_type_id'] = businessMenuTypeId;
    data['delivery_options'] = deliveryOptions;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class PaymentDetails {
  int? id;
  dynamic userId;
  dynamic bankId;
  String? accountNumber;
  String? accountName;
  dynamic isActive;
  String? createdAt;
  String? updatedAt;

  PaymentDetails(
      {this.id,
      this.userId,
      this.bankId,
      this.accountNumber,
      this.accountName,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bankId = json['bank_id'];
    accountNumber = json['account_number'];
    accountName = json['account_name'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['bank_id'] = bankId;
    data['account_number'] = accountNumber;
    data['account_name'] = accountName;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class ProductCategories {
  int? id;
  dynamic userId;
  String? name;
  String? status;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  ProductCategories(
      {this.id,
      this.userId,
      this.name,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  ProductCategories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class DeliveryLocation {
  int? id;
  dynamic userId;
  String? name;
  dynamic deliveryCost;
  dynamic latitude;
  dynamic longitude;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  DeliveryLocation(
      {this.id,
      this.userId,
      this.name,
      this.deliveryCost,
      this.latitude,
      this.longitude,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  DeliveryLocation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    deliveryCost = json['delivery_cost'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['delivery_cost'] = deliveryCost;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Branch {
  int? id;
  int? userId;
  int? vendorBusinessDetailId;
  String? name;
  String? address;
  String? latitude;
  String? longitude;
  int? isDefault;
  String? isClosed;
  String? createdAt;
  String? updatedAt;

  Branch(
      {this.id,
      this.userId,
      this.vendorBusinessDetailId,
      this.name,
      this.address,
      this.latitude,
      this.longitude,
      this.isDefault,
      this.isClosed,
      this.createdAt,
      this.updatedAt});

  Branch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    vendorBusinessDetailId = json['vendor_business_detail_id'];
    name = json['name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isDefault = json['is_default'];
    isClosed = json['is_closed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['vendor_business_detail_id'] = vendorBusinessDetailId;
    data['name'] = name;
    data['address'] = address;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['is_default'] = isDefault;
    data['is_closed'] = isClosed;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
