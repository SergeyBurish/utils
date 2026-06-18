part of 'lamoda_cubit.dart';

enum LamodaStatus {
  idle,
  inProgress,
  success,
  error,
}

@CopyWith(constructor: '_')
class LamodaState {
  final LamodaStatus status;
  final List<String> files;

  LamodaState({
    required this.status,
    required this.files,
  });

  LamodaState._({
    required this.status,
    required this.files,
  });

  LamodaState.initial() :
    status = LamodaStatus.idle,
    files = ['test01.xlsx'];

  bool get inProgress => status == LamodaStatus.inProgress;
}
