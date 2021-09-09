import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie.dart';
import 'package:themoviedb/domain/entity/popular_movie_response.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movies = <Movie>[];

  List<Movie> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  String _locale = '';

  late int _currentPage;
  late int _totalPage;

  //когда мы грузим страницу не надо вызывать следующую загрузку
  var _isLoadingInProgress = false;

  //настройка локализации, производим сразу при попадании в приложение
  //после авторизации
  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await resetList();
  }

  Future<void> resetList() async {
    _movies.clear();
    _currentPage = 0;
    _totalPage = 1;
    await _loadNextPage();
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  Future<PopularMovieResponse> _loadMovies(int nextPage, String locale) async {
    return _apiClient.popularMovie(nextPage, locale);
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = !_isLoadingInProgress;
    final _nextPage = _currentPage + 1;
    try {
      final responseMovies = await _loadMovies(_nextPage, _locale);
      _movies.addAll(responseMovies.movies);
      _currentPage = responseMovies.page;
      _totalPage = responseMovies.totalPages;
      print(_totalPage);
      _isLoadingInProgress = !_isLoadingInProgress;
      notifyListeners();
    } catch (e) {
      _isLoadingInProgress = !_isLoadingInProgress;
    }
  }

  void showedMovieAtIndex(int index) {
    //когда список прогружженых фильмов подходит к концу, начинаем грузить
    //новые 20 и так далее
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}
