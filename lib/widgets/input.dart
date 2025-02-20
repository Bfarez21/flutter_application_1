import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/Theme.dart';

class Input extends StatelessWidget {
  final String placeholder;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool autofocus;
  final Color borderColor;
  final bool filled;
  final Color fillColor;
  final Color textColor;
  final Color enabledBorderColor;
  final Color focusedBorderColor;
  final bool outlineBorder;
  final Color cursorColor;
  final bool obscuredText;
  final Color hintTextColor;

  Input({
    this.placeholder = "", // Valor predeterminado para placeholder
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.filled = false, // Valor predeterminado para filled
    this.fillColor = Colors.white, // Valor predeterminado para fillColor
    this.textColor = Colors.black,
    this.enabledBorderColor = MaterialColors.muted,
    this.focusedBorderColor = MaterialColors.primary,
    this.cursorColor = MaterialColors.muted,
    this.hintTextColor = MaterialColors.muted,
    this.onChanged,
    this.outlineBorder = false,
    this.obscuredText = false,
    this.autofocus = false,
    this.borderColor = MaterialColors.border,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorColor: cursorColor,
      onTap: onTap,
      onChanged: onChanged,
      controller: controller,
      autofocus: autofocus,
      obscureText: obscuredText,
      style: TextStyle(
        height: 0.85,
        fontSize: 14.0,
        color: textColor,
      ),
      textAlignVertical: TextAlignVertical(y: 0.5),
      decoration: InputDecoration(
        contentPadding:
            EdgeInsets.only(left: 16, bottom: outlineBorder ? 20 : 16),
        filled: filled,
        fillColor: fillColor,
        hintStyle: TextStyle(
          color: hintTextColor,
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        enabledBorder: outlineBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(color: enabledBorderColor))
            : UnderlineInputBorder(
                borderSide: BorderSide(color: enabledBorderColor)),
        focusedBorder: outlineBorder
            ? OutlineInputBorder(
                borderSide: BorderSide(color: focusedBorderColor))
            : UnderlineInputBorder(
                borderSide: BorderSide(color: focusedBorderColor)),
        hintText: placeholder,
      ),
    );
  }
}
