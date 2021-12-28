class PaginatorLoadResult<T> {
  final List<T> data;
  final int currentPage;
  final int totalPage;

  PaginatorLoadResult({
    required this.data,
    required this.currentPage,
    required this.totalPage,
  });
}

typedef PaginatorLoad<T> = Future<PaginatorLoadResult<T>> Function(int);

class Paginator<T> {
  final _data = <T>[];
  late int _currentPage;
  late int _totalPage;
  //когда мы грузим страницу не надо вызывать следующую загрузку
  var _isLoadingInProgress = false;
  final PaginatorLoad<T> load;

  List<T> get data => _data;

  Paginator(this.load);

  Future<void> loadNextPage() async {
    if (_isLoadingInProgress || _currentPage >= _totalPage) return;
    _isLoadingInProgress = !_isLoadingInProgress;
    final nextPage = _currentPage + 1;
    try {
      final result = await load(nextPage);
      _data.addAll(result.data);
      _currentPage = result.currentPage;
      _totalPage = result.totalPage;
      print('number of films is $_totalPage');
      _isLoadingInProgress = !_isLoadingInProgress;
    } catch (e) {
      _isLoadingInProgress = !_isLoadingInProgress;
    }
  }

  Future<void> reset() async {
    _data.clear();
    _currentPage = 0;
    _totalPage = 1;
    await loadNextPage();
  }
}
