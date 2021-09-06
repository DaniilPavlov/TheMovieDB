import 'package:flutter/material.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/resources/app_images.dart';
import 'package:themoviedb/widgets/auth/auth_widget.dart';
import 'package:themoviedb/widgets/main_screen/main_screen_widget.dart';
import 'package:themoviedb/widgets/movie_details/movie_details_widget.dart';
import 'package:themoviedb/widgets/movie_list/movie_list_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(backgroundColor: AppColors.mainDarkBlue),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: AppColors.mainDarkBlue,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey),
      ),
      routes: {
        '/auth': (context) => AuthWidget(),
        '/main_screen': (context) => MainScreenWidget(),
        '/main_screen/movie_details': (context) {
          final arguments = ModalRoute
              .of(context)
              ?.settings
              .arguments as Movie;
          if (arguments.id is int) {
            return MovieDetailsWidget(
              movie: arguments,
            );
          } else {
            return MovieDetailsWidget(
              movie: Movie(
                  id: 18,
                  imageName: AppImages.moviePlaceholder,
                  title: 'Oshibka',
                  time: 'time',
                  description: 'description'),
            );
          }
        },
      },
      initialRoute: '/auth',
      // onGenerateRoute: (RouteSettings settings) {
      //   return MaterialPageRoute(builder: (context) {
      //     return Scaffold(
      //       body: Center(
      //         child: Text('Navigation Error'),
      //       ),
      //     );
      //   });
      // },
    );
  }
}
