import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import '../data/database.dart';

import 'package:full_body_routine/main.dart';

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

    if (myBox.get('CurrentWeek') != null &&
        myBox.get('CurrentWeek') != currentWeek) {
      currentWeek = myBox.get('CurrentWeek');
    }
    if (myBox.get("EXERCISES_LIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    List<String> col_1 = [];
    List<String> col_2 = [];
    List<String> hardDay = [];
    List<String> isBWs = [];
    List<String> col_3 = [];
    List<String> col_4 = [];
    for (var i = 0; i < db.toDoList.length; i++) {
      col_1.add(db.toDoList[i][0]);
      col_2.add(db.toDoList[i][1]);
      col_3.add('3');
      col_4.add('12');
      hardDay.add(db.toDoList[i][2]);
      isBWs.add(db.toDoList[i][3]);
    }
    int cycle = 1;
    int quinta = currentWeek % 5;
    List<Excise> excises = [];

    if (currentWeek >= 5) {
      cycle = (currentWeek ~/ 5) + 1;
    }
    if (quinta == 0) {
      quinta = 5;
      cycle = (currentWeek ~/ 5);
    }
    for (var i = 0; i < db.toDoList.length; i++) {
      if (currentDay == db.toDoList[i][2]) {
        if (bool.parse(isBWs[i])) {
          col_2[i] = (double.parse(col_2[i]) +
                  double.parse(col_2[i]) * .025 * cycle +
                  double.parse(col_2[i]) * .05)
              .floor()
              .toString();
        } else {
          col_2[i] = (double.parse(col_2[i]) +
                  double.parse(col_2[i]) * .05 * cycle +
                  double.parse(col_2[i]) * .2)
              .floor()
              .toString();
        }
        if (quinta == 1) {
          col_3[i] = '6';
          col_4[i] = '2';
        }
        if (quinta == 2) {
          col_3[i] = '4';
          col_4[i] = '3';
        }
        if (quinta == 3) {
          col_3[i] = '3';
          col_4[i] = '4';
        }
        if (quinta == 4) {
          col_3[i] = '2';
          col_4[i] = '6';
        }
      }

      if (quinta == 5) {
        if (bool.parse(isBWs[i])) {
          col_4[i] = '6';
          col_2[i] = db.toDoList[i][1];
        } else {
          col_2[i] = (double.parse(col_2[i]) * .5).floor().toString();
        }
      }
    }

    col_1.insert(0, "Упражнение");
    col_2.insert(0, "Вес, кг");
    col_3.insert(0, "Подход");
    col_4.insert(0, "Повтор-ие");
    hardDay.insert(0, "Вторник");

    for (var i = 0; i < col_1.length; i++) {
      excises.add(Excise(
        index: i,
        title: col_1[i],
        weight: col_2[i],
        sets: col_3[i],
        repeats: col_4[i],
        hardDay: hardDay[i],
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
