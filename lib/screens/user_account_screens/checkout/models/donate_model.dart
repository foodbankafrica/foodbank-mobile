class DonateCheckout {
  Donation? donation;
  List<DonationProducts>? donationProducts;
  List<RedeemCode>? redeemCodes;
  dynamic walletBalance;

  DonateCheckout({
    this.donation,
    this.donationProducts,
    this.walletBalance,
    this.redeemCodes,
  });

  DonateCheckout.fromJson(Map<String, dynamic> json) {
    donation =
        json['donation'] != null ? Donation.fromJson(json['donation']) : null;
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
    walletBalance = json['wallet_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (donation != null) {
      data['donation'] = donation!.toJson();
    }
    if (donationProducts != null) {
      data['donation_products'] =
          donationProducts!.map((v) => v.toJson()).toList();
    }
    data['wallet_balance'] = walletBalance;
    if (redeemCodes != null) {
      data['redeem_codes'] = redeemCodes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Donation {
  dynamic userId;
  dynamic vendorId;
  String? donationCode;
  dynamic total;
  String? type;
  dynamic noOfPeople;
  dynamic noRedeemed;
  bool? isAnonymous;
  dynamic isPrivate;
  dynamic subTotal;
  String? updatedAt;
  String? createdAt;
  int? id;

  Donation(
      {this.userId,
      this.vendorId,
      this.donationCode,
      this.total,
      this.type,
      this.noOfPeople,
      this.noRedeemed,
      this.isAnonymous,
      this.isPrivate,
      this.subTotal,
      this.updatedAt,
      this.createdAt,
      this.id});

  Donation.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    vendorId = json['vendor_id'];
    donationCode = json['donation_code'];
    total = json['total'];
    type = json['type'];
    noOfPeople = json['no_of_people'];
    noRedeemed = json['no_redeemed'];
    isAnonymous = json['is_anonymous'];
    subTotal = json['sub_total'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['vendor_id'] = vendorId;
    data['donation_code'] = donationCode;
    data['total'] = total;
    data['type'] = type;
    data['no_of_people'] = noOfPeople;
    data['no_redeemed'] = noRedeemed;
    data['is_anonymous'] = isAnonymous;
    data['is_private'] = isPrivate;
    data['sub_total'] = subTotal;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

class DonationProducts {
  dynamic donationId;
  dynamic productId;
  dynamic price;
  dynamic quantity;
  dynamic totalPrice;
  String? updatedAt;
  String? createdAt;
  int? id;

  DonationProducts(
      {this.donationId,
      this.productId,
      this.price,
      this.quantity,
      this.totalPrice,
      this.updatedAt,
      this.createdAt,
      this.id});

  DonationProducts.fromJson(Map<String, dynamic> json) {
    donationId = json['donation_id'];
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
    data['donation_id'] = donationId;
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

class RedeemCode {
  int? donationId;
  String? redeemCode;
  String? updatedAt;
  String? createdAt;
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
