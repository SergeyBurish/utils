import 'dart:typed_data';

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:dart_either/dart_either.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entity/lamoda_entity.dart';
import '../../domain/entity/shift_time.dart';
import '../../domain/entity/tariffs_entity.dart';
import '../../domain/entity/typedefs.dart';
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
    emit(state.copyWith.status(LamodaStatus.sourceFilesLoading));
    _clear();

    const XTypeGroup excelTypeGroup = XTypeGroup(
      label: 'Excel',
      extensions: <String>['xls', 'xlsx'],
      uniformTypeIdentifiers: <String>['public.xlsx'],
    );

    final List<XFile> files = await openFiles(
      acceptedTypeGroups: <XTypeGroup>[excelTypeGroup],
    );

    if (files.isEmpty) {
      emit(state.copyWith.status(LamodaStatus.idle));
      _clear();
      return;
    }

    emit(state.copyWith.filesLength(files.length));

    for (int i = 0; i < files.length; i++) {
      emit(state.copyWith(
        status: LamodaStatus.fileHandling,
        currentFile: files[i].name,
        currentFileInd: i,
      ));

      try {
        final Uint8List bytes = await files[i].readAsBytes();
        final Either<String, LamodaEntity> output = await lamodaUsecase.handleExcelFile(bytes);
        
        output.fold(
          ifLeft: (String error) {
            state.errors.add('${files[i].name}: $error');
            emit(state.copyWith.status(LamodaStatus.fileHandling));
          },
          ifRight: (LamodaEntity lamodaEntity) {
            state.lamodaEntity.shifts.addAll(lamodaEntity.shifts);
            state.lamodaEntity.worksSet.addAll(lamodaEntity.worksSet);
            state.lamodaEntity.loginsSet.addAll(lamodaEntity.loginsSet);
            emit(state.copyWith.status(LamodaStatus.fileHandling));
          },
        );
      } on Exception catch (e) {
        state.errors.add('${files[i].name}: $e');
        emit(state.copyWith.status(LamodaStatus.fileHandling));
      }

      emit(state.copyWith.status(LamodaStatus.fileHandling));
    }

    emit(state.copyWith.status(state.lamodaEntity.shifts.isNotEmpty
      ? LamodaStatus.filesHandled
      : LamodaStatus.allFilesErrors));
  }

  void onDownload() async {
    emit(state.copyWith.status(LamodaStatus.fileDownloading));

    final Either<String, String> output = await lamodaUsecase.downloadExcelFile(state.lamodaEntity, state.lamodaTariffs);
    output.fold(
      ifLeft: (String error) {
        state.errors.clear();
        state.errors.add(error);
        emit(state.copyWith.status(LamodaStatus.error));
      },
      ifRight: (String downloadedFile) {
        emit(state.copyWith(
          status: LamodaStatus.fileDownloaded,
          downloadedFile: downloadedFile,
        ));
      },
    );
  }

  void onUploadTariffs() async {
    emit(state.copyWith.status(LamodaStatus.tariffsLoading));

    const XTypeGroup excelTypeGroup = XTypeGroup(
      label: 'Excel',
      extensions: <String>['xls', 'xlsx'],
      uniformTypeIdentifiers: <String>['public.xlsx'],
    );

    final XFile? file = await openFile(
      acceptedTypeGroups: <XTypeGroup>[excelTypeGroup],
    );

    if (file == null) {
      emit(state.copyWith.status(LamodaStatus.idle));
      return;
    }

    try {
      final Uint8List bytes = await file.readAsBytes();
      final Either<String, TariffsEntity> output = await lamodaUsecase.handleTariffsFile(bytes);
      output.fold(
        ifLeft: (String error) {
          state.errors.add('${file.name}: $error');
          emit(state.copyWith.status(LamodaStatus.error));
        },
        ifRight: (TariffsEntity tariffsEntity) {
          state.lamodaTariffs.addAll(tariffsEntity.lamodaTariffs);
          state.lamodaEntity.worksSet.addAll(tariffsEntity.worksSet);
          emit(state.copyWith.status(LamodaStatus.tariffsLoaded));
        },
      );
    } on Exception catch (e) {
      state.errors.clear();
      state.errors.add('${file.name}: $e');
      emit(state.copyWith.status(LamodaStatus.error));
    }
  }

  void onDownloadTariffs() async {
    emit(state.copyWith.status(LamodaStatus.fileDownloading));

    final Either<String, String> output = await lamodaUsecase.downloadTariffsExcelFile(
      state.lamodaTariffs,
      state.lamodaEntity.worksSet,
    );

    output.fold(
      ifLeft: (String error) {
        state.errors.clear();
        state.errors.add(error);
        emit(state.copyWith.status(LamodaStatus.error));
      },
      ifRight: (String downloadedFile) {
        emit(state.copyWith(
          status: LamodaStatus.tariffsDownloaded,
          downloadedFile: downloadedFile,
        ));
      },
    );
  }

  void _onLoad () async {
  }

  void _clear () async {
    state.errors.clear();
    state.lamodaEntity.shifts.clear();
    state.lamodaEntity.worksSet.clear();
  }
}
