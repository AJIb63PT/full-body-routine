import 'package:hive/hive.dart';

class ExerciseDataBase {
  List toDoList = [];

  final _myBox = Hive.box('myBox');

  void createInitialData() {
    toDoList = [
      ["Жим ногами", '85', 'Четверг'],
      ['Сведение ног', '40', 'Четверг'],
      ['Good Morning', '40', 'Четверг'],
      ['Плечи', '8', 'Четверг'],
      ['Икры', '50', 'Суббота'],
      ['Сведение рук ', '45', 'Суббота'],
      ['Тяга нижнего блока', '65', 'Вторник'],
      ['Подтягивания', '80', 'Вторник'],
      ['Трицепс', '15', 'Суббота'],
      ['Бицепс', '12', 'Вторник'],
      ['Пресс', '80', 'Суббота']
    ];
  }

  void loadData() {
    toDoList = _myBox.get("EXERCISELIST");
  }

  void updateDataBase() {
    _myBox.put("EXERCISELIST", toDoList);
  }
}
