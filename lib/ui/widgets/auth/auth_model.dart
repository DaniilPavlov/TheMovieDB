import 'package:flutter/material.dart';
import 'package:themoviedb/domain/client/api_client_exception.dart';
import 'package:themoviedb/domain/services/auth_service.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class AuthModel extends ChangeNotifier {
  final _authService = AuthService();
  final loginTextController = TextEditingController(text: 'Daniil_Pavlov');
  final passwordTextController = TextEditingController();

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isAuthProgress = false;
  bool get canStartAuth => !_isAuthProgress;
  bool get isAuthProgress => _isAuthProgress;

  bool _isValid(String login, String password) =>
      login.isNotEmpty && password.isNotEmpty;

  Future<String?> _login(String login, String password) async {
    try {
      await _authService.login(login, password);
    } on ApiClientException catch (e) {
      switch (e.type) {
        case ApiClientExceptionType.network:
          return 'Ошибка сети. Проверьте интеренет соединение';
        case ApiClientExceptionType.auth:
          return 'Неверный логин или пароль';
        case ApiClientExceptionType.other:
          return 'Ошибка сервера. Повторите запрос';
        case ApiClientExceptionType.sessionExpired:
          return 'Авторизация устарела';
      }
    } catch (e) {
      _errorMessage = 'Неизвестная ошибка, повторите попытку';
    }
    return null;
  }

  Future<void> auth(BuildContext context) async {
    final login = loginTextController.text;
    final password = passwordTextController.text;
    if (!_isValid(login, password)) {
      _updateState("Заполните логин и пароль", false);
      return;
    }
    _updateState(null, true);
    _errorMessage = await _login(login, password);
    if (_errorMessage == null) {
      MainNavigation.resetNavigation(context);
    } else {
      _updateState(_errorMessage, false);
    }
  }

  void _updateState(String? errorMessage, bool isAuthProgress) {
    if (_errorMessage == errorMessage && _isAuthProgress == isAuthProgress) {
      return;
    }
    _errorMessage = errorMessage;
    _isAuthProgress = isAuthProgress;
    notifyListeners();
  }
}
