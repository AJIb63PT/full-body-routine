import 'package:hive/hive.dart';

class ExerciseDataBase {
  List toDoList = [];

  final _myBox = Hive.box('myBox');

  void createInitialData() {
    toDoList = [
      ["Squad", '85', 'Четверг'],
      ['Bringing Leg', '40', 'Четверг'],
      ['Good Morning', '40', 'Четверг'],
      ['Shoulders', '6', 'Четверг'],
      ['Calf', '50', 'Суббота'],
      ['Hug', '45', 'Суббота'],
      ['Pull ups Lower Block', '65', 'Вторник'],
      ['Pull ups', '80', 'Вторник'],
      ['Triceps', '13', 'Суббота'],
      ['Biceps', '12', 'Вторник'],
      ['Abs', '80', 'Суббота']
    ];
  }

  void loadData() {
    toDoList = _myBox.get("EXERCISELIST");
  }

  void updateDataBase() {
    _myBox.put("EXERCISELIST", toDoList);
  }
}
