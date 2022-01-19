import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:themoviedb/Library/paginator.dart';
import 'package:themoviedb/domain/entities/movie.dart';
import 'package:themoviedb/domain/services/movie_service.dart';
import 'package:themoviedb/library/localized_model_storage.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieListRowData {
  final int id;
  final String? posterPath;
  final String title;
  final String releaseDate;
  final String overview;

  MovieListRowData({
    required this.id,
    required this.posterPath,
    required this.title,
    required this.releaseDate,
    required this.overview,
  });
}

class MovieListViewModel extends ChangeNotifier {
  final _movieService = MovieService();

  //пагинаторы хранят в себе прогресс загруженных страниц
  //и отвечают за загрузку следующих страниц
  late final Paginator<Movie> _popularMoviePaginator;
  late final Paginator<Movie> _searchMoviePaginator;
  List<MovieListRowData> _movies = <MovieListRowData>[];

  List<MovieListRowData> get movies => List.unmodifiable(_movies);
  late DateFormat _dateFormat;
  final _localeStorage = LocalizedModelStorage();

  // в зависимости от того есть ли это поле мы менеям наше состояние
  String? _searchQuery;

  //каждое нажатие клавиши провоцирует запрос в инет на фильмы это не очень хорошо
  //чтобы это избежать нужен таймер
  Timer? searchDelay;

  bool get isSearchMode {
    return _searchQuery != null && _searchQuery!.isNotEmpty;
  }

//в чем фишка пагинаторов:
//при переходе в поиск и выходе из него, прогресс обычных загруженных
//фильмов не сбрасывается, их не нужно снова грузить
  MovieListViewModel() {
    _popularMoviePaginator = Paginator<Movie>((page) async {
      final result =
          await _movieService.popularMovie(page, _localeStorage.localeTag);
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
    _searchMoviePaginator = Paginator<Movie>((page) async {
      final result = await _movieService.searchMovie(
          page, _localeStorage.localeTag, _searchQuery ?? "");
      return PaginatorLoadResult(
          data: result.movies,
          currentPage: result.page,
          totalPage: result.totalPages);
    });
  }

  //настройка локализации, производим сразу при попадании в приложение
  //после авторизации
  Future<void> setupLocale(Locale locale) async {
    if (!_localeStorage.updateLocale(locale)) return;
    _dateFormat = DateFormat.yMMMMd(_localeStorage.localeTag);
    await resetList();
  }

  Future<void> resetList() async {
    await _popularMoviePaginator.reset();
    await _searchMoviePaginator.reset();
    _movies.clear();
    await _loadNextPage();
  }

  MovieListRowData _makeRowData(Movie movie) {
    final releaseDate =
        movie.releaseDate != null ? _dateFormat.format(movie.releaseDate!) : '';
    return MovieListRowData(
        id: movie.id,
        posterPath: movie.posterPath,
        title: movie.title,
        releaseDate: releaseDate,
        overview: movie.overview);
  }

  void onMovieTap(BuildContext context, int index) {
    final id = _movies[index].id;
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  Future<void> _loadNextPage() async {
    if (isSearchMode) {
      await _searchMoviePaginator.loadNextPage();
      _movies = _searchMoviePaginator.data.map(_makeRowData).toList();
    } else {
      await _popularMoviePaginator.loadNextPage();
      _movies = _popularMoviePaginator.data.map(_makeRowData).toList();
    }
    notifyListeners();
  }

  Future<void> searchMovie(String text) async {
    // если не добавить кэнсел, таймер будет вызываться столько раз,
    // сколько букв в слове, а так при вводе новой буквы
    // мы отменяем таймер и потом по новой его запускаем
    searchDelay?.cancel();
    searchDelay = Timer(const Duration(milliseconds: 200), () async {
      final searchQuery = text.isNotEmpty ? text : null;
      if (_searchQuery == searchQuery) return;
      _searchQuery = searchQuery;
      _movies.clear();
      if (isSearchMode) {
        await _searchMoviePaginator.reset();
      }
      _loadNextPage();
    });
  }

  void showedMovieAtIndex(int index) {
    //когда список прогружженых фильмов подходит к концу, начинаем грузить
    //новые 20 и так далее
    if (index < _movies.length - 1) return;
    _loadNextPage();
  }
}
