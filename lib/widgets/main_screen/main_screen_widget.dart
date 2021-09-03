import 'package:flutter/material.dart';
import 'package:themoviedb/widgets/movie_list/movie_list_widget.dart';

class MainScreenWidget extends StatefulWidget {
  const MainScreenWidget({Key? key}) : super(key: key);

  @override
  _MainScreenWidgetState createState() => _MainScreenWidgetState();
}

class _MainScreenWidgetState extends State<MainScreenWidget> {
  int _selectedTab = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: News'),
    MovieListWidget(),
    Text('Index 2: Series'),
  ];

  void onSelectTab(int index) {
    if (_selectedTab == index) return;
    setState(() {
      _selectedTab = index;
    });
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
        body: Center(
          child: _widgetOptions[_selectedTab],
        ));
  }
}
