import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_bank/common/bottom_sheets/fund_food_bank_wallet_sheet.dart';
import 'package:food_bank/config/extensions/custom_extensions.dart';
import 'package:food_bank/screens/user_account_screens/home/user_page/presentation/screens/wallet_page.dart';
import 'package:go_router/go_router.dart';

import '../screens/user_account_screens/auth/cache/user_cache.dart';
import '../screens/user_account_screens/auth/presentation/bloc/auth_bloc.dart';

class FoodBankAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FoodBankAppBar({super.key, this.title, this.end});

  final String? title;
  final Widget? end;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        title: Text(
          '$title',
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(fontWeight: FontWeight.w500),
        ),
        actions: end == null
            ? []
            : [
                Container(margin: const EdgeInsets.only(right: 10), child: end!)
              ]);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class FoodBankBottomSheetAppBar extends StatelessWidget {
  const FoodBankBottomSheetAppBar({
    super.key,
    this.title,
    this.icon,
    this.onClose,
  });

  final String? title;
  final Widget? icon;
  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          icon == null
              ? const SizedBox()
              : const Icon(Icons.arrow_back_ios_rounded),
          Text(
            '$title',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          GestureDetector(
            onTap: onClose ??
                () {
                  context.pop();
                },
            child: Container(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF0F2F5),
              ),
              child: const Icon(
                Icons.close,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OpenElevatedButton extends StatelessWidget {
  const OpenElevatedButton({super.key, this.child, required this.onPressed});

  final Widget? child;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 55,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFCC400C),
          ),
        ),
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.text,
    required this.onTap,
    this.child,
    this.isLoading = false,
    this.color,
  }) : assert(
          text != null || child != null,
          "Cannot have both text and child",
        );

  final String? text;
  final Widget? child;
  final Function()? onTap;
  final bool isLoading;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(backgroundColor: color),
        child: isLoading ? const CustomIndicator() : (child ?? Text(text!)),
      ),
    );
  }
}

class CustomIndicator extends StatelessWidget {
  const CustomIndicator({
    super.key,
    this.color,
  });
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 50,
          height: 50,
          padding: const EdgeInsets.all(12.0),
          child: CircularProgressIndicator(
            color: color ?? Colors.white,
          ),
        ),
      ],
    );
  }
}

class AvailableBalance extends StatefulWidget {
  const AvailableBalance({
    super.key,
    this.showFundWallet = false,
  });
  final bool showFundWallet;

  @override
  State<AvailableBalance> createState() => _AvailableBalanceState();
}

class _AvailableBalanceState extends State<AvailableBalance> {
  final UserCache userCache = UserCache.instance;
  bool isBlurred = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is GettingMeSuccessful) {
          userCache.updateCache(
            user: state.user.user!,
            wallet: state.user.wallet,
            virtualAccounts: state.user.virtualAccounts,
            kyc: state.user.kyc,
          );
        }
      },
      builder: (context, state) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFCC400C),
        ),
        child: Column(
          children: [
            Text(
              'Available Balance',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 12,
                    color: const Color(0xFFF9FAFB),
                  ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: isBlurred
                        ? '********'
                        : '₦${userCache.wallet.balance.toString().formatAmount()}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(color: const Color(0xFFFFFFFF)),
                    children: [
                      TextSpan(
                        text: isBlurred ? '' : '.00',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontSize: 16, color: const Color(0xFFFFFFFF)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                    onTap: () {
                      setState(
                        () {
                          isBlurred = !isBlurred;
                        },
                      );
                    },
                    child: SvgPicture.asset('assets/icons/eye-slash.svg'))
              ],
            ),
            const SizedBox(height: 10),
            !widget.showFundWallet
                ? GestureDetector(
                    onTap: () {
                      context.push(WalletPage.route);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Click to view wallet ',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontSize: 10,
                                    color: const Color(0xFFD0D5DD),
                                  ),
                        ),
                        SvgPicture.asset('assets/icons/info-circle.svg')
                      ],
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: false,
                          useSafeArea: true,
                          builder: (context) {
                            return const FundFoodBankWalletBottomSheet();
                          });
                    },
                    child: Container(
                      height: 35,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: const Color(0xFF000000)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: Colors.white),
                          Text(
                            'Fund Wallet',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                    fontSize: 12,
                                    color: const Color(0xFFFFFFFF)),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class NotFound extends StatelessWidget {
  const NotFound({
    super.key,
    this.message = "No Item Found!!!",
    this.showButton = false,
    this.buttonText = "",
    this.onTap,
  });
  final String message, buttonText;
  final bool showButton;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Image.asset('assets/images/empty_bag.png'),
          const SizedBox(height: 10),
          Text(
            message,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 20),
          ),
          if (showButton) ...{
            const SizedBox(height: 30),
            SizedBox(
              height: 40,
              width: 150,
              child: CustomButton(
                text: buttonText,
                onTap: onTap,
              ),
            ),
            const SizedBox(height: 20),
          },
        ],
      ),
    );
  }
}

class CustomCacheImage extends StatelessWidget {
  const CustomCacheImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.color,
    this.colorBlendMode,
  });

  final String? image;
  final double? width, height;
  final BoxFit fit;
  final Color? color;
  final BlendMode? colorBlendMode;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image ?? '',
      width: width,
      height: height,
      color: color,
      colorBlendMode: colorBlendMode,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? imageChunkEvent) {
        if (imageChunkEvent != null) {
          return SizedBox(
            width: width,
            height: height,
            child: const CustomIndicator(),
          );
        }
        return child;
      },
      errorBuilder: (BuildContext context, Object _, StackTrace? stackTrace) {
        if (stackTrace != null) {
          return SizedBox(
            width: width,
            height: height,
            child: const Icon(Icons.info),
          );
        }
        return const SizedBox.shrink();
      },
      fit: fit,
    );
  }
}

class RetryWidget extends StatelessWidget {
  const RetryWidget({
    super.key,
    required this.error,
    required this.onTap,
  });
  final String error;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            error,
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: onTap,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

class KeyPairValue extends StatelessWidget {
  const KeyPairValue(
    this.title,
    this.amount, {
    super.key,
    this.boldTitle = false,
  });
  final String title, amount;
  final bool boldTitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              boldTitle ? title : "$title:",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF000000),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              amount,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF000000),
                  ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
