import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';

class RedeemFoodBottomSheet extends StatefulWidget {
  const RedeemFoodBottomSheet({super.key});

  @override
  State<RedeemFoodBottomSheet> createState() => _RedeemFoodBottomSheetState();
}

class _RedeemFoodBottomSheetState extends State<RedeemFoodBottomSheet> {
  List images = [
    'assets/images/image1.png',
    'assets/images/image2.png',
    'assets/images/image3.png',
    'assets/images/image4.png',
    'assets/images/image5.png',
    'assets/images/image6.png',
    'assets/images/image7.png',
    'assets/images/image8.png',
    'assets/images/image9.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const FoodBankBottomSheetAppBar(
          title: '',
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                height: 28,
                width: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFFFFECE5),
                ),
                child: Center(
                    child: Text('Free',
                        style: Theme.of(context).textTheme.bodyMedium)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text('Jollof rice from  ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(fontSize: 20)),
                  Image.asset(
                    'assets/images/food-logo.png',
                    scale: 1.3,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'For 1000 Recipients By |  ',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: const Color(0xFF98A2B3)),
                      children: [
                        TextSpan(
                          text: 'Anonymous',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  for (int i = 0; i < images.length; i++)
                    Align(
                      widthFactor: 0.7,
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: AssetImage(images[i]),
                        ),
                      ),
                    ),
                  const CircleAvatar(
                    radius: 12,
                    child: Text(
                      '+10',
                      style: TextStyle(
                          color: Color(0xFF002E63),
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                onTap: () {},
                text: 'Redeem',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
