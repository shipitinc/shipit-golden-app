import 'package:freezed_annotation/freezed_annotation.dart';

part 'household.freezed.dart';

@freezed
sealed class Household with _$Household {
  const factory Household({
    required String id,
    required String name,
    required String ownerId,
    required DateTime createdAt,
  }) = _Household;
}
