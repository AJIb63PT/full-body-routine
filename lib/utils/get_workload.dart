class WorkloadArg {
  bool isFocusDay;
  int quinta;
  String isBW;

  WorkloadArg({
    required this.isFocusDay,
    required this.quinta,
    required this.isBW,
  });
}

List<String> getWorkload(WorkloadArg item) {
  bool isBW = bool.parse(item.isBW);

  if (item.isFocusDay) {
    if (item.quinta == 1) return ['6', '2'];
    if (item.quinta == 2) return ['4', '3'];
    if (item.quinta == 3) return ['3', '4'];
    if (item.quinta == 4) return ['2', '6'];
  }
  if (item.quinta == 5 && isBW) return ['3', '6'];

  return ['3', '12'];
}
