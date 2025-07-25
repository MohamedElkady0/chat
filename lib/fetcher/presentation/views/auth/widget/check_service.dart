import 'package:flutter/material.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/policy_of_service.dart';

class CheckService extends StatelessWidget {
  const CheckService({
    super.key,
    required this.value,
    this.onChanged,
    required this.onPressed,
    required this.onCancel,
  });
  final bool value;
  final Function(bool?)? onChanged;
  final void Function()? onPressed;
  final void Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('شروط الخدمة'),
      content: const PolicyOfServiceWidget(),
      actions: [
        CheckboxListTile.adaptive(
          value: value,
          onChanged: onChanged,
          title: const Text('أوافق على شروط الخدمة'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: onCancel, child: const Text('إلغاء')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: onPressed, child: const Text('موافق')),
          ],
        ),
      ],
    );
  }
}
