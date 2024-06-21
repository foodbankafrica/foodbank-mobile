import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/text_fields.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/screens/donor_account_screens/donor_checkout_screen.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/bloc/business_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/utils/debouncer.dart';
import '../../../../checkout/presentation/screens/checkout_screen.dart';

class SearchScreen extends StatefulWidget {
  static String name = 'search';
  static String route = '/search';
  const SearchScreen({super.key, this.isFromDonor = false});

  final bool isFromDonor;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Debouncer _debouncer;
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    _debouncer = Debouncer(
      const Duration(milliseconds: 500),
    );
    super.initState();
  }

  void onSearchChanged(String? searchTerm) {
    if (searchTerm.toString().isEmpty) return;
    _debouncer.call(() {
      print(searchTerm);
      context.read<BusinessBloc>().add(SearchEvent(searchTerm!));
    });
  }

  @override
  void dispose() {
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BusinessBloc, BusinessState>(
      listener: (context, state) {
        print(state);
      },
      builder: (context, state) => Scaffold(
        appBar: const FoodBankAppBar(title: 'Search'),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FoodBankCustomSearchTextField(
                onChanged: onSearchChanged,
              ),
            ),
            const SizedBox(height: 10),
            const Divider(
              thickness: 0.5,
            ),
            if (state is Searching) ...{
              const SizedBox(height: 20),
              const CustomIndicator(
                color: Color(0xFFEB5017),
              )
            } else if (state is SearchingSuccessful) ...{
              if (state.results.businesses!.isEmpty) ...{
                const SizedBox(height: 20),
                Text(
                  'Nothing to show',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: const Color(0xFF98A2B3),
                      ),
                )
              } else ...{
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: state.results.businesses!.map((business) {
                      return InkWell(
                        onTap: () {
                          context.push(
                            widget.isFromDonor
                                ? DonorCheckoutScreen.route
                                : CheckoutScreen.route,
                            extra: business,
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black12,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                business.business!.businessName!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                              ),
                              Text(
                                business.business!.cacNumber!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              },
            },
          ],
        ),
      ),
    );
  }
}
