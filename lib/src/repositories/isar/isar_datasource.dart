import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'task_model.dart';

///! Camada suja!
class IsarDatasource {
  Isar? _isar;

  Future<Isar> _getInstance() async {
    if (_isar != null) {
      return _isar!;
    }

    final dir = await getApplicationDocumentsDirectory();

    _isar = await Isar.open(
      [TaskModelSchema],
      directory: dir.path,
    );
    return _isar!;
  }

  Future<List<TaskModel>> getAllTasks() async {
    final isar = await _getInstance();
    final tasks = await isar.taskModels.where().findAll();
    return tasks;
  }

  Future<void> deleteAllTasks() async {
    final isar = await _getInstance();

    await isar.writeTxn(() {
      return isar.taskModels.where().deleteAll();
    });
  }

  Future<void> putAllTasks(List<TaskModel> tasks) async {
    final isar = await _getInstance();

    await isar.writeTxn(() {
      return isar.taskModels.putAll(tasks);
    });
  }

  @visibleForTesting
  void addChecks() {}
}
