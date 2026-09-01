import 'package:flutter/material.dart';
import 'package:todo_clone/core/theme/app_text_styles.dart';

class AttentionDialog extends StatelessWidget {
  final VoidCallback? onYesTap;
  final VoidCallback? onCancelTap;
  final String? title;
  final String? description;

  const AttentionDialog({
    super.key,
    this.onYesTap,
    this.title,
    this.description,
    this.onCancelTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title ?? 'Confirm deletion', style: styDialogTitle),
            const SizedBox(height: 16),
            Text(
              description ??
                  'Do you really want to delete all completed tasks?',
              textAlign: TextAlign.center,
              style: styDialogDescription,
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextButton(
                    onPressed: onCancelTap,
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton(
                    onPressed: onYesTap,
                    child: const Text('Yes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
