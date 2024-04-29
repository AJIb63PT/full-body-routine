import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import '../data/database.dart';

import 'package:full_body_routine/main.dart';
import '../utils/get_workload.dart';
import '../utils/get_working_weight.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({
    super.key,
  });

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    final myBox = Hive.box('myBox');

    ExerciseDataBase db = ExerciseDataBase();
    String currentDay = Provider.of<CurrentDay>(context).day;
    int currentWeek = Provider.of<CurrentWeek>(context).counter;

    List<String> col_1 = ["Упражнение"];
    List<String> col_2 = ["Вес, кг"];
    List<String> col_3 = ["Подход"];
    List<String> col_4 = ["Повтор-ие"];
    List<String> hardDay = ["Вторник"];
    List<Excise> excises = [
      Excise(
        index: 0,
        title: col_1[0],
        weight: col_2[0],
        sets: col_3[0],
        repeats: col_4[0],
        hardDay: hardDay[0],
      )
    ];

    if (myBox.get('CurrentWeek') != null &&
        myBox.get('CurrentWeek') != currentWeek) {
      currentWeek = myBox.get('CurrentWeek');
    }
    if (myBox.get("EXERCISES_LIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    int cycle = 1;
    int quinta = currentWeek % 5;

    if (currentWeek >= 5) {
      cycle = (currentWeek ~/ 5) + 1;
    }
    if (quinta == 0) {
      quinta = 5;
      cycle = (currentWeek ~/ 5);
    }

    // the week counter in cycle (1-4th is progressive weeks, 5th is rest week)
    for (var i = 0; i < db.excisesList.length; i++) {
      int j = i + 1;
      var [title, weight, focusDay, isBW] = db.excisesList[i];

      col_1.add(title);
      col_2.add(getWorkingWeight(WorkingWeightArg(
          weight: weight,
          cycle: cycle,
          isBW: isBW,
          isFocusDay: currentDay == focusDay,
          quinta: quinta)));
      col_3.add('3');
      col_4.add('12');
      hardDay.add(focusDay);

      if (currentDay == focusDay) {
        List<String> res = getWorkload(quinta);
        col_3[j] = res[0];
        col_4[j] = res[1];
      }

      if (quinta == 5 && bool.parse(isBW)) {
        col_4[j] = '6';
      }

      excises.add(Excise(
        index: j,
        title: col_1[j],
        weight: col_2[j],
        sets: col_3[j],
        repeats: col_4[j],
        hardDay: hardDay[j],
      ));
    }

    getColors(Excise item) {
      if (item.title == 'Упражнение') {
        return const Color.fromARGB(255, 132, 90, 198);
      }
      if (currentDay == item.hardDay) {
        return const Color.fromARGB(255, 148, 104, 203);
      }
      return const Color.fromARGB(255, 243, 225, 255);
    }

    getTextStyleColors(Excise item) {
      if (item.title == 'Упражнение') {
        return const TextStyle(fontWeight: FontWeight.bold);
      }
      return const TextStyle(fontWeight: FontWeight.normal);
    }

    TableRow buildTableRow(Excise item) {
      return TableRow(
          key: ValueKey(item.index),
          decoration: BoxDecoration(
            color: getColors(item),
          ),
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  item.title,
                  style: getTextStyleColors(item),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  item.weight,
                  style: getTextStyleColors(item),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  item.sets,
                  style: getTextStyleColors(item),
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  item.repeats,
                  style: getTextStyleColors(item),
                ),
              ),
            ),
          ]);
    }

    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text('$currentDay на $currentWeek неделе')),
      body: Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: excises.map((item) => buildTableRow(item)).toList(),
      ),
    );
  }
}
