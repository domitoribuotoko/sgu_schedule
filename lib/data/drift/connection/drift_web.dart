import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';

/// Web: SQLite в WASM + drift worker, файлы [sqlite3.wasm] / [drift_worker.js] в [web/].
QueryExecutor openDriftConnection() {
  return DatabaseConnection.delayed(
    _openRefCache(),
  );
}

Future<DatabaseConnection> _openRefCache() async {
  final result = await WasmDatabase.open(
    databaseName: 'sgu_schedule_ref_cache',
    sqlite3Uri: Uri.parse('sqlite3.wasm'),
    driftWorkerUri: Uri.parse('drift_worker.js'),
  );
  return result.resolvedExecutor;
}
