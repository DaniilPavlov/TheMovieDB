import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/domain/entities/movie_details_credits.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/custom_progress_bar_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: const [
        _TopPosterWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummeryWidget(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: _ReviewWidget(),
        ),
      ],
    );
  }
}

class _TopPosterWidget extends StatelessWidget {
  const _TopPosterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieDetailsModel>();
    final posterData =
        context.select((MovieDetailsModel model) => model.data.posterData);
    if (posterData.posterPath == null) return const SizedBox.shrink();
    // обернули стек в аспект ратио для того, чтобы страница не прыгала
    // после загрузки инфомарции. Мы сразу выделяем место на экране
    // под изображение. Ратио высчитан сам (1.8)
    // на эмуляторах разных размеров подстроится без проблем
    return AspectRatio(
      aspectRatio: 390 / 220,
      child: Stack(
        //  fit: StackFit.loose,
        children: [
          ShaderMask(
            //добавление краски на топ изображение фильма
            shaderCallback: (rect) {
              return const LinearGradient(
                colors: [
                  Colors.black,
                  Colors.transparent,
                ],
                stops: [0.5, 0.8],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(
                Rect.fromLTRB(rect.width, rect.height, 0, 0),
              );
            },
            blendMode: BlendMode.dstIn,
            child: model.backDrop,
          ),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: Container(
              child: model.poster,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton(
              icon: Icon(model.isFavorite == true
                  ? Icons.favorite
                  : Icons.favorite_border_sharp),
              onPressed: () => model.onFavoriteTap(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data = context.select((MovieDetailsModel model) => model.data.nameData);
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: data.name,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 17,
              ),
            ),
            TextSpan(
                text: data.year,
                style: const TextStyle(
                    color: AppColors.summaryDateMovieDetail,
                    fontWeight: FontWeight.w400,
                    fontSize: 14)),
          ],
        ),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _ScoreWidget extends StatelessWidget {
  const _ScoreWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data =
        context.select((MovieDetailsModel model) => model.data.scoreData);
    final trailerKey = data.trailerKey;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () {},
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: RadialPercentWidget(
                      child: Text(
                        data.voteAverage.toStringAsFixed(0),
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                      percent: data.voteAverage,
                      fillColor: AppColors.progressBarBackground,
                      lineWidth: 3,
                    ),
                  ),
                ),
                const Text(
                  '''User
Score''',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 15,
            color: Colors.grey,
          ),
          if (trailerKey != null)
            TextButton(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () => Navigator.of(context).pushNamed(
                  MainNavigationRouteNames.movieTrailer,
                  arguments: trailerKey),
              child: Row(
                children: const [
                  Icon(
                    Icons.arrow_right_sharp,
                  ),
                  Text(
                    'Play',
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final summary =
        context.select((MovieDetailsModel model) => model.data.summary);

    return Center(
      child: ColoredBox(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            summary,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

class _ReviewWidget extends StatelessWidget {
  const _ReviewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsModel>();

    final overview = model.data.overview;
    final tagLine = model.data.tagline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tagLine == ''
            ? Container()
            : Text(
                tagLine,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Обзор',
            style: TextStyle(
                fontSize: 21, fontWeight: FontWeight.w600, color: Colors.white),
          ),
        ),
        overview == ''
            ? const SizedBox.shrink()
            : Text(
                overview,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
        const Padding(
          padding: EdgeInsets.only(top: 30),
          child: _DirectorsWidget(),
        )
      ],
    );
  }
}

class _DirectorsWidget extends StatelessWidget {
  const _DirectorsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var crew = context
        .select((MovieDetailsModel model) => model.movieDetails?.credits.crew);
    //если нет актеров
    if (crew == null || crew.isEmpty) return const SizedBox.shrink();
    //сортировка по популярности
    crew.sort((a, b) => b.popularity.compareTo(a.popularity));
    //выводим лишь главных актеров
    //саблист копирует до финального НЕ включительно
    if (crew.length > 4) crew = crew.sublist(0, 4);
    final crewWidget = crew
        .map((employee) => EmployeeWidget(
              employee: employee,
            ))
        .toList();
    return SizedBox(
      height: 160,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(10),
        childAspectRatio: 2,
        crossAxisCount: 2,
        children: crewWidget,
      ),
    );
  }
}

class EmployeeWidget extends StatelessWidget {
  const EmployeeWidget({
    Key? key,
    required this.employee,
  }) : super(key: key);

  final Employee employee;
  @override
  Widget build(BuildContext context) {
    const nameStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: AppColors.titleColorMovieDetail,
    );
    const creatorStyle = TextStyle(
      fontSize: 14,
      color: AppColors.titleColorMovieDetail,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          employee.job,
          overflow: TextOverflow.ellipsis,
          style: creatorStyle,
        ),
        Text(
          employee.name,
          style: nameStyle,
        )
      ],
    );
  }
}
