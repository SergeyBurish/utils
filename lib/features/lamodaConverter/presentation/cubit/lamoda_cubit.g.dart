// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lamoda_cubit.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$LamodaStateCWProxy {
  LamodaState status(LamodaStatus status);

  LamodaState files(List<String> files);

  /// Creates a new instance with the provided field values.
  /// Passing `null` to a nullable field nullifies it, while `null` for a non-nullable field is ignored. To update a single field use `LamodaState(...).copyWith.fieldName(value)`.
  ///
  /// Example:
  /// ```dart
  /// LamodaState(...).copyWith(id: 12, name: "My name")
  /// ```
  LamodaState call({LamodaStatus status, List<String> files});
}

/// Callable proxy for `copyWith` functionality.
/// Use as `instanceOfLamodaState.copyWith(...)` or call `instanceOfLamodaState.copyWith.fieldName(value)` for a single field.
class _$LamodaStateCWProxyImpl implements _$LamodaStateCWProxy {
  const _$LamodaStateCWProxyImpl(this._value);

  final LamodaState _value;

  @override
  LamodaState status(LamodaStatus status) => call(status: status);

  @override
  LamodaState files(List<String> files) => call(files: files);

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
    Object? files = const $CopyWithPlaceholder(),
  }) {
    return LamodaState._(
      status: status == const $CopyWithPlaceholder() || status == null
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as LamodaStatus,
      files: files == const $CopyWithPlaceholder() || files == null
          ? _value.files
          // ignore: cast_nullable_to_non_nullable
          : files as List<String>,
    );
  }
}

extension $LamodaStateCopyWith on LamodaState {
  /// Returns a callable class used to build a new instance with modified fields.
  /// Example: `instanceOfLamodaState.copyWith(...)` or `instanceOfLamodaState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$LamodaStateCWProxy get copyWith => _$LamodaStateCWProxyImpl(this);
}
