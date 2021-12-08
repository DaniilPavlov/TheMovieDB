//из-за проблем MOVIE DB API обрабатываем дату сами
DateTime? parseMovieDateFromString(String? rawDate) {
if (rawDate == null || rawDate.isEmpty) return null;
return DateTime.tryParse(rawDate);
}