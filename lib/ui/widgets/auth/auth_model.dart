import 'package:flutter/material.dart';
import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  //Указать от кого наследуется
  final loginTextController = TextEditingController(text: 'Daniil_Pavlov');
  final passwordTextController = TextEditingController();

  String? _errorMessage;

  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;

  bool get canStartAuth => !_isAuthProgress;

  bool get isAuthProgress => _isAuthProgress;

  // String? _sessionId;
// добавляем метод из apiclient
  final _apiClient = ApiClient();
  final _sessionDataProvider = SessionDataProvider();

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (login.isEmpty || password.isEmpty) {
      print('auth login and password not secure');
      _errorMessage = "Заполните логин и пароль";
      notifyListeners();
      return;
    }
    print('not empty');
    _isAuthProgress = true;
    _errorMessage = null;
    notifyListeners();
    String? sessionId;
    try {
      sessionId = await _apiClient.auth(username: login, password: password);
      print('$sessionId');
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.Network:
          _errorMessage = 'Ошибка сети. Проверьте интеренет соединение';
          break;
        case ApiClientExceptionType.Auth:
          _errorMessage = 'Неверный логин или пароль';

          break;
        case ApiClientExceptionType.Other:
          _errorMessage = 'Ошибка сервера. Повторите запрос';

          break;
      }
    }
    _isAuthProgress = false;
    if (_errorMessage != null) {
      notifyListeners();
      return;
    }
    if (sessionId == null) {
      _errorMessage = 'Не получен id сессии';
      notifyListeners();
      return;
    }
    await _sessionDataProvider.setSessionId(sessionId);

    // Navigator.of(context).pushNamed('/main_screen');
    // Navigator.of(context).pushNamed(RouteScreen.mainScreen);
    Navigator.of(context)
        .pushReplacementNamed(MainNavigationRouteNames.mainScreen);

    //notifyListeners();
    //_sessionId =_apiKlient.auth(username: login, password: password);
  }
}

// class AuthProvider extends InheritedNotifier {
//   //не забыть поменять от кого наследуется инхерит
//   AuthProvider({Key? key, required this.model, required this.child})
//       : super(key: key, notifier: model, child: child);
//   final AuthModel model;
//   final Widget child;
//
//   static AuthProvider? watch(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
//   }
//
//   static AuthProvider? read(BuildContext context) {
//     final widget =
//         context.getElementForInheritedWidgetOfExactType<AuthProvider>()?.widget;
//     return widget is AuthProvider ? widget : null;
//   }
// }
