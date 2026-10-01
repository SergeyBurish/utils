import 'typedefs.dart';

class TariffsEntity {
  final LamodaTariffs lamodaTariffs;
  final Set<String> worksSet;
  final Set<String> nttWorksSet;

  TariffsEntity({required this.lamodaTariffs, required this.worksSet, required this.nttWorksSet});
}