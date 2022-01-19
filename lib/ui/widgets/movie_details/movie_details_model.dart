import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:themoviedb/domain/client/account_api_client.dart';
import 'package:themoviedb/domain/client/api_client_exception.dart';
import 'package:themoviedb/domain/client/image_downloader.dart';
import 'package:themoviedb/domain/client/movie_api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/domain/entities/movie_details.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/library/localized_model_storage.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieDetailsPosetData {
  final String? backdropPath;
  final String? posterPath;

  MovieDetailsPosetData({this.backdropPath, this.posterPath});
}

class MovieDetailsMovieNameData {
  final String name;
  final String year;

  MovieDetailsMovieNameData({required this.name, required this.year});
}

class MovieDetailsScoreData {
  final double voteAverage;
  final String? trailerKey;

  MovieDetailsScoreData({required this.voteAverage, this.trailerKey});
}

class MovieDetailsActorData {
  final String name;
  final String character;
  final String? profilePath;
  MovieDetailsActorData({
    required this.name,
    required this.character,
    this.profilePath,
  });
}

class MovieDetailsData {
  String title = "";
  bool isLoading = true;
  String overview = "";
  String tagline = "";
  MovieDetailsPosetData posterData = MovieDetailsPosetData();
  MovieDetailsMovieNameData nameData =
      MovieDetailsMovieNameData(name: '', year: '');
  MovieDetailsScoreData scoreData = MovieDetailsScoreData(voteAverage: 0);
  String summary = "";
}

class MovieDetailsViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();
  final _movieApiClient = MovieApiClient();

  final data = MovieDetailsData();

  final int movieId;
  MovieDetails? _movieDetails;

  late DateFormat _dateFormat;
  Image? _poster;
  Image? _backDrop;
  bool _loading = false;
  late bool _isFavorite;

  bool get isFavorite => _isFavorite;

  final _localeStorage = LocalizedModelStorage();

  MovieDetailsViewModel(
    this.movieId,
  );

  MovieDetails? get movieDetails => _movieDetails;

  Image? get poster => _poster;

  Image? get backDrop => _backDrop;

  bool get isLoading => _loading;

  void updateData(MovieDetails? details, bool isFavourite) {
    data.title = details?.title ?? "Загрузка...";
    data.isLoading = details == null;
    if (details == null) {
      notifyListeners();
      return;
    }
    data.overview = details.overview ?? '';
    data.tagline = details.tagline ?? '';
    data.posterData = MovieDetailsPosetData(
        backdropPath: details.backdropPath, posterPath: details.posterPath);
    var year = details.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    data.nameData = MovieDetailsMovieNameData(name: details.title, year: year);
    final videos = details.videos.results
        .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    //чтобы отобразить видео нам нужен ключ
    final trailerKey = videos.isNotEmpty == true ? videos.first.key : null;
    data.scoreData = MovieDetailsScoreData(
        voteAverage: details.voteAverage * 10, trailerKey: trailerKey);
    data.summary = makeSummary(details);
    notifyListeners();
  }

  String makeSummary(MovieDetails details) {
    //собираем массив из слов которые надо вписать
    var summary = <String>[];
    // записываем в массив дату когда был выпущен фильм
    final releaseDate = details.releaseDate;
    if (releaseDate != null) {
      // переводим дату в стрингу и записываем в массив
      summary.add(_dateFormat.format(releaseDate));
    }
    // собираем страны
    final productionCountries = details.productionCountries;
    if (productionCountries.isNotEmpty) {
      summary.add(productionCountries.first.iso);
    }
    // Продолжительность фильма тут парсим в часы из минут
    final runtime = details.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    summary.add('${hours}h ${minutes}m');
    // Массив жанров в которых представлен фильм
    final genres = details.genres;
    if (genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genre in genres) {
        genresNames.add(genre.name);
      }
      summary.add(genresNames.join(', '));
    }
    return summary.join(' ');
  }

  Future<void> setupLocale(BuildContext context, Locale locale) async {
    _loading = true;
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    updateData(null, false);
    await loadDetails(context);
  }

  Future<Image> _downloadImage(String src) async {
    final image = Image.network(
      ImageDownloader.imageUrl(src),
      filterQuality: FilterQuality.high,
    );
    return image;
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  void onTrailerTap(BuildContext context, String trailerKey) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieTrailer,
        arguments: trailerKey);
  }

  Future<void> onFavoriteTap(BuildContext context) async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final accountId = await _sessionDataProvider.getAccountId();
    if (sessionId == null || accountId == null) return;
    try {
      _accountApiClient.markAsFavorite(
          accountId: accountId,
          sessionId: sessionId,
          mediaType: MediaType.movie,
          mediaId: movieId,
          isFavorite: !isFavorite);
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
    _isFavorite = !_isFavorite;
    notifyListeners();
  }

  Future<void> loadDetails(BuildContext context) async {
    try {
      _movieDetails =
          await _movieApiClient.movieDetails(movieId, _localeStorage.localeTag);

      final sessionId = await SessionDataProvider().getSessionId();
      if (sessionId != null) {
        _isFavorite = await _movieApiClient.isFavorite(movieId, sessionId);
      }
      updateData(_movieDetails, _isFavorite);

      final _front = _movieDetails?.posterPath;
      _front != null ? _poster = await _downloadImage(_front) : _poster = null;
      final _back = _movieDetails?.backdropPath;
      _back != null
          ? _backDrop = await _downloadImage(_back)
          : _backDrop = null;
      _loading = false;
      notifyListeners();
    } on ApiClientException catch (e) {
      _handleApiClientException(e, context);
    }
  }

// если токен авторизации устаревает, пользователя выкидывает на экран
// авторизации
  void _handleApiClientException(
      ApiClientException exception, BuildContext context) {
    switch (exception.type) {
      case ApiClientExceptionType.sessionExpired:
        _authService.logout();
        MainNavigation.resetNavigation(context);
        break;
      default:
        print(exception);
    }
  }
}
