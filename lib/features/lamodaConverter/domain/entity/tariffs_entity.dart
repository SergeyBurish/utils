import 'typedefs.dart';

class TariffsEntity {
  final LamodaTariffs lamodaTariffs;
  final Set<String> worksSet;

  TariffsEntity({required this.lamodaTariffs, required this.worksSet});
}