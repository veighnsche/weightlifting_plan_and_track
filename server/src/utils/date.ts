export function sortByDayOfWeek(a: { day_of_week?: number | null }, b: { day_of_week?: number | null }): number {
  const today: number = new Date().getDay() - 1; // 0 = Monday, 6 = Sunday

  // Both are today's workouts or both don't have a dayOfWeek
  if ((a.day_of_week === today && b.day_of_week === today) ||
    (a.day_of_week == null && b.day_of_week == null)) {
    return 0;
  }
  // 'a' is today's workout
  if (a.day_of_week === today) {
    return -1;
  }
  // 'b' is today's workout
  if (b.day_of_week === today) {
    return 1;
  }
  // 'a' doesn't have a dayOfWeek
  if (a.day_of_week == null) {
    return 1;
  }
  // 'b' doesn't have a dayOfWeek
  if (b.day_of_week == null) {
    return -1;
  }
  // Both have a dayOfWeek but neither is today's workout
  return a.day_of_week! - b.day_of_week!;
}
