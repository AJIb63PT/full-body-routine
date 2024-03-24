import 'package:flutter/material.dart';

import 'my_button.dart';
import 'my_dropDown.dart';

class DialogBox extends StatelessWidget {
  final TextEditingController controllerE;
  final TextEditingController controllerW;

  final VoidCallback onSave;
  final VoidCallback onCancel;

  const DialogBox({
    super.key,
    required this.controllerE,
    required this.controllerW,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.deepPurple[100],
      content: Container(
        height: 320,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // get user input
            TextField(
              controller: controllerE,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Упражнение",
              ),
            ),
            Row(
              children: [
                SizedBox(
                    width: 120,
                    child: TextField(
                      controller: controllerW,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Вес",
                      ),
                    )),
                const SizedBox(width: 8),
                const SizedBox(width: 120, child: MyDropDown()),
              ],
            ),
            // buttons -> save + cancel
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // save button
                MyButton(
                  text: "Сохранить",
                  onPressed: onSave,
                ),

                const SizedBox(width: 8),

                // cancel button
                MyButton(text: "Отмена", onPressed: onCancel),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
