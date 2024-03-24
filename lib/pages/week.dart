import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';

import 'package:full_body_routine/main.dart';
// import 'package:full_body_workout_program/pages/workout.dart';

class WeekPage extends StatefulWidget {
  const WeekPage({
    super.key,
  });

  @override
  State<WeekPage> createState() => _WeekPageState();
}

class _WeekPageState extends State<WeekPage> {
  List workoutWeek = [];

  @override
  initState() {
    super.initState();
    workoutWeek.addAll([
      'Вторник',
      'Четверг',
      'Суббота',
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final _myBox = Hive.box('myBox');
    int counter = Provider.of<CurrentWeek>(context).counter;
    if (_myBox.get('CurrentWeek') != null &&
        _myBox.get('CurrentWeek') != counter) {
      counter = _myBox.get('CurrentWeek');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Workout Week'),
      ),
      body: Column(children: [
        Container(
          padding: const EdgeInsets.all(32),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        'Current week $counter',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                  onPressed: counter == 1
                      ? null
                      : () {
                          Provider.of<CurrentWeek>(context, listen: false)
                              .minusCounter();
                        },
                  icon: Icon(
                    Icons.remove,
                    color: counter == 1
                        ? const Color.fromARGB(100, 255, 161, 172)
                        : Colors.red[500],
                  )),
              IconButton(
                  onPressed: () {
                    Provider.of<CurrentWeek>(context, listen: false)
                        .addCounter();
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.green[500],
                  )),
            ],
          ),
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/workout',
                  );
                  Provider.of<CurrentDay>(context, listen: false)
                      .setDay(workoutWeek[index]);
                },
                child: Text(workoutWeek[index]));
          },
          itemCount: workoutWeek.length,
        )
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/profile');
        },
        tooltip: 'Increment',
        child: const Icon(Icons.person),
      ),
    );
  }
}
