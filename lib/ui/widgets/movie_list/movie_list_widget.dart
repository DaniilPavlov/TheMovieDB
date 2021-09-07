import 'package:flutter/material.dart';
import 'package:themoviedb/resources/app_images.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class Movie {
  final int id;
  final String imageName;
  final String title;
  final String time;
  final String description;

  Movie(
      {required this.id,
      required this.imageName,
      required this.title,
      required this.description,
      required this.time});
}

class MovieListWidget extends StatefulWidget {
  MovieListWidget({Key? key}) : super(key: key);

  @override
  _MovieListWidgetState createState() => _MovieListWidgetState();
}

class _MovieListWidgetState extends State<MovieListWidget> {
  final _movies = [
    Movie(
      id: 1,
      imageName: AppImages.moviePlaceholder,
      title: 'Магистр Политеха',
      time: '22 May 2017',
      description: 'Something something something some something '
          'something something something',
    ),
    Movie(
      id: 2,
      imageName: AppImages.moviePlaceholder,
      title: 'KKK',
      time: '22 May 2017',
      description: 'Something something something some something '
          'something something something',
    ),
    Movie(
      id: 3,
      imageName: AppImages.moviePlaceholder,
      title: 'SSSS',
      time: '22 May 2017',
      description: 'Something something something some something '
          'something something something',
    ),
    Movie(
      id: 4,
      imageName: AppImages.moviePlaceholder,
      title: 'MMMMM',
      time: '22 May 2017',
      description: 'Something something something some something '
          'something something something',
    ),
    Movie(
      id: 5,
      imageName: AppImages.moviePlaceholder,
      title: 'FFFFFF',
      time: '22 May 2017',
      description: 'Something something something some something '
          'something something something',
    ),
  ];

  var _filteredMovies = <Movie>[];

  final _searchController = TextEditingController();

  void _searchMovies() {
    if (_searchController.text.isNotEmpty) {
      _filteredMovies = _movies.where((Movie movie) {
        ///для контейнс важен регистр, приводим к одному
        return movie.title
            .toLowerCase()
            .contains(_searchController.text.toLowerCase());
      }).toList();
    } else {
      _filteredMovies = _movies;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    ///с помощью лисенера сразу при написании названия фильма будут отсекаться
    ///неподходящие
    _filteredMovies = _movies;
    _searchController.addListener(_searchMovies);
  }

  void _onMovieTap(int index) {
    final id = _movies[index];
    print(id);
    Navigator.of(context)
        .pushNamed(MainNavigationRouteNames.movieDetails, arguments: id);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      ListView.builder(
          padding: EdgeInsets.only(top: 70),

          ///если мы что-то ввели и начали скролл - клавиатура уйдет
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: _filteredMovies.length,
          itemExtent: 163,
          itemBuilder: (BuildContext context, int index) {
            final movie = _filteredMovies[index];
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
                    Image(image: AssetImage(movie.imageName)),
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
                            movie.time,
                            style: TextStyle(color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            movie.description,
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
                    onTap: () => _onMovieTap(index),
                  ),
                )
              ]),
            );
          }),
      Padding(
          padding: const EdgeInsets.all(10),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
                labelText: 'Search',
                filled: true,
                fillColor: Colors.white.withAlpha(235),
                border: OutlineInputBorder()),
          ))
    ]);
  }
}
