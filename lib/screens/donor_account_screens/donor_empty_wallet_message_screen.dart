import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DonorEmptyWalletMessageScreen extends StatelessWidget {
    static String name = 'donor-empty-wallet';
  static String route = '/donor-empty-wallet';
  const DonorEmptyWalletMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/empty_wallet.svg',
          height: 150,
        ),
        const SizedBox(height: 10),
        Text(
          'Your wallet is empty',
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Text(
          'Please fund your wallet to procced',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: const Color(0xFF98A2B3)),
        ),
        const SizedBox(height: 30),
        ElevatedButton(onPressed: () {}, child: const Text('Fund wallet'))
      ],
    );
  }
}
