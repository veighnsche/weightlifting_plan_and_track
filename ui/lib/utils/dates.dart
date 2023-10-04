int sortByDayOfWeek(dynamic a, dynamic b) {
  int today = DateTime.now().weekday - 1; // 0 = Monday, 6 = Sunday

  // Both are today's workouts or both don't have a dayOfWeek
  if ((a.dayOfWeek == today && b.dayOfWeek == today) ||
      (a.dayOfWeek == null && b.dayOfWeek == null)) {
    return 0;
  }
  // 'a' is today's workout
  if (a.dayOfWeek == today) {
    return -1;
  }
  // 'b' is today's workout
  if (b.dayOfWeek == today) {
    return 1;
  }
  // 'a' doesn't have a dayOfWeek
  if (a.dayOfWeek == null) {
    return 1;
  }
  // 'b' doesn't have a dayOfWeek
  if (b.dayOfWeek == null) {
    return -1;
  }
  // Both have a dayOfWeek but neither is today's workout
  return a.dayOfWeek!.compareTo(b.dayOfWeek!);
}


String getDayOfWeekName(int? dayOfWeek) {
  if (dayOfWeek == null) {
    return 'None';
  }

  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  return daysOfWeek[dayOfWeek];
}