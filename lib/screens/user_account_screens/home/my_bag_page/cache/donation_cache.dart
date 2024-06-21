import 'package:food_bank/screens/user_account_screens/home/my_bag_page/models/donation_model.dart';

List<Donation> _donations = [];

class DonationCache {
  DonationCache._();
  static DonationCache? _instance;

  static get instance => _instance ?? DonationCache._();

  List<Donation> get donations => _donations;

  set donations(List<Donation> donations) {
    _donations = donations;
  }

  bool get isDonationsEmpty => _donations.isEmpty;
}
