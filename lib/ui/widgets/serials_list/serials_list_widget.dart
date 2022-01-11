import 'package:flutter/material.dart';
import 'package:themoviedb/domain/data_providers/session_data_provider.dart';
import 'package:themoviedb/ui/navigation/main_navigation.dart';

class SerialsListWidget extends StatelessWidget {
  const SerialsListWidget({
    Key? key,
  }) : super(key: key);

  void logOut(BuildContext context) {
    final provider = SessionDataProvider();
    provider.deleteSessionId();
    Navigator.of(context).pushReplacementNamed(MainNavigationRouteNames.auth);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      child: const Text('log out'),
      onPressed: () => logOut(context),
    ));
  }
}
