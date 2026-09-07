/// Immutability helpers consumed by application state.
///
/// Design tokens are accessed directly via shipit_ui's canonical static API
/// (`AppColors`, `AppSpacing`, `AppTypography`, `AppRadius`, ...) — no
/// `BuildContext` token aliases are defined here (they would duplicate
/// shipit_ui and risk drift).
extension IterableExtensions<T> on Iterable<T> {
  List<T> toImmutableList() => List.unmodifiable(this);
}

extension MapExtensions<K, V> on Map<K, V> {
  Map<K, V> toImmutableMap() => Map.unmodifiable(this);
}
