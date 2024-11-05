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
  bool isFifth = item.quinta == 5;
  bool isBW = bool.parse(item.isBW);
  bool isFD = item.isFocusDay;

  if (!isFD) {
    if (isFifth && !isBW) {
      return (double.parse(item.weight) * .5).floor().toString();
    }
    return item.weight;
  }
  if (isBW) {
    if (isFifth) return item.weight;
    return (double.parse(item.weight) +
            double.parse(item.weight) * .025 * item.cycle +
            double.parse(item.weight) * .05)
        .floor()
        .toString();
  }
  if (isFifth) return (double.parse(item.weight) * .5).floor().toString();

  return (double.parse(item.weight) +
          double.parse(item.weight) * .05 * item.cycle +
          double.parse(item.weight) * .2)
      .floor()
      .toString();
}
