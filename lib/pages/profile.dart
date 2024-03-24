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

  final _controllerE = TextEditingController();
  final _controllerW = TextEditingController();

  // checkbox was tapped
  // void checkBoxChanged(bool? value, int index) {
  //   setState(() {
  //     db.toDoList[index][1] = !db.toDoList[index][1];
  //   });
  //   db.updateDataBase();
  // }

  saveNewTask() {
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

  void createNewTask() {
    Provider.of<DropDownState>(context, listen: false).setDay('Вторник');
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controllerE: _controllerE,
          controllerW: _controllerW,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) {
          return ExerciseTile(
            taskName: db.toDoList[index][0],
            weight: db.toDoList[index][1],
            day: db.toDoList[index][2],
            // onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      ),
    );
  }
}
