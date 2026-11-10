import 'package:equatable/equatable.dart';

class ShiftTime extends Equatable implements Comparable<ShiftTime> {
  final DateTime date;
  final bool day;

  const ShiftTime({required this.date, required this.day});
  
  @override
  int compareTo(ShiftTime other) => date.compareTo(other.date);

  @override
  List<Object?> get props => <Object?>[date, day];
}