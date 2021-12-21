enum ApiClientExceptionType { network, auth, other, sessionExpired }

//Создаем класс ошибок для этого имплементируем класс Exception
class ApiClientException implements Exception {
  final ApiClientExceptionType type;

  ApiClientException(this.type);
}