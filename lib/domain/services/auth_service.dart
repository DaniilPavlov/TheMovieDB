import 'package:themoviedb/domain/data_providers/session_data_provider.dart';

class AuthService {
  final _sessionProvider = SessionDataProvider();
  Future<bool> isAuth() async {
    final sessionId = await _sessionProvider.getSessionId();
    final isAuth = (sessionId != null);
    return isAuth;
  }
}
