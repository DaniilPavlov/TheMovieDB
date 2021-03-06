import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:themoviedb/domain/client/image_downloader.dart';
import 'package:themoviedb/ui/widgets/movie_details/movie_details_model.dart';

class MovieDetailsMainScreenCastWidget extends StatelessWidget {
  const MovieDetailsMainScreenCastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Актерский состав сериала',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(
              height: 260,
              child: Scrollbar(
                child: _ActorListWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {},
                child: const Text(
                  'Полный актерский и съёмочный состав',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActorListWidget extends StatelessWidget {
  const _ActorListWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsViewModel>();
    var cast = model.movieDetails?.credits.cast;
    if (cast == null || cast.isEmpty) return const SizedBox.shrink();
    cast.sort((a, b) => b.popularity.compareTo(a.popularity));
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: cast.length < 21 ? cast.length : 20,
      itemExtent: 120,
      itemBuilder: (BuildContext context, int index) {
        return _ActorListItemWidget(
          actroIndex: index,
        );
      },
    );
  }
}

class _ActorListItemWidget extends StatelessWidget {
  const _ActorListItemWidget({
    Key? key,
    required this.actroIndex,
  }) : super(key: key);
  final int actroIndex;
  @override
  Widget build(BuildContext context) {
    final model = context.read<MovieDetailsViewModel>();
    //если бы модели не существовало, мы бы отлетели выше, поэтому
    //ставим ! а не ?
    final actor = model.movieDetails!.credits.cast[actroIndex];
    final profilePath = actor.profilePath;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black.withOpacity(0.2),
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            profilePath != null
                ? Image.network(ImageDownloader.imageUrl(profilePath))
                : const SizedBox.shrink(),
            Padding(
              padding: const EdgeInsets.only(left: 5, top: 5, right: 5),
              child: Text(
                actor.name,
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Text(
                  actor.character,
                  overflow: TextOverflow.fade,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                  maxLines: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
