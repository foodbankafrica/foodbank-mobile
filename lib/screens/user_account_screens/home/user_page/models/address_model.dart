class AddressResponse {
  List<Address>? addresses;

  AddressResponse({this.addresses});

  AddressResponse.fromJson(Map<String, dynamic> json) {
    print(json);
    if (json['addresses'] != null) {
      addresses = <Address>[];
      json['addresses'].forEach((v) {
        addresses!.add(Address.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Address {
  dynamic id;
  dynamic userId;
  String? address;
  dynamic isDefault;
  dynamic latitude;
  dynamic longitude;
  dynamic isActive;
  String? createdAt;
  String? updatedAt;

  Address(
      {this.id,
      this.userId,
      this.address,
      this.isDefault,
      this.latitude,
      this.longitude,
      this.isActive,
      this.createdAt,
      this.updatedAt});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    address = json['address'];
    isDefault = json['is_default'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['address'] = address;
    data['is_default'] = isDefault;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
