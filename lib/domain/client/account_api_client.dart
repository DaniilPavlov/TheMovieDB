import 'package:themoviedb/configuration/configuration.dart';
import 'package:themoviedb/domain/client/network_client.dart';

enum MediaType { movie, tv }

extension MediaTypeAsString on MediaType {
  String asString() {
    switch (this) {
      case MediaType.movie:
        return 'movie';
      case MediaType.tv:
        return 'TV';
    }
  }
}

class AccountApiClient {
  final _networkClient = NetworkClient();

  Future<int> getAccountInfo(
    String sessionId,
  ) async {
    int parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final result = jsonMap['id'] as int;
      return result;
    }

    final result = _networkClient.get(
      '/account',
      parser,
      <String, dynamic>{
        'api_key': Configuration.apiKey,
        'session_id': sessionId,
      },
    );
    return result;
  }

  Future<String> markAsFavorite({
    required int accountId,
    required String sessionId,
    required MediaType mediaType,
    required int mediaId,
    required bool isFavorite,
  }) async {
    final parameters = <String, dynamic>{
      'media_type': mediaType.asString(),
      'media_id': mediaId.toString(),
      'favorite': isFavorite,
    };
    //возвращаем статус удаления \ постановки в избранное
    String parser(dynamic json) {
      final jsonMap = json as Map<String, dynamic>;
      final message = jsonMap['status_message'] as String;
      print(message);
      return message;
    }

    final result = _networkClient.post(
        '/account/$accountId/favorite', parameters, parser, <String, dynamic>{
      'api_key': Configuration.apiKey,
      'session_id': sessionId
    });
    return result;
  }
}
