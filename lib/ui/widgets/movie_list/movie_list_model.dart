import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieListModel extends ChangeNotifier {
  final _apiClient = ApiClient();
  final _movies = <Movie>[];

  List<Movie> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  String _locale = '';

//настройка локализации
  Future<void> setupLocale(BuildContext context) async {
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    print(_locale);
    _dateFormat = DateFormat.yMMMMd(locale);
    _movies.clear();
    _loadMovies();
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  Future<void> _loadMovies() async {
    final movieResponse = await _apiClient.popularMovie(1, _locale);
    _movies.addAll(movieResponse.movies);
    notifyListeners();
  }
}
