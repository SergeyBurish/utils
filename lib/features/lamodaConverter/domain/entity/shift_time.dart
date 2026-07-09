class ShiftTime implements Comparable<ShiftTime> {
  final DateTime date;
  final bool day;

  ShiftTime({required this.date, required this.day});
  
  @override
  int compareTo(ShiftTime other) => date.compareTo(other.date);
}