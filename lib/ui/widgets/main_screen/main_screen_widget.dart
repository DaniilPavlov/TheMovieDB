import 'package:flutter/material.dart';
import 'package:themoviedb/Library/Widgets/inherited/provider.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_model.dart';
import 'package:themoviedb/ui/widgets/movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;
  final movieListModel = MovieListModel();

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //через этот метод прогружаем первую страницу фильмов
    movieListModel.setupLocale(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TMDB'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'News'),
          BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Films'),
          BottomNavigationBarItem(icon: Icon(Icons.tv), label: 'Series'),
        ],
        onTap: onSelectTab,
      ),

      ///сразу все прогружаем и храним 3 страницы, не делаем лишних
      ///запросов в сеть, но задействуем много памяти
      body: IndexedStack(
        index: _selectedTab,
        children: [
          ExamplePaletteGenerator(),
          NotifierProvider(
            create: () => movieListModel,
            child: const MovieListWidget(),
            //указываем что виджет управляется не сам
            isManagingModel: false,
          ),
          const SerialsListWidget(),
        ],
      ),
    );
  }
}

class ExamplePaletteGenerator extends StatefulWidget {
  const ExamplePaletteGenerator({
    Key? key,
  }) : super(key: key);

  @override
  _ExamplePaletteGeneratorState createState() =>
      _ExamplePaletteGeneratorState();
}

class _ExamplePaletteGeneratorState extends State<ExamplePaletteGenerator> {
  List<Image> images = [
    Image.network(
      'https://pbs.twimg.com/media/D9MPesKXoAEhtdt.jpg:large',
      filterQuality: FilterQuality.high,
    ),
    Image.network(
      'https://avatars.mds.yandex.net/get-kinopoisk-blog-post-thumb/40130/59fdb7199d77ef1505da63f4d8581318/orig',
      filterQuality: FilterQuality.high,
    ),
  ];

  // List<PaletteColor> colors = [];
  @override
  void initState() {
    super.initState();
    // _updatePalettes();
  }

  // _updatePalettes() async {
  //   for (var image in images) {
  //     final PaletteGenerator generator =
  //         await PaletteGenerator.fromImageProvider(image.image);
  //     if (generator == null) return;
  //     colors.add(generator.lightMutedColor != null
  //         ? generator.lightMutedColor
  //         : PaletteColor(Colors.blue, 2));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: ListView(
        children: images,
      ),
    );
  }
}

class SerialsListWidget extends StatelessWidget {
  const SerialsListWidget({
    Key? key,
  }) : super(key: key);

  void logOut(BuildContext context) {
    final provider = SessionDataProvider();
    provider.setSessionId(null);
    Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: Text('log out'),
      onPressed: () => logOut(context),
    ));
  }
}
