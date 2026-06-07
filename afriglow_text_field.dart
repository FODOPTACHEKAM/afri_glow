// lib/widgets/afriglow_text_field.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

enum FieldState { normal, error, success }

class AfriGlowTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? errorText;
  final FieldState fieldState;
  final FocusNode? focusNode;
  final VoidCallback? onEditingComplete;
  final IconData leadingIcon;

  const AfriGlowTextField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    required this.leadingIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.fieldState = FieldState.normal,
    this.focusNode,
    this.onEditingComplete,
  });

  @override
  State<AfriGlowTextField> createState() => _AfriGlowTextFieldState();
}

class _AfriGlowTextFieldState extends State<AfriGlowTextField> {
  bool _obscured = true;

  Color get _borderColor {
    switch (widget.fieldState) {
      case FieldState.error:
        return AppColors.error;
      case FieldState.success:
        return AppColors.success;
      default:
        return AppColors.sand;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          widget.label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
            color: AppColors.bark,
          ),
        ),
        const SizedBox(height: 7),
        // Input
        Focus(
          child: Builder(
            builder: (ctx) {
              final focused = Focus.of(ctx).hasFocus;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: focused && widget.fieldState == FieldState.normal
                        ? AppColors.terracotta
                        : _borderColor,
                    width: 1.5,
                  ),
                  boxShadow: focused
                      ? [
                          BoxShadow(
                            color: AppColors.terracotta.withOpacity(0.1),
                            blurRadius: 0,
                            spreadRadius: 4,
                          )
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 14),
                      child: Icon(
                        widget.leadingIcon,
                        size: 18,
                        color: focused
                            ? AppColors.terracotta
                            : AppColors.sand,
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: widget.controller,
                        focusNode: widget.focusNode,
                        obscureText: widget.isPassword && _obscured,
                        keyboardType: widget.keyboardType,
                        onEditingComplete: widget.onEditingComplete,
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: AppColors.text,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.placeholder,
                          hintStyle: const TextStyle(color: Color(0xFFC5B09A)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 16),
                        ),
                      ),
                    ),
                    if (widget.isPassword)
                      GestureDetector(
                        onTap: () => setState(() => _obscured = !_obscured),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Icon(
                            _obscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: AppColors.sand,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        // Error text
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          child: widget.errorText != null && widget.errorText!.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 13, color: AppColors.error),
                      const SizedBox(width: 5),
                      Text(
                        widget.errorText!,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.error,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
