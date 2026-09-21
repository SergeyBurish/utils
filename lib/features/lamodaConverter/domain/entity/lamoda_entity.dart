import 'typedefs.dart';

class LamodaEntity {
  final LamodaShifts shifts;
  final LamodaEmployees lamodaEmployees;
  final Set<String> worksSet;

  LamodaEntity({
    required this.shifts, 
    required this.lamodaEmployees,
    required this.worksSet,
  });

  bool get isEmpty => shifts.isEmpty && worksSet.isEmpty && lamodaEmployees.isEmpty ;
}