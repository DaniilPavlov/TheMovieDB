import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/client/movie_api_client.dart';
import 'package:themoviedb/domain/entities/popular_movie_response.dart';

//по сути бесполезен, так как вызываем методы клиента
//сделали так, потому что этого требует архитектура
class MovieService {
  final _movieApiClient = MovieApiClient();

  Future<PopularMovieResponse> popularMovie(int page, String locale) async =>
      _movieApiClient.popularMovie(page, locale, Configuration.apiKey);

  Future<PopularMovieResponse> searchMovie(
          int page, String locale, String query) async =>
      _movieApiClient.searchMovie(page, locale, query, Configuration.apiKey);
}
