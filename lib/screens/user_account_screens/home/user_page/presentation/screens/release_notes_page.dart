import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/release_notes_content_page.dart';
import 'package:go_router/go_router.dart';

class ReleaseNotesPage extends StatelessWidget {
  static String name = 'release-notes';
  static String route = '/release-notes';
  const ReleaseNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Release Notes',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What\'s New',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Text(
                  'New updates and improvements on foodbank.',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    context.push(ReleaseNotesContentPage.route);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFECE5)),
                            child: SvgPicture.asset(
                              'assets/icons/brown_wallet.svg',
                            ),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Introducing the Wallet',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 5),
                              Text(
                                'Manage your wallet and fund your wallet.',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF98A2B3)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '8/2/19',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF98A2B3)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
