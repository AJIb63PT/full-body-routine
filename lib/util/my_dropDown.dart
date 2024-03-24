import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:full_body_routine/main.dart';

/// Flutter code sample for [DropdownButton].
class ListItem {
  String label;
  int id;
  ListItem({
    required this.label,
    required this.id,
  });
}

List<String> list = <String>[
  'Вторник',
  'Четверг',
  'Суббота',
];

class MyDropDown extends StatefulWidget {
  const MyDropDown({super.key});

  @override
  State<MyDropDown> createState() => _MyDropDownState();
}

class _MyDropDownState extends State<MyDropDown> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          Provider.of<DropDownState>(context, listen: false)
              .setDay(dropdownValue);
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
