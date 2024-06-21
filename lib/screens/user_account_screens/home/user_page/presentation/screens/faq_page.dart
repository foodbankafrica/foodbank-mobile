import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';

class FAQPage extends StatefulWidget {
  static String name = 'FAQ';
  static String route = '/FAQ';
  const FAQPage({super.key});

  @override
  State<FAQPage> createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  int current = 0;
  List<Map<String, String>> faqs = [
    {
      "title": "How do I join FoodBank?",
      "subtitle":
          "To join FoodBank, simply visit our website and fill out the registration form. Once registered, you'll have access to our services and resources to support your nutritional needs.",
    },
    {
      "title": "How do I pay for my meals?",
      "subtitle":
          "Paying for meals with FoodBank is easy and convenient. Simply load funds onto your FoodBank account through our website or mobile app, and use them to purchase meals at our partner vendors.",
    },
    {
      "title": "What happens if I miss a meal pickup?",
      "subtitle":
          "If you miss a meal pickup, don't worry! Contact our support team as soon as possible to reschedule your pickup or discuss alternative options.",
    },
    {
      "title":
          "Can I change or cancel my meal plan halfway through the semester?",
      "subtitle":
          "Yes, you can make changes to your meal plan at any time. Simply log in to your FoodBank account and adjust your preferences accordingly. If you have any questions or need assistance, feel free to reach out to our customer support team.",
    },
    {
      "title": "How do I sign up as a donor on FoodBank?",
      "subtitle":
          "Signing up as a donor on FoodBank is simple. Visit our website or download our app, and follow the prompts to create an account. Once registered, you can explore donation options and choose the contribution method that works best for you.",
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'FAQ',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(thickness: 0.8),
            ...faqs.map((faq) {
              int index = faqs.indexOf(faq);
              return SingleFaq(
                text: faq["title"]!,
                content: faq['subtitle']!,
                isOpen: index == current,
                onTap: () {
                  setState(() {
                    current = index == current ? faqs.length + 1 : index;
                  });
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class SingleFaq extends StatelessWidget {
  const SingleFaq({
    super.key,
    required this.text,
    required this.content,
    this.isOpen = false,
    this.onTap,
  });
  final String text, content;
  final bool isOpen;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(width: 50),
                  Icon(isOpen
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded),
                ],
              ),
            ),
          ),
          if (isOpen)
            Text(
              content,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          const Divider(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
