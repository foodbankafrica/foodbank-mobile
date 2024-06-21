import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/home_page/presentation/bloc/business_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../auth/cache/user_cache.dart';
import '../../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../home_page/models/transaction_model.dart';
import 'transaction_summary_screen.dart';

class WalletPage extends StatefulWidget {
  static String name = 'wallet';
  static String route = '/wallet';
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final UserCache userCache = UserCache.instance;
  TransactionResponse transactionResponse = TransactionResponse();

  final PagingController<int, Transaction> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener(
      (pageKey) {
        context.read<BusinessBloc>().add(GetTransactionsEvent(pageKey));
      },
    );

    super.initState();
  }

  Future<void> onRefresh() async {
    _pagingController.refresh();
    context.read<AuthBloc>().add(GetMeEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const FoodBankAppBar(
        title: 'Wallet',
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: BlocConsumer<BusinessBloc, BusinessState>(
          listener: (context, state) {
            if (state is GetTransactionsSuccessful) {
              final isLastPage = (state.data.transactions!.data ?? []).length <
                  (state.data.transactions!.perPage ?? 8);
              if (isLastPage) {
                _pagingController
                    .appendLastPage(state.data.transactions!.data!);
              } else {
                final nextPageKey =
                    (state.data.transactions!.currentPage ?? 0) + 1;
                _pagingController.appendPage(
                    state.data.transactions!.data!, nextPageKey);
              }
              setState(() {
                transactionResponse = state.data;
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Divider(thickness: 0.8),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: AvailableBalance(
                        showFundWallet: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        'Transactions',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 18,
                            ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: PagedListView<int, Transaction>(
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate<Transaction>(
                          firstPageProgressIndicatorBuilder: (_) =>
                              const CustomIndicator(
                            color: Color(0xFFEB5017),
                          ),
                          newPageProgressIndicatorBuilder: (_) =>
                              const CustomIndicator(
                            color: Color(0xFFEB5017),
                          ),
                          noItemsFoundIndicatorBuilder: (_) => const NotFound(
                            message: 'No Transaction Found!',
                          ),
                          itemBuilder: (context, transaction, index) {
                            final isDebit = transaction.type == "debit";
                            return InkWell(
                              onTap: () {
                                context.push(
                                  TransactionSummaryScreen.route,
                                  extra: transaction,
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  margin: const EdgeInsets.only(bottom: 10.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.3),
                                        blurRadius: 2,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            transaction.narration ??
                                                'Transaction Successful',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            DateTime.parse(
                                              transaction.createdAt!,
                                            ).dateOnly(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                  fontWeight: FontWeight.w400,
                                                ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '${isDebit ? "-" : "+"}₦${transaction.amount.toString().formatAmount()}',
                                        style: TextStyle(
                                          color: isDebit
                                              ? Colors.red
                                              : Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
