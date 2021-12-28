import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/client/network_client.dart';
import 'package:themoviedb/domain/entities/movie_details.dart';
import 'package:themoviedb/domain/entities/popular_movie_response.dart';

class MovieApiClient {
  final _networkClient = NetworkClient();

  Future<PopularMovieResponse> popularMovie(
    int page,
    String locale,
    String apiKey,
  ) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/movie/popular',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'page': page.toString(),
        'language': locale,
      },
    );
    return result;
  }

  // Поиск для него подходит такая же обработка как и для популярных фильмов
  // так что будем использовать и ее модель
  Future<PopularMovieResponse> searchMovie(
      int page, String locale, String query, String apiKey) async {
    PopularMovieResponse parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = PopularMovieResponse.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/search/movie',
      parser,
      <String, dynamic>{
        'api_key': apiKey,
        'language': locale,
        'query': query,
        'page': page.toString(),
        'include_adult': true.toString(),
      },
    );
    return result;
  }

  // параметры которые принимает фьюча написана на странице с tmdb get movie
  // муви айди и язык
  Future<MovieDetails> movieDetails(
    int movieId,
    String locale,
  ) async {
    MovieDetails parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = MovieDetails.fromJson(jsonMap);
      return response;
    }

    final result = _networkClient.get(
      '/movie/$movieId',
      parser,
      <String, dynamic>{
        //нам нужно отправить доп запрос, но мы може к запросу фильма добавить
        //аппенд ту респонс и добавить еще запрос, чтобы не создавать
        //2 отдельных запроса
        'append_to_response': 'credits,videos',
        'api_key': Configuration.apiKey,
        'language': locale,
      },
    );
    return result;
  }

  ///для выяснения отмечен фильм или нет добавляем айди сессии
  Future<bool> isFavorite(
    int movieId,
    String sessionId,
  ) async {
    bool parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final response = jsonMap['favorite'] as bool;
      return response;
    }

    final result = _networkClient.get(
      '/movie/$movieId/account_states',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }
}


///statusCode 30 - wrong login or password
///statusCode 7 - invalid API key
///statusCode 33 - invalid request token