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
    final _myBox = Hive.box('myBox');
    ExerciseDataBase db = ExerciseDataBase();

    String currentDay = Provider.of<CurrentDay>(context).day;
    int currentWeek = Provider.of<CurrentWeek>(context).counter;
    if (_myBox.get('CurrentWeek') != null &&
        _myBox.get('CurrentWeek') != currentWeek) {
      currentWeek = _myBox.get('CurrentWeek');
    }
    if (_myBox.get("EXERCISELIST") == null) {
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }
    List<String> Col_1 = [];
    List<String> Col_2 = [];
    List<String> hardDay = [];
    List<String> Col_3 = [];
    List<String> Col_4 = [];
    for (var i = 0; i < db.toDoList.length; i++) {
      Col_1.add(db.toDoList[i][0]);
      Col_2.add(db.toDoList[i][1]);
      Col_3.add('3');
      Col_4.add('12');
      hardDay.add(db.toDoList[i][2]);
    }
    int cycle = 1;
    int quarter = currentWeek % 4;
    List<Excise> excises = [];

    if (currentWeek >= 4) {
      cycle = (currentWeek ~/ 4) + 1;
    }
    if (quarter == 0) {
      quarter = 4;
      cycle = (currentWeek ~/ 4);
    }
    for (var i = 0; i < db.toDoList.length; i++) {
      if (currentDay == db.toDoList[i][2]) {
        if (Col_2[i] == '80') {
          Col_2[i] = (int.parse(Col_2[i]) + int.parse(Col_2[i]) * .025 * cycle
              //  + int.parse(Col_2[i]) * .1
              )
              .floor()
              .toString();
        } else {
          Col_2[i] = (int.parse(Col_2[i]) +
                  int.parse(Col_2[i]) * .05 * cycle +
                  int.parse(Col_2[i]) * .2)
              .floor()
              .toString();
        }
        if (quarter == 1) {
          Col_3[i] = '6';
          Col_4[i] = '2';
        }
        if (quarter == 2) {
          Col_3[i] = '4';
          Col_4[i] = '3';
        }
        if (quarter == 3) {
          Col_3[i] = '3';
          Col_4[i] = '4';
        }
        if (quarter == 4) {
          Col_3[i] = '2';
          Col_4[i] = '6';
        }
      }
    }

    Col_1.insert(0, "Упражнение");
    Col_2.insert(0, "Вес, кг");
    Col_3.insert(0, "Подход");
    Col_4.insert(0, "Повтор-ие");
    hardDay.insert(0, "Вторник");

    for (var i = 0; i < Col_1.length; i++) {
      excises.add(Excise(
        index: i,
        title: Col_1[i],
        weight: Col_2[i],
        sets: Col_3[i],
        repeats: Col_4[i],
        hardDay: hardDay[i],
      ));
    }

    @override
    initState() {
      super.initState();
    }

    getColors(Excise item) {
      if (item.title == 'Упражнение') {
        return Colors.grey[500];
      }

      if (currentDay == item.hardDay) {
        return Colors.orangeAccent;
      }

      return Colors.lightBlueAccent;
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
                child: Text(item.title),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(item.weight),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(item.sets),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(item.repeats),
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
