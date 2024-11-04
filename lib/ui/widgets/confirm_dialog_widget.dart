import 'package:flutter/material.dart';

class ConfirmDialogWidget extends StatelessWidget {
  final String title;
  final List<Widget> contents;
  final VoidCallback submitCallback;

  const ConfirmDialogWidget({
    super.key,
    required this.title,
    required this.contents,
    required this.submitCallback,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: contents,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.elliptical(10, 10)),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        OutlinedButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        FilledButton(
          style: const ButtonStyle(),
          onPressed: submitCallback,
          child: const Text('OK'),
        ),
      ],
    );
  }
}
