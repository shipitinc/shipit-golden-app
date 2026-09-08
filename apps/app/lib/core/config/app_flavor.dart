/// Supported build flavors.
///
/// Each flavor maps to an Android product flavor and an iOS Xcode scheme.
/// The active flavor is determined at compile time by the `FLAVOR` dart-define
/// (defaults to [development] when unset).
enum AppFlavor { development, qa, production }
