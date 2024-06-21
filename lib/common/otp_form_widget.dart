import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    super.key,
    required this.controller,
  });
  final TextEditingController controller;

  @override
  State<OtpForm> createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const fillColor = Color(0xFFF0F2F5);

    final defaultPinTheme = PinTheme(
      width: size.width * .3,
      height: size.width * .2,
      textStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.w400,
          ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: fillColor,
      ),
    );

    return Form(
      key: formKey,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Pinput(
          length: 6,
          controller: widget.controller,
          focusNode: focusNode,
          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
          listenForMultipleSmsOnAndroid: true,
          defaultPinTheme: defaultPinTheme,
          separatorBuilder: (index) => const SizedBox(width: 15),
          onClipboardFound: (value) {
            debugPrint('onClipboardFound: $value');
            widget.controller.setText(value);
          },
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onCompleted: (_) {
            // widget.onCompleted!();
          },
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color(0xFFEB5017),
                width: 1,
              ),
            ),
          ),
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              color: fillColor,
            ),
          ),
          errorPinTheme: defaultPinTheme.copyBorderWith(
            border: Border.all(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}
