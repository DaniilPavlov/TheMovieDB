import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/ui/widgets/auth/auth_model.dart';
import 'package:themoviedb/ui/widgets/auth/auth_widget.dart';
import 'package:themoviedb/ui/widgets/loader/loader_view_model.dart';
import 'package:themoviedb/ui/widgets/loader/loader_widget.dart';
import 'package:themoviedb/ui/widgets/main_screen/main_screen_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_trailer_widget.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_model.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_widget.dart';
import 'package:themoviedb/ui/widgets/news_list/news_list_widget.dart';
import 'package:themoviedb/ui/widgets/serials_list/serials_list_widget.dart';

class ScreenFactory {
  Widget makeLoader() {
    //так как мы нигде не используем элемент, он сам по себе не будет грузиться
    //нужно поставить лейзи в фолс, чтобы сделать автоматическую загрузку
    return Provider(
      create: (context) => LoaderViewModel(context),
      child: const LoaderWidget(),
      lazy: false,
    );
  }

  Widget makeAuth() {
    return ChangeNotifierProvider(
      create: (_) => AuthViewModel(),
      child: const AuthWidget(),
    );
  }

  Widget makeMainScreen() {
    return const MainScreenWidget();
  }

  Widget makeMovieDetails(int movieId) {
    return ChangeNotifierProvider(
      create: (_) => MovieDetailsViewModel(movieId),
      child: const MovieDetailsWidget(),
    );
  }

  Widget makeMovieTrailer(String youTubeKey) {
    return MovieTrailerWidget(youTubeKey: youTubeKey);
  }

  Widget makeNewsList() {
    return const NewsListWidget();
  }

  Widget makeMovieList() {
    return ChangeNotifierProvider(
      create: (_) => MovieListViewModel(),
      child: const MovieListWidget(),
    );
  }

  Widget makeSerialsList() {
    return const SerialsListWidget();
  }
}
