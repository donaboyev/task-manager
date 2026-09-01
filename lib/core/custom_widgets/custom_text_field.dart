import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_clone/core/theme/app_colors.dart';

import 'masked_text_input_formatter.dart';

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final bool? showError;
  final TextEditingController? controller;
  final bool autoFocus;
  final Function(String value)? onChanged;
  final TextInputType? keyboardType;
  final String? prefixText;
  final String? errorText;
  final TextInputAction? inputAction;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final String? hintText;
  final BuildContext? context;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final int? maxLines;
  final bool maskedPhone;
  final bool readOnly;

  const CustomTextField({
    super.key,
    this.labelText,
    this.showError,
    this.controller,
    this.autoFocus = false,
    this.onChanged,
    this.keyboardType,
    this.prefixText,
    this.errorText,
    this.inputAction,
    this.currentFocus,
    this.nextFocus,
    this.hintText,
    this.context,
    this.onTap,
    this.maskedPhone = false,
    this.suffixIcon,
    this.maxLines,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        RichText(
          text: TextSpan(
            text: labelText,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: clrAccent,
            ),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          readOnly: readOnly,
          cursorColor: clrAccent,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: clrAccent,
          ),
          controller: controller,
          focusNode: currentFocus,
          maxLines: maxLines,
          onTap: onTap,
          autofocus: autoFocus,
          textCapitalization: TextCapitalization.sentences,
          onChanged: onChanged,
          inputFormatters: maskedPhone
              ? [
                  MaskedTextInputFormatter(
                    mask: '## ### ## ##',
                    separator: ' ',
                  ),
                  FilteringTextInputFormatter.allow(
                    RegExp('[0-9]'),
                    replacementString: ' ',
                  ),
                ]
              : [],
          onFieldSubmitted: (term) =>
              fieldFocusChange(context, currentFocus, nextFocus),
          textInputAction: inputAction,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
            filled: true,
            hintText: hintText,
            fillColor: clrBreakerHint,
            hintStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: clrGrayBlue,
            ),
            suffixIcon: suffixIcon,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: clrAccent, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: clrWhite, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: clrRed, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: clrRed, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            errorText: showError ?? false ? errorText : null,
            prefix: maskedPhone
                ? const Text(
                    "+998 ",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: clrGrayer,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void fieldFocusChange(
    BuildContext context,
    FocusNode? currentFocus,
    FocusNode? nextFocus,
  ) {
    if (currentFocus != null && nextFocus != null) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }
}
