import 'package:freezed_annotation/freezed_annotation.dart';

part 'program.freezed.dart';

@freezed
sealed class Program with _$Program {
  const factory Program({
    required String id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) = _Program;
}
