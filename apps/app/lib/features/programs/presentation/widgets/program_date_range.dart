/// Formats a program date range as `d/m/yyyy - d/m/yyyy`.
String formatProgramDateRange(DateTime start, DateTime end) {
  return '${_formatDate(start)} - ${_formatDate(end)}';
}

String _formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
