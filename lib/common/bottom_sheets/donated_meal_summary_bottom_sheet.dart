import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';

import '../../screens/user_account_screens/home/my_bag_page/models/donation_model.dart';

class DonatedMealSummaryBottomSheet extends StatefulWidget {
  const DonatedMealSummaryBottomSheet({
    super.key,
    required this.donation,
  });
  final Donation donation;

  @override
  State<DonatedMealSummaryBottomSheet> createState() =>
      _DonatedMealSummaryBottomSheetState();
}

class _DonatedMealSummaryBottomSheetState
    extends State<DonatedMealSummaryBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const FoodBankBottomSheetAppBar(
          title: "Summary",
        ),
        const Divider(),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Donation Summary',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 10),
              ...widget.donation.donationProducts!.map((product) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: CustomCacheImage(
                              image:
                                  ((product.product ?? Product()).images ?? [])
                                          .isEmpty
                                      ? ''
                                      : (product.product ?? Product())
                                              .images!
                                              .first
                                              .path ??
                                          '',
                              width: 60,
                              height: 60,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text((product.product ?? Product()).name ?? '',
                                  style: Theme.of(context).textTheme.bodyLarge),
                              const SizedBox(height: 5),
                              Text(
                                (product.product ?? Product()).description ??
                                    '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF98A2B3)),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '₦${((product.product ?? Product()).price).toString().formatAmount()}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        'x${product.quantity}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              ...[
                {
                  "title": "No Of People Donated For",
                  "subtitle": widget.donation.noOfPeople.toString(),
                },
                {
                  "title": "No Of Donation Redeem",
                  "subtitle": widget.donation.noRedeemed.toString(),
                },
                {
                  "title": "No Of Donation Left",
                  "subtitle":
                      (num.parse(widget.donation.noOfPeople.toString()) -
                              num.parse(widget.donation.noRedeemed.toString()))
                          .toString(),
                },
                {
                  "title": "Donation Type",
                  "subtitle": widget.donation.type!.toUpperCase(),
                },
                {
                  "title": "Sub-total",
                  "subtitle":
                      '₦${widget.donation.subTotal.toString().formatAmount()}',
                },
                {
                  "title": "Delivery fee",
                  "subtitle":
                      '₦${widget.donation.deliveryFee.toString().formatAmount()}',
                },
                {
                  "title": "Total",
                  "subtitle":
                      '₦${widget.donation.total.toString().formatAmount()}',
                },
                {
                  "title": "Donated At",
                  "subtitle":
                      DateTime.parse(widget.donation.createdAt!).dateOnly()
                },
                {
                  "title": "Donated Reference",
                  "subtitle": widget.donation.donationCode,
                },
              ].map(
                (e) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            e["title"]!,
                            style:
                                Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          Text(
                            e["subtitle"]!,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromARGB(
                                        255, 94, 101, 113)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  );
                },
              ),
              const SizedBox(height: 30),
              Center(
                child: Text('Report Donation',
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class RedeemCodesBottomSheet extends StatefulWidget {
  const RedeemCodesBottomSheet({
    super.key,
    required this.donation,
  });
  final Donation donation;

  @override
  State<RedeemCodesBottomSheet> createState() => _RedeemCodesBottomSheetState();
}

class _RedeemCodesBottomSheetState extends State<RedeemCodesBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const FoodBankBottomSheetAppBar(
            title: "",
          ),
          const Divider(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                ...widget.donation.donationProducts!.map((product) {
                  return Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: CustomCacheImage(
                          image: ((product.product ?? Product()).images ?? [])
                                  .isEmpty
                              ? ''
                              : (product.product ?? Product())
                                      .images!
                                      .first
                                      .path ??
                                  '',
                          width: 60,
                          height: 60,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text((product.product ?? Product()).name ?? '',
                              style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 5),
                          Text(
                            (product.product ?? Product()).description ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF98A2B3)),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '₦${((product.product ?? Product()).price).toString().formatAmount()}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 20),
                Text(
                  'Redeem Codes',
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 10),
                ...widget.donation.redeemCodes!.map((redeemCode) {
                  bool isRedeemed = DateTime.parse(redeemCode.createdAt!)
                          .compareTo(DateTime.parse(redeemCode.createdAt!)) !=
                      0;

                  return Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.black12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(redeemCode.redeemCode ?? '',
                                style: Theme.of(context).textTheme.bodyLarge),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        ),
                        if (isRedeemed) ...{
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.amber,
                            ),
                            child: Text(
                              'Redeemed',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 12,
                                  ),
                            ),
                          ),
                        } else
                          InkWell(
                              onTap: () {
                                FlutterClipboard.copy(redeemCode.redeemCode!)
                                    .then(
                                  (value) => context.buildError(
                                    "${redeemCode.redeemCode!} Copied!",
                                  ),
                                );
                              },
                              child: SvgPicture.asset('assets/icons/copy.svg')),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Total Redeems:',
                        style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(width: 10),
                    Container(
                      height: 24,
                      width: 49,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFAD3307),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '${widget.donation.noRedeemed}',
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium
                              ?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
