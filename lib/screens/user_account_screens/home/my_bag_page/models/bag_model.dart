class Bag {
  int? id;
  dynamic userId;
  String? bagCategoryId;
  String? name;
  String? slug;
  String? price;
  dynamic discountPrice;
  String? description;
  String? status;
  String? type;
  String? address;
  dynamic images;
  int? quantity;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? vendorId;

  Bag({
    this.id,
    this.userId,
    this.bagCategoryId,
    this.name,
    this.slug,
    this.price,
    this.discountPrice,
    this.description,
    this.status,
    this.vendorId,
    this.quantity = 1,
    this.type,
    this.address,
    this.images,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  Bag.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    bagCategoryId = json['bag_category_id'];
    name = json['name'];
    slug = json['slug'];
    price = json['price'];
    discountPrice = json['discount_price'];
    description = json['description'];
    status = json['status'];
    type = json['type'];
    address = json['address'];
    vendorId = json['vendor_id'];
    quantity = json['quantity'];
    images = json['images'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['bag_category_id'] = bagCategoryId;
    data['name'] = name;
    data['slug'] = slug;
    data['price'] = price;
    data['quantity'] = quantity;
    data['discount_price'] = discountPrice;
    data['description'] = description;
    data['status'] = status;
    data['type'] = type;
    data['address'] = address;
    data['vendor_id'] = vendorId;
    data['images'] = images;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }

  set newQuantity(int qty) {
    quantity = qty;
  }
}
