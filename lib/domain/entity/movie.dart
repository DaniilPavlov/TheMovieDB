import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

//переводит поля в снейк кейс когда парсит json
//тут поля написаны в кемл кейс
//пример: posterPath = poster_path , releaseDate = release_date
@JsonSerializable(fieldRename: FieldRename.snake)
class Movie {
  //либо можно над каждым полем прописывать ключ
  // @JsonKey(name: 'poster_path')
  final String? posterPath;
  final bool adult;
  final String overview;

  //release_date format = "2016-06-03"
  //но на сайте иногда бывает пустая строка в дате, поэтому добавляем ключ
  @JsonKey(fromJson: _parseMovieDateFromString)
  final DateTime? releaseDate;
  final List<int> genreIds;
  final int id;
  final String originalTitle;
  final String originalLanguage;
  final String title;
  final String? backdropPath;
  final double popularity;
  final int voteCount;
  final bool video;
  final double voteAverage;

  Movie({
    required this.posterPath,
    required this.adult,
    required this.overview,
    required this.releaseDate,
    required this.genreIds,
    required this.id,
    required this.originalTitle,
    required this.originalLanguage,
    required this.title,
    required this.backdropPath,
    required this.popularity,
    required this.voteCount,
    required this.video,
    required this.voteAverage,
  });

  //из-за проблем MOVIE DB API обрабатываем дату сами
  static DateTime? _parseMovieDateFromString(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return null;
    return DateTime.tryParse(rawDate);
  }

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
