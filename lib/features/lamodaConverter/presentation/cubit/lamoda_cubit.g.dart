// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lamoda_cubit.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LamodaStateCWProxy {
  LamodaState status(LamodaStatus status);

  LamodaState filesLength(int filesLength);

  LamodaState currentFile(String currentFile);

  LamodaState currentFileInd(int currentFileInd);

  LamodaState downloadedFile(String downloadedFile);

  LamodaState errors(List<String> errors);

  LamodaState lamodaEntity(LamodaEntity lamodaEntity);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LamodaState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LamodaState(...).copyWith(id: 12, name: "My name")
  /// ```
  LamodaState call({
    LamodaStatus status,
    int filesLength,
    String currentFile,
    int currentFileInd,
    String downloadedFile,
    List<String> errors,
    LamodaEntity lamodaEntity,
  });
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLamodaState.copyWith(...)` or call `instanceOfLamodaState.copyWith.fieldName(value)` for a single field.
class _$LamodaStateCWProxyImpl implements _$LamodaStateCWProxy {
  const _$LamodaStateCWProxyImpl(this._value);

  final LamodaState _value;

  @override
  LamodaState status(LamodaStatus status) => call(status: status);

  @override
  LamodaState filesLength(int filesLength) => call(filesLength: filesLength);

  @override
  LamodaState currentFile(String currentFile) => call(currentFile: currentFile);

  @override
  LamodaState currentFileInd(int currentFileInd) =>
      call(currentFileInd: currentFileInd);

  @override
  LamodaState downloadedFile(String downloadedFile) =>
      call(downloadedFile: downloadedFile);

  @override
  LamodaState errors(List<String> errors) => call(errors: errors);

  @override
  LamodaState lamodaEntity(LamodaEntity lamodaEntity) =>
      call(lamodaEntity: lamodaEntity);

  @override
  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LamodaState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LamodaState(...).copyWith(id: 12, name: "My name")
  /// ```
  LamodaState call({
    Object? status = const $CopyWithPlaceholder(),
    Object? filesLength = const $CopyWithPlaceholder(),
    Object? currentFile = const $CopyWithPlaceholder(),
    Object? currentFileInd = const $CopyWithPlaceholder(),
    Object? downloadedFile = const $CopyWithPlaceholder(),
    Object? errors = const $CopyWithPlaceholder(),
    Object? lamodaEntity = const $CopyWithPlaceholder(),
  }) {
    return LamodaState._(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as LamodaStatus,
      filesLength:
          filesLength == const $CopyWithPlaceholder() || filesLength == null
          ? _value.filesLength
          // ignore: cast_nullable_to_non_nullable
          : filesLength as int,
      currentFile:
          currentFile == const $CopyWithPlaceholder() || currentFile == null
          ? _value.currentFile
          // ignore: cast_nullable_to_non_nullable
          : currentFile as String,
      currentFileInd:
          currentFileInd == const $CopyWithPlaceholder() ||
              currentFileInd == null
          ? _value.currentFileInd
          // ignore: cast_nullable_to_non_nullable
          : currentFileInd as int,
      downloadedFile:
          downloadedFile == const $CopyWithPlaceholder() ||
              downloadedFile == null
          ? _value.downloadedFile
          // ignore: cast_nullable_to_non_nullable
          : downloadedFile as String,
      errors: errors == const $CopyWithPlaceholder() || errors == null
          ? _value.errors
          // ignore: cast_nullable_to_non_nullable
          : errors as List<String>,
      lamodaEntity:
          lamodaEntity == const $CopyWithPlaceholder() || lamodaEntity == null
          ? _value.lamodaEntity
          // ignore: cast_nullable_to_non_nullable
          : lamodaEntity as LamodaEntity,
    );
  }
}

extension $LamodaStateCopyWith on LamodaState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLamodaState.copyWith(...)` or `instanceOfLamodaState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LamodaStateCWProxy get copyWith => _$LamodaStateCWProxyImpl(this);
}
