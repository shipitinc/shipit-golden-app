/// Immutability helpers consumed by application state.
extension IterableExtensions<T> on Iterable<T> {
  List<T> toImmutableList() => List.unmodifiable(this);
}

extension MapExtensions<K, V> on Map<K, V> {
  Map<K, V> toImmutableMap() => Map.unmodifiable(this);
}
