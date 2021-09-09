import 'package:json_annotation/json_annotation.dart';
import 'package:themoviedb/domain/entity/movie.dart';

part 'popular_movie_response.g.dart';

//explicitToJson: true для того чтобы показать вложенность жсонов
//потому что в популар муви респонс находятся резалтс
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class PopularMovieResponse {
  final int page;
  //фильмы хранятся в резалтся, но список назовем мувис
  @JsonKey(name: 'results')
  final List<Movie> movies;
  final int totalResults;
  final int totalPages;

  PopularMovieResponse({
    required this.page,
    required this.movies,
    required this.totalResults,
    required this.totalPages,
  });

  factory PopularMovieResponse.fromJson(Map<String, dynamic> json) =>
      _$PopularMovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PopularMovieResponseToJson(this);
}