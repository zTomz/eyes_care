import 'package:eyes_care/widgets/duration_picker_dialog.dart';
import 'package:flutter/material.dart';

class EditRuleButton extends StatefulWidget {
  const EditRuleButton({
    super.key,
  });

  @override
  State<EditRuleButton> createState() => _EditRuleButtonState();
}

class _EditRuleButtonState extends State<EditRuleButton> {
  int minutes = 20;
  int seconds = 20;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return DurationPickerDialog(
              onConfirm: (int min, int sec) {
                minutes = min;
                seconds = sec;
                setState(() {});
              },
            );
          },
        );
      },
      child: Column(
        children: [const Text("Edit Rule"), Text("${minutes}m - ${seconds}s")],
      ),
    );
  }
}
