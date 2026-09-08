import 'package:easy_localization/easy_localization.dart';

import '../dto/lm_column.dart';
import 'consts.dart';

// SheetFromDate
// колонки до работ
final Map<int, LmColumn> columnsFD1 = <int, LmColumn>{
  fDate: LmColumn(
    name: 'date'.tr(),
    bgColor: blue01,
  ),
  fShift: LmColumn(
    name: 'shift'.tr(),
    bgColor: blue01,
  ),
  fFullName: LmColumn(
    name: 'full_name'.tr(),
    bgColor: blue03,
  ),
  fLogin: LmColumn(
    name: 'login'.tr(),
    bgColor: blue03,
  ),
  fStatus: LmColumn(
    name: 'status'.tr(),
    rotation: 90,
  ),
  fStartDateColumn: LmColumn(
    name: 'start_date_of_work'.tr(),
    rotation: 90,
  ),
  fFixed4000Until: LmColumn(
    name: 'fixed_at_4000_until'.tr(),
    rotation: 90,
    bgColor: blue01,
  ),
  fIncreasedRate: LmColumn(
    name: 'increased_rate_for_working_2_months'.tr(),
    rotation: 90,
    bgColor: yellow01,
  ),
};

// колонки после работ
final Map<int, LmColumn> columnsFD2 = <int, LmColumn>{
  fTotalNumberPeeps: LmColumn(
    name: 'total_number_of_peeps'.tr(),
    rotation: 90,
    bgColor: yellow02,
  ),
  fPeepsWithoutNtt: LmColumn(
    name: 'peeps_without_ntt'.tr(),
    rotation: 90,
    bgColor: yellow02,
  ),
  fAccruedForTraining: LmColumn(
    name: 'accrued_for_training'.tr(),
    rotation: 90,
    bgColor: blue01,
  ),
  fAccruedPerShiftBasedOnNumberOfPeeps: LmColumn(
    name: 'accrued_per_shift_based_on_number_of_peeps'.tr(),
    rotation: 90,
    bgColor: pink,
  ),
  fAccruedForeman: LmColumn(
    name: 'accrued_foreman'.tr(),
    rotation: 90,
    bgColor: lilac,
  ),
  fNumberOfPeopleAdditionally: LmColumn(
    name: 'number_of_people_additionally'.tr(),
    rotation: 90,
    bgColor: lilac,
  ),
  fAmountOfAdditionalPayment: LmColumn(
    name: 'amount_of_additional_payment'.tr(),
    rotation: 90,
    bgColor: lilac,
  ),
  fPercentageOfProductivity: LmColumn(
    name: 'percentage_of_productivity_per_shift'.tr(),
    rotation: 90,
    bgColor: lilac,
  ),
  fBonusPayment: LmColumn(
    name: 'bonus_payment_for_production'.tr(),
    rotation: 90,
    bgColor: lilac,
  ),
  fFixed4000For5Days: LmColumn(
    name: 'fixed_at_4000_5_days'.tr(),
    rotation: 90,
    bgColor: blue01,
  ),
  fTotalAccrued: LmColumn(
    name: 'total_accrued'.tr(),
    rotation: 90,
    bgColor: blue03,
  ),
};

// SheetEmployeeDetails
final Map<int, LmColumn> columnsED = <int, LmColumn>{
  edLogin: LmColumn(
    name: 'login'.tr(),
    bgColor: blue01,
  ),
  edFullName: LmColumn(
    name: 'full_name'.tr(),
    bgColor: blue01,
  ),
  edStatus: LmColumn(
    name: 'status'.tr(),
    bgColor: blue01,
  ),
  edStartDateOfWork: LmColumn(
    name: 'start_date_of_work'.tr(),
    bgColor: blue01,
  ),
};
