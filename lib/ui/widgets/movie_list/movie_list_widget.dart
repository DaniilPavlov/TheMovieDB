import 'package:flutter/material.dart';
import 'package:themoviedb/Library/Widgets/inherited/provider.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';

import 'movie_list_model.dart';

class MovieListWidget extends StatelessWidget {
  const MovieListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.watch<MovieListModel>(context);
    if (model == null) return const SizedBox.shrink();
    return Stack(children: [
      ListView.builder(
          padding: EdgeInsets.only(top: 70),

          ///если мы что-то ввели и начали скролл - клавиатура уйдет
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: model.movies.length ?? 0,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index) {
            model.showedMovieAtIndex(index);
            final movie = model.movies[index];
            final posterPath = movie.posterPath;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.black.withOpacity(0.2)),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: Offset(0, 2))
                      ]),
                  clipBehavior: Clip.hardEdge,
                  child: Row(children: [
                    posterPath != null
                        ? Image.network(
                            ApiClient.imageUrl(posterPath),
                            width: 95,
                          )
                        : SizedBox.shrink(),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            movie.title,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            model.stringFromDate(movie.releaseDate),
                            style: TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
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
                    SizedBox(
                      width: 10,
                    )
                  ]),
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
          }),
      Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            onChanged: model.searchMovie,
            decoration: InputDecoration(
                labelText: 'Search',
                filled: true,
                fillColor: Colors.white.withAlpha(235),
                border: OutlineInputBorder()),
          ))
    ]);
  }
}
