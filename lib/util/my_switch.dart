import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:full_body_routine/main.dart';

class MySwitch extends StatefulWidget {
  const MySwitch({super.key});

  @override
  State<MySwitch> createState() => _MySwitchState();
}

class _MySwitchState extends State<MySwitch> {
  @override
  Widget build(BuildContext context) {
    bool isBodyWeight =
        Provider.of<BodyWeightToggleState>(context, listen: false).value;
    return Row(children: [
      Text(
        'Упражнение с весом тела',
        style: TextStyle(
            color: isBodyWeight
                ? Colors.deepPurple
                : const Color.fromARGB(255, 148, 148, 148)),
      ),
      const SizedBox(width: 8),
      Switch(
        value: isBodyWeight,
        onChanged: (value) {
          setState(() {
            Provider.of<BodyWeightToggleState>(context, listen: false)
                .setValue(value);
          });
        },
      ),
    ]);
  }
}
