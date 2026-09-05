part of 'lamoda_cubit.dart';

enum LamodaStatus {
  idle,
  inProgress,
  sourceFilesLoading,
  tariffsLoading,
  fileHandling,
  filesHandled,
  tariffsLoaded,
  fileDownloading,
  fileDownloaded,
  tariffsDownloaded,
  allFilesErrors,
  error,
}

@CopyWith(constructor: '_')
class LamodaState {
  final LamodaStatus status;
  final int filesLength;
  final String currentFile;
  final int currentFileInd;
  final String downloadedFile;
  final List<String> errors;
  final LamodaEntity lamodaEntity;
  final LamodaTariffs lamodaTariffs;

  LamodaState({
    required this.status,
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
    filesLength = 0,
    currentFile = '',
    currentFileInd = 0,
    downloadedFile = '',
    errors = <String>[],
    lamodaEntity = LamodaEntity(
      shifts: <ShiftTime, WorkerShifts>{},
      worksSet: <String>{},
      loginsSet: <String>{},
    ),
    lamodaTariffs = <DateTime, Tariffs>{};

  bool get inProgress => 
    status == LamodaStatus.sourceFilesLoading ||
    status == LamodaStatus.tariffsLoading ||
    status == LamodaStatus.fileHandling || 
    status == LamodaStatus.fileDownloading;

  bool get resultIsReady => !lamodaEntity.isEmpty;
  bool get fileDownloaded => status == LamodaStatus.fileDownloaded;

  String get message => switch (status) {
    LamodaStatus.idle => 'waiting_for_source_files'.tr(),
    LamodaStatus.inProgress => 'inProgress',
    LamodaStatus.sourceFilesLoading => 'source_files_loading'.tr(),
    LamodaStatus.tariffsLoading => 'tariffs_loading'.tr(),
    LamodaStatus.fileHandling => 'file_handling'.tr(args: <String>[
      '${currentFileInd + 1}', '$filesLength', currentFile]),
    LamodaStatus.filesHandled => 'files_handled'.tr(),
    LamodaStatus.tariffsLoaded => 'tariffs_added'.tr(),
    LamodaStatus.fileDownloading => 'file_downloading'.tr(),
    LamodaStatus.fileDownloaded => 'file_downloaded'.tr(args: <String>[downloadedFile]),
    LamodaStatus.tariffsDownloaded => 'tariffs_downloaded'.tr(args: <String>[downloadedFile]),
    LamodaStatus.allFilesErrors => 'all_files_with_errors'.tr(),
    LamodaStatus.error => 'error_occurred'.tr(),
  };

  String get tariffsMessage => lamodaTariffs.isEmpty
    ? 'tariffs_not_added'.tr()
    : 'tariffs_added_for_dates'.tr(args: <String>[lamodaTariffs.keys.map((DateTime date) => DateFormat('dd-MM-yy').format(date)).join(', ')]);

  String get errorMessage => errors.isEmpty 
    ? 'no_errors'.tr() 
    : '${'errors'.tr()}\n${errors.indexed.map(((int, String) el)=>'${el.$1+1}: ${el.$2}\n').join()}';
}
