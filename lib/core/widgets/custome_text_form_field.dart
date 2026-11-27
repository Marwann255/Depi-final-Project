import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:pharoh_lense/core/theme/app_colors.dart';
import 'package:pharoh_lense/core/utils/buildcontext_extensions.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final Function(String)? onChange;
  final Function(String)? onSubmitted;
  final String hintText;
  final String? lableText;
  final Icon? suffixIcon;
  final Icon? prefixIcon;
  final bool isPassword;
  final int maxLines;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.keyboardType,
    this.textInputAction,
    this.validator,
    required this.hintText,
    this.lableText,
    this.suffixIcon,
    this.prefixIcon,
    this.isPassword = false,
    this.maxLines = 1,
    this.onChange,
    this.onSubmitted,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isShowPaasowrd = widget.isPassword;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: widget.onSubmitted,
      onChanged: widget.onChange,
      autocorrect: true,
      enableSuggestions: true,
      controller: widget.controller,
      cursorRadius: Radius.circular(16),
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      obscureText: isShowPaasowrd,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      maxLines: widget.maxLines,
      style: Theme.of(context).textTheme.bodyLarge!
          .copyWith(color: context.theme.colorScheme.onPrimaryContainer),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: context.theme.colorScheme.primaryContainer,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: context.theme.colorScheme.onPrimaryContainer,
        ),
        labelText: widget.lableText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: !widget.isPassword
            ? widget.suffixIcon
            : IconButton(
                onPressed: () {
                  setState(() {
                    isShowPaasowrd = !isShowPaasowrd;
                  });
                },
                icon: Icon(
                  isShowPaasowrd
                      ? IconsaxPlusLinear.eye_slash
                      : IconsaxPlusLinear.eye,
                  color: context.theme.colorScheme.secondary,
                ),
              ),
      ),
    );
  }
}
