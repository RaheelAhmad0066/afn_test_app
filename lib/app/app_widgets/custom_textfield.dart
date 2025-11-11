import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:afn_test/app/app_widgets/app_text_styles.dart';

class CustomTextfield extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final Widget? prefixIcon; // Prefix icon widget
  final Widget? suffixIcon; // Suffix icon widget

  const CustomTextfield({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.maxLines = 1,
    this.onChanged,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
      validator: validator,
      
      style: AppTextStyles.bodyLarge.copyWith(
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        labelText: labelText,
      
        filled: true,
        fillColor: const Color(0xffEEF9C0), // Fill color yellow
        contentPadding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 16.h,
        ),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: EdgeInsets.all(12.w),
                child: prefixIcon,
              )
            : null,
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: EdgeInsets.all(12.w),
                child: suffixIcon,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r), // Full radius (completely rounded)
          borderSide: const BorderSide(
            color: Colors.white, // Border color white
            width: 2.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r), // Full radius
          borderSide: const BorderSide(
            color: Colors.white, // Border color white
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r), // Full radius
          borderSide: const BorderSide(
            color: Colors.white, // Border color white
            width: 2.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r), // Full radius
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50.r), // Full radius
          borderSide: const BorderSide(
            color: Colors.red,
            width: 2.5,
          ),
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.black54,
        ),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: Colors.black87,
        ),
      ),
    );
  }
}