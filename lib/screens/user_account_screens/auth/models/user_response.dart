import 'package:food_bank/config/extensions/custom_extensions.dart';

class UserResponse {
  User? user;
  List<VirtualAccount>? virtualAccounts;
  Access? access;
  String? token;
  String? scope;
  Wallet? wallet;
  Kyc? kyc;

  UserResponse({
    this.user,
    this.access,
    this.wallet,
    this.virtualAccounts,
    this.kyc,
  });

  UserResponse.fromJson(Map<String, dynamic> json) {
    '$json'.log();
    user = json['user'] != null ? User.fromJson(json['user']) : null;
    access = json['access'] != null ? Access.fromJson(json['access']) : null;
    token = json['token'] ?? "";
    scope = json['scope'] ?? "";

    wallet = json['wallet'] != null && json['wallet'].runtimeType != String
        ? Wallet.fromJson(json['wallet'])
        : null;

    if (json['virtual_accounts'] != null) {
      virtualAccounts = <VirtualAccount>[];
      json['virtual_accounts'].forEach((v) {
        virtualAccounts!.add(VirtualAccount.fromJson(v));
      });
    }
    kyc = json['kyc'] != null ? Kyc.fromJson(json['kyc']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (access != null) {
      data['access'] = access!.toJson();
    }
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (virtualAccounts != null) {
      data['virtual_accounts'] =
          virtualAccounts!.map((v) => v.toJson()).toList();
    }
    if (kyc != null) {
      data['kyc'] = kyc!.toJson();
    }
    return data;
  }
}

class User {
  String? firstName;
  String? avatar;
  String? lastName;
  String? email;
  String? phone;
  String? dob;
  String? userType;
  String? referralCode;
  String? updatedAt;
  String? createdAt;
  int? id;

  User(
      {this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.dob,
      this.referralCode,
      this.updatedAt,
      this.createdAt,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    avatar = json['avatar'];
    email = json['email'];
    phone = json['phone'];
    dob = json['dob'];
    userType = json['user_type'];
    referralCode = json['referral_code'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['email'] = email;
    data['avatar'] = avatar;
    data['phone'] = phone;
    data['dob'] = dob;
    data['referral_code'] = referralCode;
    data['updated_at'] = updatedAt;
    data['created_at'] = createdAt;
    data['id'] = id;
    return data;
  }
}

class Access {
  String? token;
  String? scope;

  Access({this.token, this.scope});

  Access.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    scope = json['scope'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['scope'] = scope;
    return data;
  }
}

class Wallet {
  String? balance;
  int? decimalPlaces;
  String? uuid;
  dynamic holderId;
  String? holderType;
  String? name;
  String? slug;
  List<dynamic>? meta;

  Wallet(
      {this.balance,
      this.decimalPlaces,
      this.uuid,
      this.holderId,
      this.holderType,
      this.name,
      this.slug,
      this.meta});

  Wallet.fromJson(Map<String, dynamic> json) {
    balance = json['balance'];
    decimalPlaces = json['decimal_places'];
    uuid = json['uuid'];
    holderId = json['holder_id'];
    holderType = json['holder_type'];
    name = json['name'];
    slug = json['slug'];
    if (json['meta'] != null) {
      meta = <dynamic>[];
      json['meta'].forEach((v) {
        meta!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['balance'] = balance;
    data['decimal_places'] = decimalPlaces;
    data['uuid'] = uuid;
    data['holder_id'] = holderId;
    data['holder_type'] = holderType;
    data['name'] = name;
    data['slug'] = slug;
    if (meta != null) {
      data['meta'] = meta!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VirtualAccount {
  int? id;
  dynamic userId;
  dynamic walletId;
  dynamic virtualAccountProviderId;
  String? accountName;
  String? accountNumber;
  String? bankName;
  String? accountReference;
  String? currency;
  dynamic status;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  VirtualAccount(
      {this.id,
      this.userId,
      this.walletId,
      this.virtualAccountProviderId,
      this.accountName,
      this.accountNumber,
      this.bankName,
      this.accountReference,
      this.currency,
      this.status,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  VirtualAccount.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    walletId = json['wallet_id'];
    virtualAccountProviderId = json['virtual_account_provider_id'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    bankName = json['bank_name'];
    accountReference = json['account_reference'];
    currency = json['currency'];
    status = json['status'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['wallet_id'] = walletId;
    data['virtual_account_provider_id'] = virtualAccountProviderId;
    data['account_name'] = accountName;
    data['account_number'] = accountNumber;
    data['bank_name'] = bankName;
    data['account_reference'] = accountReference;
    data['currency'] = currency;
    data['status'] = status;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Kyc {
  int? id;
  dynamic userId;
  dynamic kycVerificationLogId;
  String? bvn;
  String? phone;
  String? dob;
  String? address;
  String? gender;
  dynamic phoneVerified;
  dynamic emailVerified;
  dynamic bvnVerified;
  dynamic verified;
  String? createdAt;
  String? updatedAt;

  Kyc({
    this.id,
    this.userId,
    this.kycVerificationLogId,
    this.bvn,
    this.phone,
    this.dob,
    this.address,
    this.gender,
    this.verified,
    this.createdAt,
    this.updatedAt,
  });

  Kyc.fromJson(Map<String, dynamic> json) {
    'kyc ========= $json'.log();
    id = json['id'];
    userId = json['user_id'];
    kycVerificationLogId = json['kyc_verification_log_id'];
    bvn = json['bvn'];
    phone = json['phone'];
    dob = json['dob'];
    address = json['address'];
    gender = json['gender'];
    phoneVerified = json['phone_verified'];
    emailVerified = json['email_verified'];
    bvnVerified = json['bvn_verified'];
    verified = json['verified'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['kyc_verification_log_id'] = kycVerificationLogId;
    data['bvn'] = bvn;
    data['phone'] = phone;
    data['dob'] = dob;
    data['address'] = address;
    data['gender'] = gender;
    data['phone_verified'] = phoneVerified;
    data['email_verified'] = emailVerified;
    data['bvn_verified'] = bvnVerified;
    data['verified'] = verified;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
