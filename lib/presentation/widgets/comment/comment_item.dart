/// Comment item widget for displaying individual comments
library;

import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/comment_model.dart';

/// Widget displaying a single comment bubble
class CommentItem extends StatelessWidget {
  final CommentModel comment;

  const CommentItem({
    required this.comment,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isEmployee = comment.isFromEmployee;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isEmployee ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (!isEmployee) const Spacer(),
          Flexible(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isEmployee
                    ? Colors.grey.shade200
                    : Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(isEmployee ? 4 : 12),
                  bottomRight: Radius.circular(isEmployee ? 12 : 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User name and role
                  Row(
                    children: [
                      Icon(
                        isEmployee ? Icons.person : Icons.engineering,
                        size: 14,
                        color: isEmployee
                            ? Colors.grey.shade700
                            : Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        comment.userName,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isEmployee
                                  ? Colors.grey.shade700
                                  : Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        comment.getFormattedTime(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  // Comment text
                  Text(
                    comment.text,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          if (isEmployee) const Spacer(),
        ],
      ),
    );
  }
}