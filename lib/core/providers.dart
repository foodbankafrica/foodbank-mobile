import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/screens/user_account_screens/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/bloc/business_bloc.dart';
import 'package:food_bank/screens/user_account_screens/home/my_bag_page/presentation/bloc/bag_bloc.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/bloc/address_bloc/address_bloc.dart';

import '../screens/user_account_screens/auth/presentation/bloc/auth_bloc.dart';
import '../screens/user_account_screens/home/user_page/presentation/bloc/kyc_bloc/kyc_bloc.dart';
import 'injections.dart';

class Providers {
  Providers._();

  static getBlocs() {
    return [
      BlocProvider<AuthBloc>(
        create: (context) => sl<AuthBloc>(),
      ),
      BlocProvider<AddressBloc>(
        create: (context) => sl<AddressBloc>(),
      ),
      BlocProvider<KycBloc>(
        create: (context) => sl<KycBloc>(),
      ),
      BlocProvider<BusinessBloc>(
        create: (context) => sl<BusinessBloc>(),
      ),
      BlocProvider<BagBloc>(
        create: (context) => sl<BagBloc>(),
      ),
      BlocProvider<CheckoutBloc>(
        create: (context) => sl<CheckoutBloc>(),
      ),
    ];
  }
}
