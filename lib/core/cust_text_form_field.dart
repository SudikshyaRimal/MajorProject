import 'package:flutter/material.dart';

// Reusable Custom TextFormField Widget
class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool showPasswordToggle;
  final int maxLines;
  final TextCapitalization textCapitalization;
  final bool enabled;
  final String? initialValue;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.showPasswordToggle = false,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
    this.enabled = true,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.focusNode,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = !widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText && !_isPasswordVisible,
        maxLines: widget.maxLines,
        textCapitalization: widget.textCapitalization,
        enabled: widget.enabled,
        initialValue: widget.initialValue,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        focusNode: widget.focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          labelStyle: TextStyle(color: Colors.grey[700]),
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: Colors.grey[600])
              : null,
          suffixIcon: widget.showPasswordToggle
              ? IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,
          filled: true,
          fillColor: widget.enabled ? Colors.white : Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
        ),
      ),
    );
  }
}
