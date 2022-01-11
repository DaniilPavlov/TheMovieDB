import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/Theme/app_colors.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_main_info_widget.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_screen_cast_widget.dart';

class MovieDetailsWidget extends StatefulWidget {
  const MovieDetailsWidget({Key? key}) : super(key: key);

  @override
  _MovieDetailsWidgetState createState() => _MovieDetailsWidgetState();
}

class _MovieDetailsWidgetState extends State<MovieDetailsWidget> {
  @override
  void didChangeDependencies() {
    //получаем нашу модель и выполняем сетап локаль и таким
    //образом настраиваем локаль и подписываемся на измениние локали
    super.didChangeDependencies();
    //Future.microtask - штука специально для провайдера, чтобы вызов
    //notifylisteners() во время build не ломал приложение
    Future.microtask(() => context.read<MovieDetailsModel>().setupLocale(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const _TitleWidget(),
      ),
      // убираем боди в отдельный виджет для того чтобы не отображались даннные
      // пока идет загрузка экрана
      body: const _BodyWidget(),
    );
  }
}

class _BodyWidget extends StatelessWidget {
  const _BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLoading =
        context.select((MovieDetailsModel model) => model.data.isLoading);
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return ColoredBox(
      color: AppColors.blackBackgroundMovieDetail,
      child: ListView(
        children: const [
          MovieDetailsMainInfoWidget(),
          MovieDetailsMainScreenCastWidget(),
        ],
      ),
    );
  }
}

// этот виджет должен быть внизу так как при изменении
// его в дереве оно всё перестроится а это не надо
class _TitleWidget extends StatelessWidget {
  const _TitleWidget({
    Key? key,
  }) : super(key: key);

// как только моделька меняется - меняется весь экран, а так как
// виджет перенесен отдельно аппбар и скаффолд перезагружаться не будут
  @override
  Widget build(BuildContext context) {
    final title = context.select((MovieDetailsModel model) => model.data.title);
    return Text(title);
  }
}
