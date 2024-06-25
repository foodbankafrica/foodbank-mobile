import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/bottom_sheets/donated_meal_summary_bottom_sheet.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../user_account_screens/home/my_bag_page/cache/donation_cache.dart';
import '../../user_account_screens/home/my_bag_page/models/donation_model.dart';

class DonorDonorPage extends StatelessWidget {
  static String name = 'donor-donor-page';
  static String route = '/donor-donor-page';
  const DonorDonorPage({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Donated Meals',
            textAlign: TextAlign.start,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Meals you have donated',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(color: const Color(0xFF98A2B3)),
          ),
          const SizedBox(height: 20),
          const Donations(),
        ],
      ),
    ));
  }
}

class Donations extends StatefulWidget {
  const Donations({
    super.key,
  });

  @override
  State<Donations> createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  final PagingController<int, Donation> _pagingController =
      PagingController(firstPageKey: 1);
  final DonationCache donationCache = DonationCache.instance;

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        context.read<CheckoutBloc>().add(GettingDonationsEvent(pageKey));
      },
    );

    super.initState();
  }

  Future<void> refresh() async {
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is GettingDonationsSuccessful) {
          donationCache.donations = state.res.donations!.data!;

          final isLastPage = (state.res.donations!.data ?? []).length <
              (state.res.donations!.perPage ?? 8);
          if (isLastPage) {
            _pagingController.appendLastPage(state.res.donations!.data!);
          } else {
            final nextPageKey = (state.res.donations!.currentPage ?? 0) + 1;
            _pagingController.appendPage(
                state.res.donations!.data!, nextPageKey);
          }
        } else if (state is GettingDonationsFail) {
          if (state.error.toLowerCase() == "unauthenticated") {
            context.buildError(state.error);
            context.logout();
          } else {
            context.buildError(state.error);
          }
        }
      },
      builder: (context, state) {
        if (state is GettingDonationsFail) {
          return RetryWidget(
            error: state.error,
            onTap: () {
              context.read<CheckoutBloc>().add(GettingDonationsEvent(1));
              _pagingController.refresh();
            },
          );
        }
        return Expanded(
          child: RefreshIndicator(
            onRefresh: refresh,
            color: const Color(0xFFEB5017),
            child: PagedListView<int, Donation>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Donation>(
                firstPageProgressIndicatorBuilder: (_) => const CustomIndicator(
                  color: Color(0xFFEB5017),
                ),
                newPageProgressIndicatorBuilder: (_) => const CustomIndicator(
                  color: Color(0xFFEB5017),
                ),
                noItemsFoundIndicatorBuilder: (_) => const NotFound(
                  message: 'Donations is Empty!',
                ),
                itemBuilder: (context, donation, index) {
                  return DonatedMealsList(
                    donation: donation,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class DonatedMealsList extends StatelessWidget {
  const DonatedMealsList({
    super.key,
    required this.donation,
  });

  final Donation donation;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFFFFFFF),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...donation.donationProducts!.map((product) {
                          return Text(
                            '${(product.product ?? Product()).name ?? ''} ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontSize: 20),
                          );
                        }),
                      ],
                    ),
                    Image.asset(
                      'assets/images/food-logo.png',
                      scale: 1.4,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'For ${donation.noOfPeople} Recipients by |  ',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(color: const Color(0xFF98A2B3)),
                        children: [
                          TextSpan(
                            text: donation.isAnonymous == 1
                                ? 'Anonymous'
                                : donation.user!.firstName!.capitalize(),
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                RecipientsIndicator(donation: donation),
                const SizedBox(height: 15),
                Row(
                  children: [
                    // Expanded(
                    //   child: SizedBox(
                    //     height: 36,
                    //     width: 153,
                    //     child: OpenElevatedButton(
                    //       onPressed: () {
                    //         showModalBottomSheet(
                    //             context: context,
                    //             isScrollControlled: true,
                    //             isDismissible: false,
                    //             useSafeArea: true,
                    //             builder: (context) {
                    //               return RedeemCodesBottomSheet(
                    //                   donation: donation);
                    //             });
                    //       },
                    //       child: Row(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         children: [
                    //           SvgPicture.asset(
                    //             'assets/icons/share.svg',
                    //             width: 20,
                    //             height: 20,
                    //           ),
                    //           Text('  Share',
                    //               style: Theme.of(context).textTheme.bodyMedium)
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(width: 20),
                    Expanded(
                      child: SizedBox(
                        height: 36,
                        width: 153,
                        child: CustomButton(
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                isDismissible: false,
                                useSafeArea: true,
                                builder: (context) {
                                  if (donation.isPrivate == 1) {
                                    return RedeemCodesBottomSheet(
                                        donation: donation);
                                  } else {
                                    return DonatedMealSummaryBottomSheet(
                                        donation: donation);
                                  }
                                });
                          },
                          text: 'View more information',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}

class RecipientsIndicator extends StatefulWidget {
  const RecipientsIndicator({
    super.key,
    required this.donation,
  });

  final Donation donation;

  @override
  State<RecipientsIndicator> createState() => _RecipientsIndicatorState();
}

class _RecipientsIndicatorState extends State<RecipientsIndicator> {
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
    // print(widget.donation.noRedeemed);
    return Row(
      children: [
        // if (widget.donation.noRedeemed != 0)
        for (int i = 0;
            i <
                (num.parse(widget.donation.noRedeemed.toString() ?? '0') <
                        images.length
                    ? num.parse(widget.donation.noRedeemed.toString() ?? '0')
                    : images.length);
            i++)
          Align(
            widthFactor: 0.7,
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 12,
                backgroundImage: AssetImage(
                  images[i],
                ),
              ),
            ),
          ),
        if (num.parse(widget.donation.noRedeemed.toString() ?? '0') >
            images.length)
          CircleAvatar(
            radius: 12,
            backgroundColor: const Color(0xFFFFECE5),
            child: Text(
              '+${widget.donation.noRedeemed! - images.length}',
              style: const TextStyle(
                  color: Color(0xFF002E63),
                  fontSize: 10,
                  fontWeight: FontWeight.w700),
            ),
          ),
      ],
    );
  }
}
