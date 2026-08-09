import 'package:easy_localization/easy_localization.dart';

import '../dto/lm_column.dart';
import 'consts.dart';

// колонки до работ
final Map<int, LmColumn> outColumns1 = <int, LmColumn>{
  dateColumn: LmColumn(
    name: 'date'.tr(),
    bgColor: blue01,
  ),
  shiftColumn: LmColumn(
    name: 'shift'.tr(),
    bgColor: blue01,
  ),
  fullNameColumn: LmColumn(
    name: 'full_name'.tr(),
    bgColor: blue03,
  ),
  outLoginColumn: const LmColumn(
    name: '',
    bgColor: blue03,
  ),
  startDateColumn: LmColumn(
    name: 'status_start_date_of_work'.tr(),
    rotation: 90,
  ),
  fixed4000UntilColumn: LmColumn(
    name: 'fixed_at_4000_until'.tr(),
    rotation: 90,
    bgColor: blue01,
  ),
  increasedRateColumn: LmColumn(
    name: 'increased_rate_for_working_2_months'.tr(),
    rotation: 90,
    bgColor: yellow01,
  ),
};

// колонки после работ
final Map<int, LmColumn> outColumns2 = <int, LmColumn>{
  totalNumberPeeps: LmColumn(
    name: 'total_number_of_peeps'.tr(),
    rotation: 90,
    bgColor: yellow02,
  ),
  peepsWithoutNtt: LmColumn(
    name: 'peeps_without_ntt'.tr(),
    rotation: 90,
    bgColor: yellow02,
  ),
  accruedPerShiftBasedOnNumberOfPeeps: LmColumn(
    name: 'accrued_per_shift_based_on_number_of_peeps'.tr(),
    rotation: 90,
    bgColor: pink,
  ),
};
