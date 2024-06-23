import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_bank/common/widgets.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPageForCheckout extends StatefulWidget {
  const PaymentPageForCheckout({
    super.key,
    required this.url,
    required this.paymentUrl,
    this.amount = "",
    required this.onDismiss,
  });

  final String url, paymentUrl, amount;
  final void Function(String) onDismiss;

  @override
  State<PaymentPageForCheckout> createState() => _PaymentPageForCardState();
}

class _PaymentPageForCardState extends State<PaymentPageForCheckout> {
  late WebViewController webController;

  @override
  initState() {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color.fromRGBO(0, 0, 0, 0))
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            print(request.url);
            if (request.url.startsWith(widget.paymentUrl)) {
              Future.delayed(
                const Duration(seconds: 5),
                () {
                  widget.onDismiss(request.url);
                  Navigator.of(context).pop();
                },
              );
              return NavigationDecision.navigate;
            }
            if (request.url.isNotEmpty) {
              final uri = Uri.parse(request.url);
              if (uri.host.isNotEmpty) {
                return NavigationDecision.prevent;
              }
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const FoodBankAppBar(
        title: "",
      ),
      body: WebViewWidget(
        controller: webController,
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{}..add(
            Factory<VerticalDragGestureRecognizer>(
              () => VerticalDragGestureRecognizer(),
            ),
          ),
      ),
    );
  }
}
