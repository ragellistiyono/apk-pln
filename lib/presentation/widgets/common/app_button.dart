/// Reusable button widgets
library;

import 'package:flutter/material.dart';

/// Primary elevated button
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const AppButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : icon != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                    Text(text),
                  ],
                )
              : Text(text),
    );
  }
}

/// Secondary outlined button
class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AppOutlinedButton({
    required this.text,
    this.onPressed,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(text),
              ],
            )
          : Text(text),
    );
  }
}

/// Text button
class AppTextButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;

  const AppTextButton({
    required this.text,
    this.onPressed,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: icon != null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 20),
                const SizedBox(width: 8),
                Text(text),
              ],
            )
          : Text(text),
    );
  }
}