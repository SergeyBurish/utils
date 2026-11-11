import 'package:equatable/equatable.dart';

class ShiftTime extends Equatable implements Comparable<ShiftTime> {
  final DateTime date;
  final bool day;

  ShiftTime({required DateTime date, required this.day})
    : date = DateTime(date.year, date.month, date.day);
  
  @override
  int compareTo(ShiftTime other) => date.compareTo(other.date);

  @override
  List<Object?> get props => <Object?>[date, day];
}