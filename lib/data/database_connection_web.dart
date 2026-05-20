import 'package:drift/drift.dart';

QueryExecutor openConnection() {
  return DatabaseConnection.delayed(
    Future.error(
      UnsupportedError('Prize database is not configured for web yet.'),
    ),
  );
}
