import 'package:hive/hive.dart';

class ExerciseDataBase {
  List excisesList = [];

  final _myBox = Hive.box('myBox');

  void createInitialData() {
    excisesList = [
      ['Сведение ног', '40', 'Четверг', 'false'],
      ['Жим ногами', '100', 'Четверг', 'false'],
      ['Плечи', '8', 'Четверг', 'false'],
      ['Подтягивания', '85', 'Вторник', 'true'],
      ['Сведение рук ', '45', 'Суббота', 'false'],
      ['Трицепс', '15', 'Суббота', 'false'],
      ['Бицепс', '12', 'Вторник', 'false'],
      ['Пресс', '85', 'Суббота', 'true'],
      // ['Икры', '50', 'Суббота', 'false'],
      // ['Good Morning', '40', 'Четверг', 'false'],
      // ['Тяга нижнего блока', '65', 'Вторник', 'false'],
    ];
  }

  void loadData() {
    excisesList = _myBox.get("EXERCISES_LIST");
  }

  void updateDataBase() {
    _myBox.put("EXERCISES_LIST", excisesList);
  }
}
