import 'package:hive/hive.dart';

class ExerciseDataBase {
  List toDoList = [];

  final _myBox = Hive.box('myBox');

  void createInitialData() {
    List toDoList = [
      ["Жим ногами", '85', 'Четверг', 'false'],
      ['Сведение ног', '40', 'Четверг', 'false'],
      ['Good Morning', '40', 'Четверг', 'false'],
      ['Плечи', '8', 'Четверг', 'false'],
      ['Икры', '50', 'Суббота', 'false'],
      ['Сведение рук ', '45', 'Суббота', 'false'],
      ['Тяга нижнего блока', '65', 'Вторник', 'false'],
      ['Подтягивания', '80', 'Вторник', 'true'],
      ['Трицепс', '15', 'Суббота', 'false'],
      ['Бицепс', '12', 'Вторник', 'false'],
      ['Пресс', '80', 'Суббота', 'true']
    ];
  }

  void loadData() {
    toDoList = _myBox.get("EXERCISELIST");
  }

  void updateDataBase() {
    _myBox.put("EXERCISELIST", toDoList);
  }
}
