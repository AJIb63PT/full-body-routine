import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ExerciseTile extends StatelessWidget {
  final dynamic taskName;
  final dynamic width;
  final dynamic day;
  // Function(bool?)? onChanged;
  Function(BuildContext)? deleteFunction;

  ExerciseTile({
    super.key,
    required this.taskName,
    required this.width,
    required this.day,
    // required this.onChanged,
    required this.deleteFunction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: deleteFunction,
              icon: Icons.delete,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            )
          ],
        ),
        child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.deepPurple[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              child: Container(
                  padding: const EdgeInsets.all(5),
                  child: ListTile(
                    title: Text('${taskName} ${width} kg'),
                    subtitle: Text(day.toString()),
                  )),
              onTap: () {
                // _dialogBuilder(context, item);
              },
            )),
      ),
    );
  }
}
