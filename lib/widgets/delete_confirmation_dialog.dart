import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String contactName;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.contactName,
    required this.onConfirm,
  });

  static Future<bool?> show(
    BuildContext context, {
    required String contactName,
    required VoidCallback onConfirm,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        contactName: contactName,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete contact?'),
      content: Text(
        'Are you sure you want to delete "$contactName"? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop(true);
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
