import 'package:flutter/material.dart';
import 'package:themoviedb/Library/Widgets/inherited/provider.dart';
import 'package:themoviedb/Theme/app_colors.dart';

import '../custom_progress_bar_widget.dart';
import 'movie_details_model.dart';

class MovieDetailsMainInfoWidget extends StatelessWidget {
  const MovieDetailsMainInfoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _TopPosterWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: _MovieNameWidget(),
        ),
        _ScoreWidget(),
        _SummeryWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);
    if (model?.backDrop == null) return SizedBox.shrink();
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
              return LinearGradient(
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
            child: model?.backDrop,
          ),
          Positioned(
            top: 20,
            left: 20,
            bottom: 20,
            child: Container(
              child: model?.poster,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LinearGradientWidget extends StatelessWidget {
  const LinearGradientWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.blackBackgroundMovieDetail,
            Colors.transparent,
          ],
          stops: [0.2, 0.7],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}

class _MovieNameWidget extends StatelessWidget {
  const _MovieNameWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);
    var year = model?.movieDetails?.releaseDate?.year.toString();
    year = year != null ? ' ($year)' : '';
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: model?.movieDetails?.title ?? '',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                  color: AppColors.titleColorMovieDetail),
            ),
            TextSpan(
                text: year,
                style: TextStyle(
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
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);
    final score = model?.movieDetails?.voteAverage;
    // final videos = model?.movieDetails?.videos.results
    //     .where((video) => video.type == 'Trailer' && video.site == 'YouTube');
    // final trailerKey = videos?.isNotEmpty == true ? videos?.first.key : null;
    final trailerKey = 1;
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
                        score != null
                            ? '${(10 * score).toInt().toString()}%'
                            : '',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                      percent: score != null ? score * 10 : 88,
                      fillColor: AppColors.progressBarBackground,
                      //freeColor: AppColors.freeLine,
                      lineWidth: 3,
                      //lineColor: AppColors.line,
                    ),
                  ),
                ),
                Text(
                  '''User
Score''',
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: model?.getColorList.dominantColor?.bodyTextColor,
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
          trailerKey != null
              ? TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: () {},
                  // onPressed: () => model?.onTrailerTap(context, trailerKey),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_right_sharp,
                        color: model?.getColorList.dominantColor?.bodyTextColor,
                      ),
                      Text(
                        'Play',
                        style: TextStyle(
                          color:
                              model?.getColorList.dominantColor?.bodyTextColor,
                        ),
                      ),
                    ],
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class _SummeryWidget extends StatelessWidget {
  const _SummeryWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);
    if (model == null) return const SizedBox.shrink();
    //собираем массив из слов которые надо вписать
    var summary = <String>[];
    // записываем в массив дату когда был выпущен фильм
    final releaseDate = model.movieDetails?.releaseDate;
    if (releaseDate != null) {
      // переводим дату в стрингу и записываем в массив
      summary.add(model.stringFromDate(releaseDate));
    }
    // собираем страны
    final productionCountries = model.movieDetails?.productionCountries;
    if (productionCountries != null && productionCountries.isNotEmpty) {
      summary.add(productionCountries.first.iso);
    }
    // Продолжительность фильма тут парсим в часы из минут
    final runtime = model.movieDetails?.runtime ?? 0;
    final duration = Duration(minutes: runtime);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    summary.add('${hours}h ${minutes}m');
    // Массив жанров в которых представлен фильм
    final genres = model.movieDetails?.genres;
    if (genres != null && genres.isNotEmpty) {
      var genresNames = <String>[];
      for (var genre in genres) {
        genresNames.add(genre.name);
      }
      summary.add(genresNames.join(', '));
    }

    return Center(
      child: ColoredBox(
        color: model.getColorList.dominantColor?.bodyTextColor ?? Colors.grey,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Text(
            summary.join(' '),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: model.getColorList.dominantColor?.color,
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
    final model = NotifierProvider.watchOnModel<MovieDetailsModel>(context);

    final overview = model?.movieDetails?.overview ?? '';
    final tagLine = model?.movieDetails?.tagline ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tagLine == ''
            ? Container()
            : Text(
                tagLine,
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: model?.getColorList.darkVibrantColor?.bodyTextColor,
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400),
              ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Обзор',
            style: TextStyle(
                color: model?.getColorList.darkVibrantColor?.bodyTextColor,
                fontSize: 21,
                fontWeight: FontWeight.w600),
          ),
        ),
        overview == ''
            ? SizedBox.shrink()
            : Text(
                overview,
                style: TextStyle(
                  fontSize: 16,
                  color: model?.getColorList.darkVibrantColor?.bodyTextColor,
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dan Harmon',
                      style: TextStyle(
                        color: AppColors.titleColorMovieDetail,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Создатель',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.titleColorMovieDetail,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Justin Roiland',
                      style: TextStyle(
                        color: AppColors.titleColorMovieDetail,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Создатель',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.titleColorMovieDetail,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
