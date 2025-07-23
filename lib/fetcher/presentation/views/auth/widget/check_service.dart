import 'package:flutter/material.dart';
import 'package:my_chat/fetcher/presentation/views/auth/widget/policy_of_service.dart';

class CheckService extends StatelessWidget {
  const CheckService({super.key, required this.value, this.onChanged});
  final bool value;
  final Function(bool?)? onChanged;

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('تأكيد الخدمة'),
      content: PolicyOfServiceWidget(),
      actions: [
        CheckboxListTile.adaptive(
          value: value,
          onChanged: onChanged,
          title: const Text('أوافق على شروط الخدمة'),
          controlAffinity: ListTileControlAffinity.leading,
        ),
        ElevatedButton(
          onPressed: () {
            if (value) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تمت الموافقة على شروط الخدمة')),
              );
            } else {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('يجب الموافقة على شروط الخدمة')),
              );
            }
          },
          child: const Text('موافق'),
        ),
      ],
    );
  }
}
