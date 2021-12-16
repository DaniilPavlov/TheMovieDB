import 'package:themoviedb/domain/api_client/api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _apiClient = ApiClient();

  Future<bool> isAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final isAuth = (sessionId != null);
    return isAuth;
  }

  Future<void> login(String login, String password) async {
    final sessionId =
        await _apiClient.auth(username: login, password: password);
    final accountId = await _apiClient.getAccountInfo(sessionId);
    print(sessionId);
    print('$accountId');
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
  }
}
