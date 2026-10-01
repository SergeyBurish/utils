import 'typedefs.dart';

class LamodaEntity {
  final LamodaShifts shifts;
  final LamodaShifts nttShifts;
  final LamodaEmployees lamodaEmployees;
  final Set<String> worksSet;
  final Set<String> nttWorksSet;

  LamodaEntity({
    required this.shifts, 
    required this.nttShifts,
    required this.lamodaEmployees,
    required this.worksSet,
    required this.nttWorksSet,
  });

  bool get isEmpty => shifts.isEmpty && worksSet.isEmpty && lamodaEmployees.isEmpty ;
}