/// Comment list widget displaying conversation thread
library;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_constants.dart';
import '../../blocs/comment/comment_bloc.dart';
import '../../blocs/comment/comment_event.dart';
import '../../blocs/comment/comment_state.dart';
import '../common/error_message.dart';
import '../common/loading_indicator.dart';
import 'comment_input.dart';
import 'comment_item.dart';

/// Widget displaying list of comments for a ticket
class CommentList extends StatefulWidget {
  final String ticketId;

  const CommentList({
    required this.ticketId,
    super.key,
  });

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  void _loadComments() {
    context.read<CommentBloc>().add(CommentLoadRequested(widget.ticketId));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.comment, size: 20),
              const SizedBox(width: 8),
              Text(
                'Komentar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
                onPressed: _loadComments,
              ),
            ],
          ),
        ),

        // Comment list
        Expanded(
          child: BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is CommentLoading) {
                return const LoadingIndicator(message: 'Memuat komentar...');
              }

              if (state is CommentError) {
                return ErrorMessage(
                  message: state.message,
                  onRetry: _loadComments,
                );
              }

              if (state is CommentLoaded) {
                if (state.comments.isEmpty) {
                  return const EmptyState(
                    message: 'Belum ada komentar.\nMulai percakapan dengan menambahkan komentar.',
                    icon: Icons.comment_outlined,
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.comments.length,
                  itemBuilder: (context, index) {
                    final comment = state.comments[index];
                    return CommentItem(comment: comment);
                  },
                );
              }

              return const Center(child: Text('Tidak ada data'));
            },
          ),
        ),

        // Comment input
        BlocListener<CommentBloc, CommentState>(
          listener: (context, state) {
            if (state is CommentAdded) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(AppConstants.successCommentAdded),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            } else if (state is CommentError &&
                state != const CommentError('Failed to load comments')) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          },
          child: CommentInput(ticketId: widget.ticketId),
        ),
      ],
    );
  }
}