import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/wallet_page.dart';
import 'package:go_router/go_router.dart';

class EmptyWalletMessageScreen extends StatelessWidget {
  static String route = "/empty-wallet";
  static String name = "empty-wallet";
  const EmptyWalletMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: "",
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/icons/empty_wallet.svg',
                height: 150,
              ),
              const SizedBox(height: 10),
              Text(
                'Insufficient Wallet Balance',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Please fund your wallet to proceed',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: const Color(0xFF98A2B3)),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  context.push(WalletPage.route);
                },
                child: const Text('Fund wallet'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
