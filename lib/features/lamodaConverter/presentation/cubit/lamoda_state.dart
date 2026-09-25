part of 'lamoda_cubit.dart';

enum LamodaStatus {
  idle,
  inProgress,
  sourceFilesLoading,
  fileHandling,
  filesHandled,
  fileDownloading,
  fileDownloaded,
  allFilesErrors,
  error,
}

enum TariffsStatus {
  idle,
  tariffsLoading,
  tariffsDownloading,
  tariffsDownloaded,
  tariffsError,
}

enum EmployeesStatus {
  idle,
  employeesLoading,
  employeesLoaded,
  employeesDownloading,
  employeesDownloaded,
  employeesError,
}

@CopyWith(constructor: '_')
class LamodaState {
  final LamodaStatus status;
  final TariffsStatus tariffsStatus;
  final EmployeesStatus employeesStatus;
  final int filesLength;
  final String currentFile;
  final int currentFileInd;
  final String downloadedFile;
  final List<String> errors;
  final LamodaEntity lamodaEntity;
  final LamodaTariffs lamodaTariffs;

  LamodaState({
    required this.status,
    required this.tariffsStatus,
    required this.employeesStatus,
    required this.filesLength,
    required this.currentFile,
    required this.currentFileInd,
    required this.downloadedFile,
    required this.errors,
    required this.lamodaEntity,
    required this.lamodaTariffs,
  });

  LamodaState._({
    required this.status,
    required this.tariffsStatus,
    required this.employeesStatus,
    required this.filesLength,
    required this.currentFile,
    required this.currentFileInd,
    required this.downloadedFile,
    required this.errors,
    required this.lamodaEntity,
    required this.lamodaTariffs,
  });

  LamodaState.initial() :
    status = LamodaStatus.idle,
    tariffsStatus = TariffsStatus.idle,
    employeesStatus = EmployeesStatus.idle,
    filesLength = 0,
    currentFile = '',
    currentFileInd = 0,
    downloadedFile = '',
    errors = <String>[],
    lamodaEntity = LamodaEntity(
      shifts: <ShiftTime, WorkerShifts>{},
      nttShifts: <ShiftTime, WorkerShifts>{},
      lamodaEmployees: <String, EmployeeDetails>{},
      worksSet: <String>{},
      nttWorksSet: <String>{},
    ),
    lamodaTariffs = <DateTime, Tariffs>{};

  bool get inProgress => 
    status == LamodaStatus.sourceFilesLoading ||
    status == LamodaStatus.fileHandling || 
    status == LamodaStatus.fileDownloading ||
    tariffsStatus == TariffsStatus.tariffsLoading ||
    tariffsStatus == TariffsStatus.tariffsDownloading ||
    employeesStatus == EmployeesStatus.employeesLoading ||
    employeesStatus == EmployeesStatus.employeesDownloading;

  bool get resultIsReady => lamodaEntity.shifts.isNotEmpty && !inProgress;
  bool get fileDownloaded => status == LamodaStatus.fileDownloaded;

  String get message => switch (status) {
    LamodaStatus.idle => 'waiting_for_source_files'.tr(),
    LamodaStatus.inProgress => 'inProgress',
    LamodaStatus.sourceFilesLoading => 'source_files_loading'.tr(),
    LamodaStatus.fileHandling => 'file_handling'.tr(args: <String>[
      '${currentFileInd + 1}', '$filesLength', currentFile]),
    LamodaStatus.filesHandled => 'files_handled'.tr(),
    LamodaStatus.fileDownloading => 'file_downloading'.tr(),
    LamodaStatus.fileDownloaded => 'file_downloaded'.tr(args: <String>[downloadedFile]),
    LamodaStatus.allFilesErrors => 'all_files_with_errors'.tr(),
    LamodaStatus.error => 'error_occurred'.tr(),
  };

  String get tariffsMessage => switch (tariffsStatus) {
    TariffsStatus.idle => lamodaTariffs.isEmpty
      ? 'tariffs_not_added'.tr()
      : 'tariffs_added_for_dates'.tr(args: <String>[(lamodaTariffs.keys.toList()..sort()).map((DateTime date) => DateFormat('dd-MM-yy').format(date)).join(', ')]),
    TariffsStatus.tariffsLoading => 'tariffs_loading'.tr(),
    TariffsStatus.tariffsDownloading => 'tariffs_downloading'.tr(),
    TariffsStatus.tariffsDownloaded => 'tariffs_downloaded'.tr(args: <String>[downloadedFile]),
    TariffsStatus.tariffsError => 'tariffs_error'.tr(),
  };

  String get employeesMessage => switch (employeesStatus) {
    EmployeesStatus.idle => 'employees_not_added'.tr(),
    EmployeesStatus.employeesLoaded => 'employees_added'.tr(args: <String>['${lamodaEntity.lamodaEmployees.length}']),
    EmployeesStatus.employeesLoading => 'employees_loading'.tr(),
    EmployeesStatus.employeesDownloading => 'employees_downloading'.tr(),
    EmployeesStatus.employeesDownloaded => 'employees_downloaded'.tr(args: <String>[downloadedFile]),
    EmployeesStatus.employeesError => 'employees_error'.tr(),
  };

  String get errorMessage => errors.isEmpty 
    ? 'no_errors'.tr() 
    : '${'errors'.tr()}\n${errors.indexed.map(((int, String) el)=>'${el.$1+1}: ${el.$2}\n').join()}';
}
