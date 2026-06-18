import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/lamoda_entity.dart';
import '../../domain/usecase/lamoda_usecase.dart';

part 'lamoda_cubit.g.dart';
part 'lamoda_state.dart';

class LamodaCubit extends Cubit<LamodaState> {
  final LamodaUsecase lamodaUsecase;
  LamodaCubit({required this.lamodaUsecase}) : 
      super(LamodaState.initial()){
    _onLoad();
  }

  void onUpload() async {
    emit(state.copyWith.status(LamodaStatus.inProgress));
    final output = await lamodaUsecase.handleFiles();

    output.fold(
      ifLeft: (_) => emit(state.copyWith.status(LamodaStatus.error)),
      ifRight: (int rez) {
        emit(state.copyWith(
          status: LamodaStatus.success,
          files: ['test02.xlsx'],
        ));
      }
    );
  }

  void _onLoad () async {
    emit(state.copyWith.status(LamodaStatus.inProgress));
    final output = await lamodaUsecase.getUploadPath();

    output.fold(
      ifLeft: (_) => emit(state.copyWith.status(LamodaStatus.error)),
      ifRight: (LamodaEntity lamodaEntity) {
        emit(state.copyWith(
          status: LamodaStatus.success,
          files: [lamodaEntity.uploadPath],
        ));
      }
    );
  }
}
