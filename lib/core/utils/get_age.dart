String getAge(String? dob) {
  if (dob == null) return "Not Found";
  DateTime birthDate = DateTime.parse(dob);
  DateTime today = DateTime.now();

  int years = today.year - birthDate.year;
  int months = today.month - birthDate.month;
  int days = today.day - birthDate.day;

  if (days < 0) {
    months -= 1;
    days += DateTime(today.year, today.month, 0).day;
  }

  if (months < 0) {
    years -= 1;
    months += 12;
  }

  return "$years Year $months Month $days Day";
}
