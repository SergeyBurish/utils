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
  statusStartDateColumn: LmColumn(
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
  accruedForTraining: LmColumn(
    name: 'accrued_for_training'.tr(),
    rotation: 90,
    bgColor: blue01,
  ),
  accruedPerShiftBasedOnNumberOfPeeps: LmColumn(
    name: 'accrued_per_shift_based_on_number_of_peeps'.tr(),
    rotation: 90,
    bgColor: pink,
  ),
  accruedForeman: LmColumn(
    name: 'accrued_foreman'.tr(),
    rotation: 90,
    bgColor: lilac,
  ),
  numberOfPeopleAdditionally: LmColumn(
    name: 'number_of_people_additionally'.tr(),
    rotation: 90,
    bgColor: lilac,
  ),
  amountOfAdditionalPayment: LmColumn(
    name: 'amount_of_additional_payment'.tr(),
    rotation: 90,
    bgColor: lilac,
  ),
  percentageOfProductivity: LmColumn(
    name: 'percentage_of_productivity_per_shift'.tr(),
    rotation: 90,
    bgColor: lilac,
  ),
  bonusPayment: LmColumn(
    name: 'bonus_payment_for_production'.tr(),
    rotation: 90,
    bgColor: lilac,
  ),
  fixed4000For5Days: LmColumn(
    name: 'fixed_at_4000_5_days'.tr(),
    rotation: 90,
    bgColor: blue01,
  ),
  totalAccrued: LmColumn(
    name: 'total_accrued'.tr(),
    rotation: 90,
    bgColor: blue03,
  ),
};
