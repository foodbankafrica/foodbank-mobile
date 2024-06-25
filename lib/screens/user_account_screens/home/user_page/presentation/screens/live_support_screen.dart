import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_tawkto/flutter_tawk.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';

import '../../../../auth/cache/user_cache.dart';

class LiveSupportScreen extends StatelessWidget {
  static String name = 'live-support';
  static String route = '/live-support';
  const LiveSupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final UserCache userCache = UserCache.instance;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            context.pop();
          },
          child: const Icon(Icons.close),
        ),
        title: const Text('Live Support'),
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
