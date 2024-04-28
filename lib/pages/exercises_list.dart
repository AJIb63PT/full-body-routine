import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../data/database.dart';
import '../util/dialog_box.dart';
import '../util/exercise_tile.dart';
import 'package:provider/provider.dart';
import 'package:full_body_routine/main.dart';

class ExercisesPage extends StatefulWidget {
  const ExercisesPage({super.key});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  final _myBox = Hive.box('myBox');
  final _controllerE = TextEditingController();
  final _controllerW = TextEditingController();
  ExerciseDataBase db = ExerciseDataBase();

  @override
  void initState() {
    if (_myBox.get("EXERCISES_LIST") == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }

    super.initState();
  }

  onTapBox(int index) {
    var [title, weight, focusDay, isBW] = db.excisesList[index];

    final controllerE = TextEditingController(text: title);
    final controllerW = TextEditingController(text: weight);

    Provider.of<DropDownState>(context, listen: false).setDay(focusDay);
    Provider.of<BodyWeightToggleState>(context, listen: false)
        .setValue(bool.parse(isBW));

    changeExercise(int index) {
      String hardDay = Provider.of<DropDownState>(context, listen: false).day;
      bool isBodyWeight =
          Provider.of<BodyWeightToggleState>(context, listen: false).value;
      String bodyWeight =
          Provider.of<BodyWeightValue>(context, listen: false).value;
      if (_myBox.get('BodyWeight') != null &&
          _myBox.get('BodyWeight') != bodyWeight) {
        bodyWeight = _myBox.get('BodyWeight');
      }
      String weight = isBodyWeight ? bodyWeight : controllerW.text;

      setState(() {
        db.excisesList[index] = [
          controllerE.text,
          weight,
          hardDay,
          isBodyWeight.toString()
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
    bool isBodyWeight =
        Provider.of<BodyWeightToggleState>(context, listen: false).value;
    String bodyWeight =
        Provider.of<BodyWeightValue>(context, listen: false).value;
    if (_myBox.get('BodyWeight') != null &&
        _myBox.get('BodyWeight') != bodyWeight) {
      bodyWeight = _myBox.get('BodyWeight');
    }
    String weight = isBodyWeight ? bodyWeight : _controllerW.text;

    setState(() {
      db.excisesList
          .add([_controllerE.text, weight, hardDay, isBodyWeight.toString()]);
      _controllerE.clear();
      _controllerW.clear();
    });
    Navigator.of(context).pop();
    db.updateDataBase();
  }

  void createNewExercise() {
    Provider.of<DropDownState>(context, listen: false).setDay('Вторник');
    Provider.of<BodyWeightToggleState>(context, listen: false).setValue(false);
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
      db.excisesList.removeAt(index);
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
        children: db.excisesList.asMap().entries.map((item) {
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
            List<String> startItem = db.excisesList[start];
            int i = 0;
            int local = start;
            do {
              db.excisesList[local] = db.excisesList[++local];
              i++;
            } while (i < end - start);
            db.excisesList[end] = startItem;
          }
          // dragging from bottom to top
          else if (start > current) {
            List<String> startItem = db.excisesList[start];
            for (int i = start; i > current; i--) {
              db.excisesList[i] = db.excisesList[i - 1];
            }
            db.excisesList[current] = startItem;
          }
          setState(() {
            db.updateDataBase();
          });
        },
      ),
    );
  }
}
