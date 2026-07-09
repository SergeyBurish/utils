part of 'lamoda_cubit.dart';

enum LamodaStatus {
  idle,
  inProgress,
  sourceFilesLoading,
  fileHandling,
  resultReady,
  fileDownloading,
  fileDownloaded,
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

  LamodaState({
    required this.status,
    required this.filesLength,
    required this.currentFile,
    required this.currentFileInd,
    required this.downloadedFile,
    required this.errors,
    required this.lamodaEntity,
  });

  LamodaState._({
    required this.status,
    required this.filesLength,
    required this.currentFile,
    required this.currentFileInd,
    required this.downloadedFile,
    required this.errors,
    required this.lamodaEntity,
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
      worksSet: <String>{});

  bool get inProgress => 
    status == LamodaStatus.sourceFilesLoading ||
    status == LamodaStatus.fileHandling || 
    status == LamodaStatus.fileDownloading;

  bool get resultIsReady => status == LamodaStatus.resultReady || status == LamodaStatus.fileDownloaded;
  bool get fileDownloaded => status == LamodaStatus.fileDownloaded;

  String get message => switch (status) {
    LamodaStatus.idle => 'waiting_for_source_files'.tr(),
    LamodaStatus.inProgress => 'inProgress',
    LamodaStatus.sourceFilesLoading => 'source_files_loading'.tr(),
    LamodaStatus.fileHandling => 'file_handling'.tr(args: <String>[
      '${currentFileInd + 1}', '$filesLength', currentFile]),
    LamodaStatus.resultReady => 'result_ready'.tr(),
    LamodaStatus.fileDownloading => 'file_downloading'.tr(),
    LamodaStatus.fileDownloaded => 'file_downloaded'.tr(args: <String>[downloadedFile]),
    LamodaStatus.error => 'error',
  };

  String get errorMessage => errors.isEmpty 
    ? 'no_errors'.tr() 
    : '${'errors'.tr()}\n${errors.indexed.map(((int, String) el)=>'${el.$1+1}: ${el.$2}\n').join()}';
}
