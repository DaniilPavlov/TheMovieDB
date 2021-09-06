import 'package:flutter/material.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/widgets/movie_list/movie_list_widget.dart';

import 'movie_details_main_info_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  final Movie movie;
  const MovieDetailsWidget({Key? key, required this.movie}) : super(key: key);

  @override
  _MovieDetailsWidgetState createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movie.title),
      ),
      body: ColoredBox(
        color: AppColors.blackBackgroundMovieDetail,
        child: ListView(
          children: [
            MovieDetailsMainInfoWidget(),
            // MovieDetailsMainScreenCastWidget(),
          ],
        ),
      ),
    );
  }
}