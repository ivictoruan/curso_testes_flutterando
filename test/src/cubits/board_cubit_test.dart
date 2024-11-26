import 'package:curso_testes_flutterando/src/cubits/board_cubit.dart';
import 'package:curso_testes_flutterando/src/models/task.dart';
import 'package:curso_testes_flutterando/src/repositories/board_repository.dart';
import 'package:curso_testes_flutterando/src/states/boart_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class BoardRepositoryMock extends Mock implements BoardRepository {}

void main() {
  late BoardRepositoryMock repository = BoardRepositoryMock();
  late BoardCubit cubit;

  setUp(() {
    repository = BoardRepositoryMock();
    cubit = BoardCubit(repository: repository);
  });

  group(
    'Fetch tasks |',
    () {
      final taskList = [
        const Task(
          id: 1,
          description: 'description',
          check: false,
        )
      ];

      test(
        'Deve buscar todas as tasks',
        () async {
          when(() => repository.fetch()).thenAnswer(
            (_) async => taskList,
          );
          expect(
            /// Quando o`actual` for do tipo `Stream` o `expect` deve ser chamado
            /// no início do teste.
            cubit.stream,
            emitsInOrder([
              isA<LoadingBoardState>(),
              isA<GettedTaskBoardState>(),
            ]),
          );

          /// Executa-se a função no final da chamada, após o `expect`.
          await cubit.fetchTask();
        },
      );

      test('Deve retornar um estado de erro ao falhar', () async {
        when(() => repository.fetch()).thenThrow(Exception('error'));

        expect(
          cubit.stream,
          emitsInOrder(
            [
              isA<LoadingBoardState>(),
              isA<FailureBoardState>(),
            ],
          ),
        );
        await cubit.fetchTask();
      });
    },
  );

  group('Add task |', () {
    test('Deve adicionar uma task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );

      const task = Task(
        id: 1,
        description: 'description',
      );
      await cubit.addTask(task);

      final state = cubit.state as GettedTaskBoardState;

      expect(state.tasks.length, 1);

      expect(state.tasks, [task]);
    });

    test('Deve retornar um estado de erro ao falhar', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );
      const task = Task(
        id: 1,
        description: 'description',
      );

      await cubit.addTask(task);
    });
  });

  group('Remove task |', () {
    test('Deve remover uma task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );

      const task = Task(
        id: 1,
        description: 'uma tarefa adicionada para teste',
      );

      /// Adicionando para fazer o teste (método disponível apenas para teste)
      cubit.addTasks([task]);

      await cubit.removeTask(task);

      final state = cubit.state as GettedTaskBoardState;

      expect(state.tasks.length, 0);
    });

    test('Deve retornar um estado de erro ao falhar', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      const task = Task(
        id: 1,
        description: 'description',
      );

      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );

      await cubit.removeTask(task);
    });
  });

  group('Check task |', () {
    test('Deve alterar a propriedade check de uma task', () async {
      when(() => repository.update(any())).thenAnswer((_) async => []);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<GettedTaskBoardState>(),
        ]),
      );

      const task = Task(
        id: 1,
        description: 'uma tarefa adicionada para teste',
        check: false,
      );

      /// Adicionando tarefa para fazer o teste (método disponível apenas para teste)
      cubit.addTasks([task]);

      await cubit.checkTask(task);

      final state = cubit.state as GettedTaskBoardState;

      expect(state.tasks.firstWhere((Task t) => t.id == task.id).check, true);
    });

    test('Deve retornar um estado de erro ao falhar', () async {
      when(() => repository.update(any())).thenThrow(Exception('Error'));

      const task = Task(
        id: 1,
        description: 'description',
        check: false,
      );

      cubit.addTasks([task]);

      expect(
        cubit.stream,
        emitsInOrder([
          isA<FailureBoardState>(),
        ]),
      );

      await cubit.checkTask(task);
    });
  });
}
