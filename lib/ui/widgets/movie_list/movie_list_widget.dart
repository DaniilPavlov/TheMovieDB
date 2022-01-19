import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/domain/client/image_downloader.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_model.dart';

class MovieListWidget extends StatefulWidget {
  const MovieListWidget({Key? key}) : super(key: key);

  @override
  State<MovieListWidget> createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //подписываемся на изменения языка устройства
    final locale = Localizations.localeOf(context);
    context.read<MovieListViewModel>().setupLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: const [_MovieListWidget(), _SearchWidget()]);
  }
}

class _SearchWidget extends StatelessWidget {
  const _SearchWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieListViewModel>();
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        onChanged: model.searchMovie,
        decoration: InputDecoration(
          labelText: 'Search',
          filled: true,
          fillColor: Colors.white.withAlpha(235),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _MovieListWidget extends StatelessWidget {
  const _MovieListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.watch<MovieListViewModel>();
    return ListView.builder(
      padding: const EdgeInsets.only(top: 70),

      ///если мы что-то ввели и начали скролл - клавиатура уйдет
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      itemCount: model.movies.length,
      itemExtent: 163,
      itemBuilder: (BuildContext context, int index) {
        model.showedMovieAtIndex(index);
        return _MovieListRowWidget(index: index);
      },
    );
  }
}

class _MovieListRowWidget extends StatelessWidget {
  final int index;
  const _MovieListRowWidget({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //если модель обновится, обновится весь список, поэтому делать watch для
    //каждого фильма отдельно нет смысла
    final model = context.read<MovieListViewModel>();
    final movie = model.movies[index];
    final posterPath = movie.posterPath;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Row(
            children: [
              if (posterPath != null)
                Image.network(
                  ImageDownloader.imageUrl(posterPath),
                  width: 95,
                ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      movie.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      movie.releaseDate,
                      style: const TextStyle(color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      movie.overview,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              )
            ],
          ),
        ),

        ///сама по себе карточка не кликабельна, поэтому добавляем инквел
        ///но оборачиваем его в матириал, чтобы был виден сплеш
        ///от нажатия
        Material(
          ///без color содержимое контейнера пропадает
          ///поэтому добавляем прозрачность
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => model.onMovieTap(context, index),
          ),
        )
      ]),
    );
  }
}
