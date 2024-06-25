import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/bottom_sheets/redeem_food_block_sheet.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../donor_account_screens/home/donor_donor_page.dart';
import '../checkout/presentation/bloc/checkout_bloc.dart';
import 'home_page/presentation/screens/redeem_screen.dart';
import 'my_bag_page/cache/donation_cache.dart';
import 'my_bag_page/models/donation_model.dart';

class DonorPage extends StatefulWidget {
  static String name = 'donor-page';
  static String route = '/donor-page';
  const DonorPage({super.key});

  @override
  State<DonorPage> createState() => _DonorPageState();
}

class _DonorPageState extends State<DonorPage> {
  bool isSelected1 = true;
  bool isSelected2 = false;

  void changeState1() {
    setState(() {
      isSelected1 = true;
    });
    if (isSelected1 == true) {
      isSelected2 = false;
    }
  }

  void changeState2() {
    setState(() {
      isSelected2 = true;
    });
    if (isSelected2 == true) {
      isSelected1 = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Donated Meals',
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Claim Meals If You Are In Need.',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: const Color(0xFF98A2B3)),
                    ),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.push(RedeemScreen.route);
                      },
                      child: SvgPicture.asset(
                        'assets/icons/scan-icon.svg',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(64),
                  color: const Color(0xFFEEF0F4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          changeState1();
                        },
                        child: Container(
                          height: 40,
                          width: 108,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: isSelected1 == true ? Colors.black : null,
                          ),
                          child: Center(
                            child: Text(
                              'Public Donation',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isSelected1 == true
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          changeState2();
                        },
                        child: Container(
                          height: 40,
                          width: 108,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            color: isSelected2 == true ? Colors.black : null,
                          ),
                          child: Center(
                            child: Text(
                              'My Private',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: isSelected2 == true
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            const Donations(),
          ],
        ),
      ),
    );
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
              const SizedBox(height: 10),
              RecipientsIndicator(donation: donation),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      width: 153,
                      child: OpenElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset('assets/icons/share.svg'),
                            Text('  Share',
                                style: Theme.of(context).textTheme.bodyMedium)
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
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
                              return RedeemFoodBlockBottomSheet(
                                  donation: donation);
                            },
                          );
                        },
                        text: 'Redeem',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
