// ===============================================================
// Mari-Rojmel
// Transaction Learning Repository
//
// Production Ready
// ===============================================================

import 'package:sqflite/sqflite.dart';

import '../../../core/database/database_helper.dart';
import '../models/transaction_learning_model.dart';

class TransactionLearningRepository {
  TransactionLearningRepository(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  static const String tableName = 'transaction_learning';

  Future<Database> get _db async => _databaseHelper.database;

  // ===============================================================

  // ===============================================================

  Future<TransactionLearningModel?> findByKeyword(String keyword) async {
    final db = await _db;

    final result = await db.query(
      tableName,
      where: 'LOWER(keyword)=LOWER(?)',
      whereArgs: [keyword.trim()],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return TransactionLearningModel.fromMap(result.first);
  }

  // ===============================================================
  // Get All
  // ===============================================================

  Future<List<TransactionLearningModel>> getAllLearning() async {
    final db = await _db;

    final result = await db.query(tableName, orderBy: 'keyword ASC');

    return result.map(TransactionLearningModel.fromMap).toList();
  }

  // ===============================================================
  // Count
  // ===============================================================

  Future<int> count() async {
    final db = await _db;

    final result =
        Sqflite.firstIntValue(
          await db.rawQuery('''
SELECT COUNT(*)
FROM $tableName
'''),
        ) ??
        0;

    return result;
  }

  // ===============================================================
  // Save Learning
  // ===============================================================

  Future<void> saveLearning(TransactionLearningModel model) async {
    final db = await _db;

    await db.insert(
      tableName,
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ===============================================================
  // Update Learning
  // ===============================================================

  Future<void> updateLearning(TransactionLearningModel model) async {
    final db = await _db;

    await db.update(
      tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
  }

  // ===============================================================
  // Increment Use Count
  // ===============================================================

  Future<void> incrementUseCount(String keyword) async {
    final db = await _db;

    await db.rawUpdate(
      '''
    UPDATE $tableName
    SET
    use_count = use_count + 1,
    last_used_at = ?
    WHERE LOWER(keyword)=LOWER(?)
    ''',
      [DateTime.now().toIso8601String(), keyword.trim()],
    );
  }

  // ===============================================================
  // Delete Learning
  // ===============================================================

  Future<void> deleteLearning(int id) async {
    final db = await _db;

    await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // ===============================================================
  // Clear Learning
  // ===============================================================

  Future<void> clearLearning() async {
    final db = await _db;

    await db.delete(tableName);
  }
}
