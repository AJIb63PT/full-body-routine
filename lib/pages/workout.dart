import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

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
    String currentDay = Provider.of<CurrentDay>(context).day;
    int currentWeek = Provider.of<CurrentWeek>(context).counter;
    List<String> Col_1 = Provider.of<ProfileInfo>(context).workoutExcises;
    List<String> Col_2 = Provider.of<ProfileInfo>(context).Col_2();
    List<String> Col_3 = Provider.of<ProfileInfo>(context).Col_3;
    List<String> Col_4 = Provider.of<ProfileInfo>(context).Col_4;
    int cycle = 1;
    int quarter = currentWeek % 4;
    List hardIndex = [];
    List<Excise> items = [];

    if (_myBox.get('CurrentWeek') != null &&
        _myBox.get('CurrentWeek') != currentWeek) {
      currentWeek = _myBox.get('CurrentWeek');
    }

    if (currentWeek >= 4) {
      cycle = (currentWeek ~/ 4) + 1;
    }
    if (quarter == 0) {
      quarter = 4;
      cycle = (currentWeek ~/ 4);
    }

    print('currentWeek $currentWeek');

    print('c $cycle');
    print('q $quarter');

    if (currentDay == 'Tuesday') {
      hardIndex.addAll([6, 7, 9]);
    }

    if (currentDay == 'Thursday') {
      hardIndex.addAll([5, 8, 10]);
    }

    if (currentDay == 'Saturday') {
      hardIndex.addAll([1, 2, 3]);
    }

    for (var i = 0; i < hardIndex.length; i++) {
      if (hardIndex[i] == 7 || hardIndex[i] == 10) {
        Col_2[hardIndex[i]] = (int.parse(Col_2[hardIndex[i]]) +
                int.parse(Col_2[hardIndex[i]]) * .025 * cycle
            //  + int.parse(Col_2[hardIndex[i]]) * .1
            )
            .floor()
            .toString();
      } else {
        Col_2[hardIndex[i]] = (int.parse(Col_2[hardIndex[i]]) +
                int.parse(Col_2[hardIndex[i]]) * .05 * cycle +
                int.parse(Col_2[hardIndex[i]]) * .2)
            .floor()
            .toString();
      }
      if (quarter == 1) {
        Col_3[hardIndex[i]] = '6';
        Col_4[hardIndex[i]] = '2';
      }
      if (quarter == 2) {
        Col_3[hardIndex[i]] = '4';
        Col_4[hardIndex[i]] = '3';
      }
      if (quarter == 3) {
        Col_3[hardIndex[i]] = '3';
        Col_4[hardIndex[i]] = '4';
      }
      if (quarter == 4) {
        Col_3[hardIndex[i]] = '2';
        Col_4[hardIndex[i]] = '6';
      }
    }
    for (var i = 0; i < Col_1.length; i++) {
      items.add(Excise(
        index: i,
        title: Col_1[i],
        weight: Col_2[i],
        sets: Col_3[i],
        repeats: Col_4[i],
      ));
    }
    @override
    initState() {
      super.initState();
    }

    getColors(String title) {
      if (title == 'Exercise') {
        return Colors.grey[500];
      }

      if (currentDay == 'Tuesday' &&
          (title == 'Pull ups Lower Block' ||
              title == 'Pull ups' ||
              title == 'Biceps')) {
        return Colors.orangeAccent;
      }

      if (currentDay == 'Thursday' &&
          (title == 'Abs' || title == 'Triceps' || title == 'Hug')) {
        return Colors.orangeAccent;
      }

      if (currentDay == 'Saturday' &&
          (title == 'Squad' ||
              title == 'Bringing Leg' ||
              title == 'Shoulders')) {
        return Colors.orangeAccent;
      }
      return Colors.lightBlueAccent;
    }

    TableRow buildTableRow(Excise item) {
      return TableRow(
          key: ValueKey(item.index),
          decoration: BoxDecoration(
            color: getColors(item.title),
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
          title: Text('$currentDay at $currentWeek week')),
      body: Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
          2: FlexColumnWidth(),
          3: FlexColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: items.map((item) => buildTableRow(item)).toList(),
      ),
    );
  }
}
