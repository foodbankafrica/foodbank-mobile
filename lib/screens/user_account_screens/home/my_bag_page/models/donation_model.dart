import 'package:food_bank/config/extensions/custom_extensions.dart';

class DonationsResponse {
  Donations? donations;

  DonationsResponse({this.donations});

  DonationsResponse.fromJson(Map<String, dynamic> json) {
    donations = json['donations'] != null
        ? Donations.fromJson(json['donations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (donations != null) {
      data['donations'] = donations!.toJson();
    }
    return data;
  }
}

class Donations {
  int? currentPage;
  List<Donation>? data;
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

  Donations({
    this.currentPage,
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
    this.total,
  });

  Donations.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null) {
      data = <Donation>[];
      json['data'].forEach((v) {
        data!.add(Donation.fromJson(v));
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

class Donation {
  int? id;
  dynamic userId;
  dynamic vendorId;
  String? donationCode;
  String? subTotal;
  String? type;
  String? deliveryFee;
  String? total;
  String? status;
  dynamic noOfPeople;
  dynamic noRedeemed;
  dynamic isAnonymous;
  dynamic isPrivate;
  String? createdAt;
  String? updatedAt;
  User? user;
  List<DonationProducts>? donationProducts;
  List<RedeemCode>? redeemCodes;

  Donation({
    this.id,
    this.userId,
    this.vendorId,
    this.donationCode,
    this.subTotal,
    this.type,
    this.deliveryFee,
    this.total,
    this.status,
    this.noOfPeople,
    this.noRedeemed,
    this.isAnonymous,
    this.isPrivate,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.donationProducts,
    this.redeemCodes,
  });

  Donation.fromJson(Map<String, dynamic> json) {
    print(json['redeem_codes']);
    id = json['id'];
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    donationCode = json['donation_code'];
    subTotal = json['sub_total'];
    type = json['type'];
    deliveryFee = json['delivery_fee'];
    total = json['total'];
    status = json['status'];
    noOfPeople = json['no_of_people'];
    noRedeemed = json['no_redeemed'];
    isAnonymous = json['is_anonymous'];
    isPrivate = json['is_private'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['donation_products'] != null) {
      donationProducts = <DonationProducts>[];
      json['donation_products'].forEach((v) {
        donationProducts!.add(DonationProducts.fromJson(v));
      });
    }
    if (json['redeem_codes'] != null) {
      redeemCodes = <RedeemCode>[];
      json['redeem_codes'].forEach((v) {
        redeemCodes!.add(RedeemCode.fromJson(v));
      });
    }
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['donation_code'] = donationCode;
    data['sub_total'] = subTotal;
    data['type'] = type;
    data['delivery_fee'] = deliveryFee;
    data['total'] = total;
    data['status'] = status;
    data['no_of_people'] = noOfPeople;
    data['no_redeemed'] = noRedeemed;
    data['is_anonymous'] = isAnonymous;
    data['is_private'] = isPrivate;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (donationProducts != null) {
      data['donation_products'] =
          donationProducts!.map((v) => v.toJson()).toList();
    }
    if (redeemCodes != null) {
      data['redeem_codes'] = redeemCodes!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class DonationProducts {
  int? id;
  dynamic donationId;
  dynamic productId;
  String? price;
  String? quantity;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;
  Product? product;

  DonationProducts(
      {this.id,
      this.donationId,
      this.productId,
      this.price,
      this.quantity,
      this.totalPrice,
      this.createdAt,
      this.updatedAt,
      this.product});

  DonationProducts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    donationId = json['donation_id'];
    productId = json['product_id'];
    price = json['price'];
    quantity = json['quantity'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['donation_id'] = donationId;
    data['product_id'] = productId;
    data['price'] = price;
    data['quantity'] = quantity;
    data['total_price'] = totalPrice;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    return data;
  }
}

class Product {
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
  List<ProductImage>? images;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  Product(
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

  Product.fromJson(Map<String, dynamic> json) {
    'Product ===== $json'.log();
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
      images = <ProductImage>[];
      json['images'].forEach((v) {
        images!.add(ProductImage.fromJson(v));
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
    data['images'] = images;
    data['deleted_at'] = deletedAt;
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

class ProductImage {
  int? id;
  dynamic productId;
  String? path;
  String? createdAt;
  String? updatedAt;

  ProductImage(
      {this.id, this.productId, this.path, this.createdAt, this.updatedAt});

  ProductImage.fromJson(Map<String, dynamic> json) {
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

class RedeemCode {
  dynamic donationId;
  String? redeemCode;
  String? updatedAt;
  String? createdAt;
  dynamic status;
  dynamic isRedeemed;
  int? id;

  RedeemCode(
      {this.donationId,
      this.redeemCode,
      this.updatedAt,
      this.createdAt,
      this.id});

  RedeemCode.fromJson(Map<String, dynamic> json) {
    donationId = json['donation_id'];
    redeemCode = json['redeem_code'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    status = json['status'];
    isRedeemed = json['is_redeemed'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['donation_id'] = donationId;
    data['redeem_code'] = redeemCode;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
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
  dynamic profilePhoto;
  String? referralCode;
  int? profileComplete;
  String? userType;
  dynamic stepCompleted;
  String? fcmToken;
  String? createdAt;
  String? updatedAt;
  String? avatar;

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
      this.profilePhoto,
      this.referralCode,
      this.profileComplete,
      this.userType,
      this.stepCompleted,
      this.fcmToken,
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
    profilePhoto = json['profile_photo'];
    referralCode = json['referral_code'];
    profileComplete = json['profile_complete'];
    userType = json['user_type'];
    stepCompleted = json['step_completed'];
    fcmToken = json['fcm_token'];
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
    data['profile_photo'] = profilePhoto;
    data['referral_code'] = referralCode;
    data['profile_complete'] = profileComplete;
    data['user_type'] = userType;
    data['step_completed'] = stepCompleted;
    data['fcm_token'] = fcmToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['avatar'] = avatar;
    return data;
  }
}
