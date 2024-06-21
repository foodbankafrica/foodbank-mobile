import '../models/user_response.dart';

User? _user;
Wallet? _wallet;
List<VirtualAccount>? _virtualAccounts;
Kyc? _kyc;

class UserCache {
  UserCache._();
  static UserCache? _instance;

  static UserCache get instance => _instance ?? UserCache._();

  User get user => _user ?? User();
  Wallet get wallet => _wallet ?? Wallet();
  Kyc get kyc => _kyc ?? Kyc();
  List<VirtualAccount> get virtualAccounts => _virtualAccounts ?? [];

  set user(User user) {
    _user = user;
  }

  set wallet(Wallet wallet) {
    _wallet = wallet;
  }

  set kyc(Kyc kyc) {
    _kyc = kyc;
  }

  set virtualAccounts(List<VirtualAccount> virtualAccounts) {
    _virtualAccounts = virtualAccounts;
  }

  updateCache({
    required User user,
    Wallet? wallet,
    List<VirtualAccount>? virtualAccounts,
    Kyc? kyc,
  }) {
    _user = user;
    _wallet = wallet ?? Wallet();
    _virtualAccounts = virtualAccounts;
    _kyc = kyc ?? Kyc();
  }

  bool get isAuthenticated => _user != null;
}
