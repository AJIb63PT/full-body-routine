import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/exercise_tile.dart';
import 'package:provider/provider.dart';
import 'package:full_body_routine/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _myBox = Hive.box('myBox');
  final _controllerE = TextEditingController();
  final _controllerW = TextEditingController();
  ExerciseDataBase db = ExerciseDataBase();

  @override
  void initState() {
    if (_myBox.get("EXERCISELIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  onTapBox(int index) {
    final controllerE = TextEditingController(text: db.toDoList[index][0]);
    final controllerW = TextEditingController(text: db.toDoList[index][1]);
    Provider.of<DropDownState>(context, listen: false)
        .setDay(db.toDoList[index][2]);
    changeExercise(int index) {
      String hardDay = Provider.of<DropDownState>(context, listen: false).day;

      setState(() {
        db.toDoList[index] = [
          controllerE.text,
          controllerW.text,
          hardDay,
        ];
        controllerE.clear();
        controllerW.clear();
      });
      Navigator.of(context).pop();
      db.updateDataBase();
    }

    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controllerE: controllerE,
          controllerW: controllerW,
          onSave: () => changeExercise(index),
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  saveNewExercise() {
    String hardDay = Provider.of<DropDownState>(context, listen: false).day;
    setState(() {
      db.toDoList.add([
        _controllerE.text,
        _controllerW.text,
        hardDay,
      ]);
      _controllerE.clear();
      _controllerW.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewExercise() {
    Provider.of<DropDownState>(context, listen: false).setDay('Вторник');
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controllerE: _controllerE,
          controllerW: _controllerW,
          onSave: saveNewExercise,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteExercise(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Упражнения'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewExercise,
        child: const Icon(Icons.add),
      ),
      body: ReorderableListView(
        children: db.toDoList.asMap().entries.map((item) {
          int idx = item.key;
          List<String> val = item.value;

          return ExerciseTile(
            exerciseName: val[0],
            weight: val[1],
            day: val[2],
            key: Key("$idx"),
            onChanged: (value) => onTapBox(idx),
            deleteFunction: (context) => deleteExercise(idx),
          );
        }).toList(),
        onReorder: (int start, int current) {
          // dragging from top to bottom
          if (start < current) {
            int end = current - 1;
            List<String> startItem = db.toDoList[start];
            int i = 0;
            int local = start;
            do {
              db.toDoList[local] = db.toDoList[++local];
              i++;
            } while (i < end - start);
            db.toDoList[end] = startItem;
          }
          // dragging from bottom to top
          else if (start > current) {
            List<String> startItem = db.toDoList[start];
            for (int i = start; i > current; i--) {
              db.toDoList[i] = db.toDoList[i - 1];
            }
            db.toDoList[current] = startItem;
          }
          setState(() {
            db.updateDataBase();
          });
        },
      ),
    );
  }
}
