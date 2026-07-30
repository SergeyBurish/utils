import 'package:easy_localization/easy_localization.dart';

import '../dto/lm_column.dart';
import 'consts.dart';

final Map<int, LmColumn> outColumns = <int, LmColumn>{
  totalNumberPeeps: LmColumn(
    name: 'total_number_of_peeps'.tr(),
    bgColor: '#FFD500',
  ),
  peepsWithoutNtt: LmColumn(
    name: 'peeps_without_ntt'.tr(),
    bgColor: '#FFD500',
  ),
};
