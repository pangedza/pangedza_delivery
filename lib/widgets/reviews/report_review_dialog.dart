import 'package:flutter/material.dart';

class ReportReviewDialog extends StatelessWidget {
  const ReportReviewDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Внимание'),
      content: const Text('Пожалуйста, укажите причину подачи жалобы.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Отмена'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE30613),
            foregroundColor: Colors.white,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Пожаловаться'),
        ),
      ],
    );
  }
}
