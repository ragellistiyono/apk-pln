/// Loading indicator widgets
library;

import 'package:flutter/material.dart';

/// Circular loading indicator
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double? size;

  const LoadingIndicator({
    this.message,
    this.size,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size ?? 40,
            height: size ?? 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Fullscreen loading overlay
class LoadingOverlay extends StatelessWidget {
  final String? message;

  const LoadingOverlay({
    this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: LoadingIndicator(message: message),
    );
  }
}

/// Small inline loading indicator
class SmallLoadingIndicator extends StatelessWidget {
  const SmallLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}