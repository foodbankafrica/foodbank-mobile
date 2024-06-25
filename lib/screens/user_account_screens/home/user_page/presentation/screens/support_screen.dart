// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'live_support_screen.dart';

class SupportScreen extends StatelessWidget {
  static String name = 'support';
  static String route = '/support';
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: '',
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Help & Support",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 30),
            SupportButton(
              icon: Icons.chat_bubble,
              onTap: () {
                context.push(LiveSupportScreen.route);
              },
              subtitle: "Chat live with our support.",
              title: "Live Chat",
            ),
            SupportButton(
              icon: Icons.email,
              onTap: () async {
                if (!await launchUrl(
                  Uri.parse("mailto:hello@foodbank.africa"),
                  mode: LaunchMode.externalApplication,
                )) {
                  context.buildError("Fail to launch email app");
                }
              },
              subtitle: "support@foodbank.africa",
              title: "Email",
            ),
            SupportButton(
              icon: Icons.wechat_sharp,
              onTap: () async {
                if (!await launchUrl(
                  Uri.parse("https://wa.me/+2348146367757"),
                  mode: LaunchMode.externalApplication,
                )) {
                  context.buildError("Fail to launch whatsapp");
                }
              },
              subtitle: "+2348146367757",
              title: "Whatsapp",
            ),
          ],
        ),
      ),
    );
  }
}

class SupportButton extends StatelessWidget {
  const SupportButton({
    super.key,
    required this.title,
    required this.onTap,
    required this.subtitle,
    required this.icon,
  });
  final String title, subtitle;
  final IconData icon;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black26,
              width: 0.6,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFFEB5017),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 16,
                      ),
                ),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        fontSize: 16,
                        color: const Color(0xFFEB5017),
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
