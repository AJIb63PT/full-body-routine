import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import 'package:full_body_routine/main.dart';

class WorkoutPage extends StatefulWidget {
  const WorkoutPage({
    super.key,
  });
  // final String title;

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class Item {
  Item(
    this.id,
    this.title,
    this.weight,
    this.sets,
    this.repeats,
  );

  int id;
  String title;
  String weight;
  String sets;
  String repeats;
}

class _WorkoutPageState extends State<WorkoutPage> {
  @override
  Widget build(BuildContext context) {
    final _myBox = Hive.box('myBox');

    String currentDay = Provider.of<CurrentDay>(context).day;
    int currentWeek = Provider.of<CurrentWeek>(context).counter;
    if (_myBox.get('CurrentWeek') != null &&
        _myBox.get('CurrentWeek') != currentWeek) {
      currentWeek = _myBox.get('CurrentWeek');
    }
    int cycle = 1;
    int quarter = currentWeek % 4;
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

    String bodyWeight = Provider.of<ProfileInfo>(context).bodyWeight;

    String wSquad = Provider.of<ProfileInfo>(context).wSquad;
    String wBringing = Provider.of<ProfileInfo>(context).wBringing;
    String wShoulders = Provider.of<ProfileInfo>(context).wShoulders;
    String wHug = Provider.of<ProfileInfo>(context).wHug;
    String wPullLB = Provider.of<ProfileInfo>(context).wPullLB;
    String wTriceps = Provider.of<ProfileInfo>(context).wTriceps;
    String wBiceps = Provider.of<ProfileInfo>(context).wBiceps;
    List hardIndex = [];
    List items = [];
    List<String> Col_1 = ['Exercise', ...Provider.of<List>(context)];
    List Col_2 = [
      'Weight, kg',
      wSquad,
      wBringing,
      wShoulders,
      wHug,
      wPullLB,
      bodyWeight,
      wTriceps,
      wBiceps,
      bodyWeight
    ];
    List<String> Col_3 = ['Sets', '3', '3', '2', '3', '3', '3', '3', '2', '2'];
    List<String> Col_4 = [
      'Repeats',
      '12',
      '12',
      '12',
      '12',
      '12',
      '12',
      '12',
      '12',
      '12'
    ];
    if (currentDay == 'Tuesday') {
      hardIndex.addAll([5, 6, 8]);
    }

    if (currentDay == 'Thursday') {
      hardIndex.addAll([4, 7, 9]);
    }

    if (currentDay == 'Saturday') {
      hardIndex.addAll([1, 2, 3]);
    }

    for (var i = 0; i < hardIndex.length; i++) {
      if (hardIndex[i] == 6 || hardIndex[i] == 9) {
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
      items.add(Item(
        i,
        Col_1[i],
        Col_2[i],
        Col_3[i],
        Col_4[i],
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

    TableRow buildTableRow(Item item) {
      return TableRow(
          key: ValueKey(item.id),
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
