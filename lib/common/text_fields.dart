// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

class FoodBankTextField extends StatelessWidget {
  const FoodBankTextField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.suffix,
    this.readOnly = false,
    this.obstruct = false,
    this.onTap,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLength,
    this.onChanged,
  });
  final String? hintText, labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? suffix;
  final bool readOnly, obstruct;
  final Function()? onTap;
  final String? Function(String?)? validator;
  final Function(String)? onChanged;
  final int? maxLength;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...{
          Text(
            labelText ?? '',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 5),
        },
        SizedBox(
          // height: 56,
          width: double.infinity,
          child: TextFormField(
            validator: validator,
            obscureText: obstruct,
            readOnly: readOnly,
            controller: controller,
            keyboardType: keyboardType,
            onTap: onTap,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              suffixIcon: suffix,
              hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF98A2B3),
                  ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFEB5017)),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Color(0xFFEB5017)),
              ),
              counterText: "",
              errorStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFEB5017),
                  ),
            ),
            maxLength: maxLength,
          ),
        ),
      ],
    );
  }
}

class FoodBankSearchTextField extends StatelessWidget {
  const FoodBankSearchTextField({
    super.key,
    this.controller,
    this.onChanged,
  });
  final TextEditingController? controller;
  final Function(String?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: TextFormField(
        onChanged: onChanged,
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: SizedBox(
                  child: SvgPicture.asset('assets/icons/search.svg'),
                ),
              ),
            ],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFD0D5DD)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: const BorderSide(color: Color(0xFFEB5017)),
          ),
        ),
      ),
    );
  }
}

class FoodBankCustomSearchTextField extends StatelessWidget {
  const FoodBankCustomSearchTextField({
    super.key,
    this.onChanged,
  });
  final Function(String?)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          fillColor: const Color(0xFFF6F6F6),
          filled: true,
          hintText: "Enter Business Name",
          prefixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: SvgPicture.asset(
                  'assets/icons/search.svg',
                  color: const Color(0xFF98A2B3),
                ),
              ),
            ],
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFFFFFF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFEB5017)),
          ),
        ),
      ),
    );
  }
}

class CustomPasswordInput extends StatefulWidget {
  const CustomPasswordInput({
    super.key,
    required this.controller,
    required this.labelText,
    required this.hintText,
    this.validator,
  });
  final TextEditingController controller;
  final String labelText, hintText;
  final String? Function(String?)? validator;

  @override
  State<CustomPasswordInput> createState() => _CustomPasswordInputState();
}

class _CustomPasswordInputState extends State<CustomPasswordInput> {
  bool isPassword = true;
  @override
  Widget build(BuildContext context) {
    return FoodBankTextField(
      labelText: widget.labelText,
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      hintText: widget.hintText,
      validator: widget.validator,
      suffix: InkWell(
        onTap: () {
          setState(() {
            isPassword = !isPassword;
          });
        },
        child: Icon(
          isPassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: const Color(0xFF98A2B3),
        ),
      ),
      obstruct: isPassword,
      // maxLines: 1,
      // validator: widget.validator,
    );
  }
}
