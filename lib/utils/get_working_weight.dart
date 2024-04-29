class WorkingWeightArg {
  String weight;
  int cycle;
  String isBW;
  bool isFocusDay;
  int quinta;

  WorkingWeightArg({
    required this.weight,
    required this.cycle,
    required this.isBW,
    required this.isFocusDay,
    required this.quinta,
  });
}

String getWorkingWeight(WorkingWeightArg item) {
  if (item.isFocusDay) {
    if (bool.parse(item.isBW)) {
      if (item.quinta == 5) {
        return item.weight;
      }
      return (double.parse(item.weight) +
              double.parse(item.weight) * .025 * item.cycle +
              double.parse(item.weight) * .05)
          .floor()
          .toString();
    } else {
      if (item.quinta == 5) {
        return (double.parse(item.weight) * .5).floor().toString();
      }
      return (double.parse(item.weight) +
              double.parse(item.weight) * .05 * item.cycle +
              double.parse(item.weight) * .2)
          .floor()
          .toString();
    }
  } else {
    return item.weight;
  }
}
