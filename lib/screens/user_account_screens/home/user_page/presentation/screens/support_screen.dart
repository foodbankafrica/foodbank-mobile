import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tawkto/flutter_tawk.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';

import '../../../../auth/cache/user_cache.dart';

class SupportScreen extends StatelessWidget {
  static String name = 'support';
  static String route = '/support';
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final UserCache userCache = UserCache.instance;
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Help & Support',
      ),
      body: Tawk(
        directChatLink: dotenv.env['TALKTW_URL'] ?? '',
        visitor: TawkVisitor(
          name:
              '${userCache.user.firstName!.capitalize()} ${userCache.user.lastName!.capitalize()}',
          email: userCache.user.email!,
        ),
        onLoad: () {
          print('Hello Tawk!');
        },
        onLinkTap: (String url) {
          print(url);
        },
        placeholder: const Center(
          child: CustomIndicator(
            color: Colors.amber,
          ),
        ),
      ),
    );
  }
}
