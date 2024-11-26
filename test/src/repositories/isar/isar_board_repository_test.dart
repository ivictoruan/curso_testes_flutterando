import 'package:curso_testes_flutterando/src/models/task.dart';
import 'package:curso_testes_flutterando/src/repositories/board_repository.dart';
import 'package:curso_testes_flutterando/src/repositories/isar/isar_board_repository.dart';
import 'package:curso_testes_flutterando/src/repositories/isar/isar_datasource.dart';
import 'package:curso_testes_flutterando/src/repositories/isar/task_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class IsarDatasourceMock extends Mock implements IsarDatasource {}

void main() {
  late IsarDatasource datasource = IsarDatasourceMock();
  late BoardRepository repository;
  setUp(() {
    datasource = IsarDatasourceMock();
    repository = IsarBoardRepository(datasource);
  });
  test('fetch', () async {
    ///! Arrange
    when(() => datasource.getAllTasks()).thenAnswer((_) async => [
          TaskModel()..id = 1,
        ]);

    ///! ACT
    final tasks = await repository.fetch();

    ///! Assert
    expect(tasks.length, 1);
  });

  test('update', () async {
    ///! Arrange
    when(() => datasource.deleteAllTasks()).thenAnswer((_) async => []);
    when(() => datasource.putAllTasks(any())).thenAnswer((_) async => []);

    ///! ACT
    final tasks = await repository.update([
      /// No caso, `-1` significa `algo novo` (atualização)
      /// Portanto, quando o id estiver com -1 não irá atualizar o id, mas sim
      /// a `description` e o `check`
      const Task(id: -1, description: ''),
      const Task(id: 2, description: ''),
    ]);

    ///! Assert
    expect(tasks.length, 2);
  });
}
