import 'package:flutter/material.dart';

Future<void> showDeleteTaskDialog({
  required BuildContext context,
  required Future<void> Function() onDelete,
}) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return _DeleteTaskDialog(onDelete: onDelete);
    },
  );
}

class _DeleteTaskDialog extends StatefulWidget {
  const _DeleteTaskDialog({required this.onDelete});

  final Future<void> Function() onDelete;

  @override
  State<_DeleteTaskDialog> createState() => _DeleteTaskDialogState();
}

class _DeleteTaskDialogState extends State<_DeleteTaskDialog> {
  bool _isDeleting = false;

  Future<void> _confirmDelete() async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      await widget.onDelete();

      // Keep animation visible a little longer
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        'Delete task?',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
      ),
      content: Text(
        _isDeleting
            ? 'Deleting task...'
            : 'Are you sure you want to delete this task?',
      ),
      actions: [
        if (!_isDeleting)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),

        FilledButton(
          onPressed: _isDeleting ? null : _confirmDelete,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFDC2626),
          ),
          child: _isDeleting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Delete'),
        ),
      ],
    );
  }
}
