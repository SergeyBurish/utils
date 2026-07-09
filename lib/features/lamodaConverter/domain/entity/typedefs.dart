import 'shift_time.dart';

typedef Works = Map<String, int>; // work, number
typedef WorkerShifts = Map<String, Works>; // login, works
typedef LamodaShifts = Map<ShiftTime, WorkerShifts>;