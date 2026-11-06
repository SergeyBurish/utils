import 'employee_details.dart';
import 'penalty_entity.dart';
import 'shift_time.dart';

typedef Works = Map<String, int>; // work, number
typedef WorkerShifts = Map<String, Works>; // login, works
typedef LamodaShifts = Map<ShiftTime, WorkerShifts>;

typedef Tariffs = Map<String, double>; // work, price
typedef LamodaTariffs = Map<DateTime, Tariffs>; // date, tariffs

typedef LamodaEmployees = Map<String, EmployeeDetails>; // login, EmployeeDetails

typedef WorkerPenalties = Map<String, PenaltyEntity>; // login, penalties
typedef LamodaPenalties = Map<ShiftTime, WorkerPenalties>;
