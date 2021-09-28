import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/entity/movie_details.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class MovieDetailsModel extends ChangeNotifier {
  final _apiClient = ApiClient();

  final int movieId;
  MovieDetails? _movieDetails;
  String _locale = '';
  late DateFormat _dateFormat;
  Image? _poster;
  Image? _backDrop;
  bool _loading = false;
  late Color color;
  late PaletteGenerator _colorsList;

  late bool _isFavorite;

  bool get isFavorite => _isFavorite;

  MovieDetailsModel(
    this.movieId,
  );

  MovieDetails? get movieDetails => _movieDetails;

  Image? get poster => _poster;

  Image? get backDrop => _backDrop;

  bool get isLoading => _loading;

  PaletteGenerator get getColorList => _colorsList;

  Future<void> setupLocale(BuildContext context) async {
    _loading = true;
    final locale = Localizations.localeOf(context).toLanguageTag();
    if (locale == _locale) return;
    _locale = locale;
    _dateFormat = DateFormat.yMMMMd(locale);
    await loadDetails();
  }

  Future<Image> _downloadImage(String src) async {
    final image = Image.network(
      ApiClient.imageUrl(src),
      filterQuality: FilterQuality.high,
    );
    return image;
  }

  String stringFromDate(DateTime? date) =>
      date != null ? _dateFormat.format(date) : '';

  Future<void> loadDetails() async {
    _movieDetails = await _apiClient.movieDetails(movieId, _locale);

    final _front = _movieDetails?.posterPath;
    _front != null ? _poster = await _downloadImage(_front) : _poster = null;
    final _back = _movieDetails?.backdropPath;
    _back != null ? _backDrop = await _downloadImage(_back) : _backDrop = null;
    _loading = false;
    await createColor(poster);
    notifyListeners();
  }

  //загрузка цвета экрана
  Future<void> createColor(Image? img) async {
    PaletteGenerator generator;
    if (img == null) return;
    generator = await PaletteGenerator.fromImageProvider(img.image);
    if (generator.dominantColor?.color != null) {
      _colorsList = generator;
      return;
    }
    return;
  }

  void onTrailerTap(BuildContext context, String trailerKey) {
    Navigator.of(context).pushNamed(MainNavigationRouteNames.movieTrailer,
        arguments: trailerKey);
  }

}
