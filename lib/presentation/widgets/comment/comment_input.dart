/// Comment input widget for adding comments
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/comment/comment_bloc.dart';
import '../../blocs/comment/comment_event.dart';
import '../../blocs/comment/comment_state.dart';

/// Widget for inputting and sending comments
class CommentInput extends StatefulWidget {
  final String ticketId;

  const CommentInput({
    required this.ticketId,
    super.key,
  });

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    if (text.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Komentar minimal 3 karakter')),
      );
      return;
    }

    context.read<CommentBloc>().add(
          CommentAddRequested(
            ticketId: widget.ticketId,
            text: text,
          ),
        );

    _controller.clear();
    _focusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentBloc, CommentState>(
      builder: (context, state) {
        final isAdding = state is CommentAdding;

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(context).viewInsets.bottom + 12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  enabled: !isAdding,
                  decoration: InputDecoration(
                    hintText: 'Tulis komentar...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                  ),
                  maxLines: 4,
                  minLines: 1,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _handleSend(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: isAdding ? null : _handleSend,
                icon: isAdding
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        Icons.send,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                tooltip: 'Kirim',
              ),
            ],
          ),
        );
      },
    );
  }
}