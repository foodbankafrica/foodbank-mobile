class OrderResponse {
  Orders? orders;
  int? totalOrdersToday;
  int? totalReoccurringOrders;
  int? totalOrdersOverall;

  OrderResponse(
      {this.orders,
      this.totalOrdersToday,
      this.totalReoccurringOrders,
      this.totalOrdersOverall});

  OrderResponse.fromJson(Map<String, dynamic> json) {
    orders = json['orders'] != null ? Orders.fromJson(json['orders']) : null;
    totalOrdersToday = json['total_orders_today'];
    totalReoccurringOrders = json['total_reoccurring_orders'];
    totalOrdersOverall = json['total_orders_overall'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orders != null) {
      data['orders'] = orders!.toJson();
    }
    data['total_orders_today'] = totalOrdersToday;
    data['total_reoccurring_orders'] = totalReoccurringOrders;
    data['total_orders_overall'] = totalOrdersOverall;
    return data;
  }
}

class Orders {
  int? currentPage;
  List<Order>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Links>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  String? prevPageUrl;
  int? to;
  int? total;

  Orders(
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

  Orders.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Order>[];
      json['data'].forEach((v) {
        data!.add(Order.fromJson(v));
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

class Order {
  int? id;
  dynamic userId;
  dynamic vendorId;
  String? orderCode;
  String? subTotal;
  String? deliveryFee;
  dynamic deliveryAddress;
  String? total;
  String? type;
  String? pin;
  String? status;
  dynamic isGift;
  dynamic isFulfilled;
  dynamic isReoccuring;
  dynamic subTimeline;
  dynamic subPreference;
  dynamic subStartDate;
  dynamic subEndDate;
  dynamic totalNoOfTimes;
  String? createdAt;
  String? updatedAt;
  List<OrderProducts>? orderProducts;
  User? user;

  Order({
    this.id,
    this.userId,
    this.vendorId,
    this.orderCode,
    this.subTotal,
    this.deliveryFee,
    this.deliveryAddress,
    this.total,
    this.type,
    this.isGift,
    this.isFulfilled,
    this.status,
    this.pin,
    this.isReoccuring,
    this.subTimeline,
    this.subPreference,
    this.subStartDate,
    this.subEndDate,
    this.totalNoOfTimes,
    this.createdAt,
    this.updatedAt,
    this.orderProducts,
    this.user,
  });

  Order.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    orderCode = json['order_code'];
    subTotal = json['sub_total'];
    deliveryFee = json['delivery_fee'];
    deliveryAddress = json['delivery_address'];
    total = json['total'];
    type = json['type'];
    isGift = json['is_gift'];
    isFulfilled = json['is_fulfilled'];
    status = json['status'];
    pin = json['pin'];
    isReoccuring = json['is_reoccuring'];
    subTimeline = json['sub_timeline'];
    subPreference = json['sub_preference'];
    subStartDate = json['sub_start_date'];
    subEndDate = json['sub_end_date'];
    totalNoOfTimes = json['total_no_of_times'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['order_products'] != null) {
      orderProducts = <OrderProducts>[];
      json['order_products'].forEach((v) {
        orderProducts!.add(OrderProducts.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['order_code'] = orderCode;
    data['sub_total'] = subTotal;
    data['delivery_fee'] = deliveryFee;
    data['delivery_address'] = deliveryAddress;
    data['total'] = total;
    data['type'] = type;
    data['is_gift'] = isGift;
    data['pin'] = pin;
    data['is_fulfilled'] = isFulfilled;
    data['status'] = status;
    data['is_reoccuring'] = isReoccuring;
    data['sub_timeline'] = subTimeline;
    data['sub_preference'] = subPreference;
    data['sub_start_date'] = subStartDate;
    data['sub_end_date'] = subEndDate;
    data['total_no_of_times'] = totalNoOfTimes;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (orderProducts != null) {
      data['order_products'] = orderProducts!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class OrderProducts {
  int? id;
  dynamic orderId;
  String? price;
  String? quantity;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  Products? products;

  OrderProducts(
      {this.id,
      this.orderId,
      this.price,
      this.quantity,
      this.totalPrice,
      this.createdAt,
      this.updatedAt,
      this.products});

  OrderProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderId = json['order_id'];
    price = json['price'];
    quantity = json['quantity'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    products =
        json['products'] != null ? Products.fromJson(json['products']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['order_id'] = orderId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['total_price'] = totalPrice;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (products != null) {
      data['products'] = products!.toJson();
    }
    return data;
  }
}

class Products {
  int? id;
  dynamic userId;
  String? name;
  String? slug;
  String? price;
  dynamic discountPrice;
  String? description;
  String? status;
  String? type;
  dynamic stockStatus;
  List<Images>? images;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Products(
      {this.id,
      this.userId,
      this.name,
      this.slug,
      this.price,
      this.discountPrice,
      this.description,
      this.status,
      this.type,
      this.stockStatus,
      this.images,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    name = json['name'];
    slug = json['slug'];
    price = json['price'];
    discountPrice = json['discount_price'];
    description = json['description'];
    status = json['status'];
    type = json['type'];
    stockStatus = json['stock_status'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['name'] = name;
    data['slug'] = slug;
    data['price'] = price;
    data['discount_price'] = discountPrice;
    data['description'] = description;
    data['status'] = status;
    data['type'] = type;
    data['stock_status'] = stockStatus;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Images {
  int? id;
  dynamic productId;
  String? path;
  String? createdAt;
  String? updatedAt;

  Images({this.id, this.productId, this.path, this.createdAt, this.updatedAt});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    path = json['path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['path'] = path;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class User {
  int? id;
  dynamic referrerId;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  dynamic emailVerifiedAt;
  String? phoneVerifiedAt;
  dynamic address;
  dynamic dob;
  String? referralCode;
  dynamic profileComplete;
  String? userType;
  dynamic stepCompleted;
  String? createdAt;
  String? updatedAt;
  dynamic avatar;

  User(
      {this.id,
      this.referrerId,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.emailVerifiedAt,
      this.phoneVerifiedAt,
      this.address,
      this.dob,
      this.referralCode,
      this.profileComplete,
      this.userType,
      this.stepCompleted,
      this.createdAt,
      this.updatedAt,
      this.avatar});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    referrerId = json['referrer_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    phoneVerifiedAt = json['phone_verified_at'];
    address = json['address'];
    dob = json['dob'];
    referralCode = json['referral_code'];
    profileComplete = json['profile_complete'];
    userType = json['user_type'];
    stepCompleted = json['step_completed'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['referrer_id'] = referrerId;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['email_verified_at'] = emailVerifiedAt;
    data['phone_verified_at'] = phoneVerifiedAt;
    data['address'] = address;
    data['dob'] = dob;
    data['referral_code'] = referralCode;
    data['profile_complete'] = profileComplete;
    data['user_type'] = userType;
    data['step_completed'] = stepCompleted;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['avatar'] = avatar;
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
