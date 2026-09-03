import 'typedefs.dart';

class LamodaEntity {
  final LamodaShifts shifts;
  final Set<String> worksSet;
  final Set<String> loginsSet;

  LamodaEntity({
    required this.shifts, 
    required this.worksSet,
    required this.loginsSet,
  });

  bool get isEmpty => shifts.isEmpty && worksSet.isEmpty && loginsSet.isEmpty ;
}