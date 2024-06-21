import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/widgets.dart';

class TwoStepOrderInProgressBottomSheet extends StatefulWidget {
  const TwoStepOrderInProgressBottomSheet({super.key});

  @override
  State<TwoStepOrderInProgressBottomSheet> createState() =>
      _TwoStepOrderInProgressBottomSheetState();
}

class _TwoStepOrderInProgressBottomSheetState
    extends State<TwoStepOrderInProgressBottomSheet> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const FoodBankBottomSheetAppBar(
          title: 'Order In Progress',
        ),
        const Divider(),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SvgPicture.asset('assets/icons/check_indicator.svg'),
                    Container(
                      height: 2,
                      width: size.width * 0.3,
                      color: const Color(0xFFF56630),
                    ),
                    Container(
                      height: 2,
                      width: size.width * 0.3,
                      color: const Color(0xFFF56630),
                    ),
                    SvgPicture.asset('assets/icons/radio_indicator.svg'),
                  ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Order Accepted',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                              )),
                      SizedBox(width: size.width * 0.2),
                      Text(
                        'Order Completed',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 60),
              Text(
                'Your order is accepted',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                'Scan to pickup your order',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(color: const Color(0xFF98A2B3)),
              ),
              const SizedBox(height: 30),
              Container(
                height: 72,
                width: 358,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Color(0xFFFFECE5)),
                      child: SvgPicture.asset(
                        'assets/icons/scan-icon.svg',
                        color: const Color(0xFFF56630),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Text(
                      'Scan to pickup',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
