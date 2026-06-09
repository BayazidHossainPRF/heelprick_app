
Map<String, int> calculateAge({required DateTime fromDate, DateTime? toDate}) {
  toDate ??= DateTime.now();
  int years = toDate.year - fromDate.year;
  int months = toDate.month - fromDate.month;
  int days = toDate.day - fromDate.day;

  if (days < 0) {
    final prevMonth = DateTime(fromDate.year, fromDate.month, 0);
    days += prevMonth.day; // add days in previous month
    months -= 1;
  }

  if (months < 0) {
    months += 12;
    years -= 1;
  }

  return {'years': years, 'months': months, 'days': days};
}
