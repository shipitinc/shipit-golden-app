/// Small, app-level UI constants that have no upstream shipit_ui token yet.
///
/// Where an upstream token exists use it instead (e.g. `context.space.*`,
/// `context.text.*`); these names exist so repeated literals are not scattered
/// magic numbers. `UPSTREAM_UI_GAP` candidates: shipit_ui exposes no
/// icon-size or font-weight tokens in `shipit_ui@18d1a5d6`.
library;

/// Size of small inline icons (e.g. calendar-today) beside caption text.
const double kSmallIconSize = 16;
