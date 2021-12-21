import 'package:themoviedb/domain/client/account_api_client.dart';
import 'package:themoviedb/domain/client/auth_api_client.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _accountApiClient = AccountApiClient();
  final _authApiClient = AuthApiClient();

  Future<bool> isAuth() async {
    final sessionId = await _sessionDataProvider.getSessionId();
    final isAuth = (sessionId != null);
    return isAuth;
  }

  Future<void> login(String login, String password) async {
    final sessionId =
        await _authApiClient.auth(username: login, password: password);
    final accountId = await _accountApiClient.getAccountInfo(sessionId);
    print(sessionId);
    print('$accountId');
    await _sessionDataProvider.setSessionId(sessionId);
    await _sessionDataProvider.setAccountId(accountId);
  }
}
