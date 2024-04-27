import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'package:full_body_routine/pages/week.dart';
import 'package:full_body_routine/pages/workout.dart';
import 'package:full_body_routine/pages/exercises.dart';
import 'package:full_body_routine/pages/profileInfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  var box = await Hive.openBox('myBox');

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentWeek()),
        ChangeNotifierProvider(create: (context) => CurrentDay()),
        ChangeNotifierProvider(create: (context) => DropDownState()),
        ChangeNotifierProvider(create: (context) => BodyWeightToggleState()),
        ChangeNotifierProvider(create: (context) => BodyWeightValue()),
      ],
      child: MaterialApp(
        title: 'Full Body Routine',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WeekPage(),
          '/workout': (context) => const WorkoutPage(),
          '/exercises': (context) => const ExercisesPage(),
          '/info': (context) => const ProfileInfoPage(),
        },
      )));
}

class Excise {
  String title;
  String weight;
  int index;
  String sets;
  String repeats;
  String hardDay;

  Excise({
    required this.index,
    required this.title,
    required this.weight,
    required this.sets,
    required this.repeats,
    required this.hardDay,
  });
}

class CurrentWeek extends ChangeNotifier {
  final _myBox = Hive.box('myBox');
  int counter = 1;
  void addCounter() {
    if (_myBox.get('CurrentWeek') != null &&
        _myBox.get('CurrentWeek') != counter) {
      counter = _myBox.get('CurrentWeek');
    }
    counter++;
    _myBox.put('CurrentWeek', counter);

    notifyListeners();
  }

  void minusCounter() {
    if (_myBox.get('CurrentWeek') != null &&
        _myBox.get('CurrentWeek') != counter) {
      counter = _myBox.get('CurrentWeek');
    }
    counter--;
    _myBox.put('CurrentWeek', counter);
    notifyListeners();
  }
}

class DropDownState extends ChangeNotifier {
  String day = 'Вторник';

  void setDay(val) {
    day = val;
    notifyListeners();
  }
}

class BodyWeightToggleState extends ChangeNotifier {
  bool value = false;

  void setValue(bool val) {
    value = val;
    notifyListeners();
  }
}

class BodyWeightValue extends ChangeNotifier {
  final _myBox = Hive.box('myBox');
  String value = '80';
  void setBodyWeight(val) {
    if (_myBox.get('BodyWeight') != null && _myBox.get('BodyWeight') != value) {
      value = _myBox.get('BodyWeight');
    }
    value = val;
    _myBox.put('BodyWeight', value);

    notifyListeners();
  }
}

class CurrentDay extends ChangeNotifier {
  String day = '';

  void setCurrentDay(val) {
    day = val;
    notifyListeners();
  }
}
