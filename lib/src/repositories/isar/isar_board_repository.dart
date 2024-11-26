import 'package:curso_testes_flutterando/src/models/task.dart';

import '../board_repository.dart';
import 'isar_datasource.dart';
import 'task_model.dart';

class IsarBoardRepository implements BoardRepository {
  final IsarDatasource _datasource;

  IsarBoardRepository(this._datasource);

  @override
  Future<List<Task>> fetch() async {
    final models = await _datasource.getAllTasks();

    final result = TaskAdapter.toCheck(models);

    return result;
  }

  @override
  Future<List<Task>> update(List<Task> tasks) async {
    final models = TaskAdapter.toCheckModel(tasks);

    await _datasource.deleteAllTasks();

    await _datasource.putAllTasks(models);

    final result = TaskAdapter.toCheck(models);

    return result;
  }
}

class TaskAdapter {
  static List<Task> toCheck(List<TaskModel> models) {
    final result = models
        .map((element) => Task(
              id: element.id,
              description: element.description,
              check: element.check,
            ))
        .toList();
    return result;
  }

  static List<TaskModel> toCheckModel(List<Task> tasks) {
    final result = tasks.map(
      (Task e) {
        final model = TaskModel()
          ..check = e.check
          ..description = e.description;

        final bool isNewTask = e.id != -1;

        if (isNewTask) {
          model.id = e.id;
        }

        return model;
      },
    ).toList();

    return result;
  }
}
