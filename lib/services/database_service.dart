import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  static const String _connectionString =
      'mongodb+srv://unibites-admin123:ZYpJWpuBmsvzzsFd@unibites-db.e6bcq2m.mongodb.net/unibites?appName=unibites-db&tls=true&authSource=admin&retryWrites=true&w=majority&socketTimeoutMS=45000&connectTimeoutMS=45000&maxIdleTimeMS=120000';

  static Db? _db;

  static Future<Db> get db async {
    // If db exists but not connected, try to reconnect
    if (_db != null && !_db!.isConnected) {
      debugPrint('DatabaseService: Socket was closed, reconnecting...');
      await connect();
    } else if (_db == null) {
      await connect();
    }
    return _db!;
  }

  static Future<void>? _connectionFuture;

  static Future<void> connect() async {
    if (_db != null && _db!.isConnected) return;

    if (_connectionFuture != null) {
      return _connectionFuture;
    }

    _connectionFuture = _connectInternal();
    try {
      await _connectionFuture;
    } finally {
      _connectionFuture = null;
    }
  }

  static Future<void> _connectInternal() async {
    int retries = 0;
    const maxRetries = 3;

    while (retries < maxRetries) {
      try {
        debugPrint(
            'DatabaseService: Connecting to MongoDB (Attempt ${retries + 1})...');

        // Clean up old instance if it exists and failed
        if (_db != null) {
          try {
            await _db!.close();
          } catch (_) {}
          _db = null;
        }

        _db = await Db.create(_connectionString);
        // Add a timeout to the connection attempt
        await _db!.open().timeout(const Duration(seconds: 10));

        if (_db!.isConnected) {
          // Sometimes mongo_dart needs a tiny bit of time to be fully ready
          await Future.delayed(const Duration(milliseconds: 200));
          debugPrint(
              'DatabaseService: Successfully connected to ${_db!.databaseName}');
          return;
        }
      } catch (e) {
        retries++;
        debugPrint('DatabaseService Connection Attempt $retries failed: $e');
        if (retries >= maxRetries) {
          debugPrint('DatabaseService: All connection attempts failed.');
          rethrow;
        }
        // Wait a bit before retrying
        await Future.delayed(Duration(seconds: retries));
      }
    }
  }

  static Future<void> close() async {
    await _db?.close();
    _db = null;
  }

  // Collection names
  static const String outletsCollection = 'outlets';
  static const String menuCollection = 'menu';
  static const String ordersCollection = 'orders';
  static const String usersCollection = 'users';
}
