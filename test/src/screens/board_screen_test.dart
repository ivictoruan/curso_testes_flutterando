import 'package:curso_testes_flutterando/src/cubits/board_cubit.dart';
import 'package:curso_testes_flutterando/src/repositories/board_repository.dart';
import 'package:curso_testes_flutterando/src/screens/board_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  testWidgets(
    'board screen with all tasks ...',
    (tester) async {
      when(() => repository.fetch()).thenAnswer((_) async => []);

      await tester.pumpWidget(BlocProvider.value(
        value: cubit,
        child: const MaterialApp(
          home: BoardScreen(),
        ),
      ));

      expect(find.byKey(const Key('EmptyState')), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));

      expect(find.byKey(const Key('GettedState')), findsOneWidget);
    },
  );

  testWidgets(
    'board screen with failure ...',
    (tester) async {
      when(() => repository.fetch()).thenThrow(
        Exception('Algum erro bb'),
      );

      await tester.pumpWidget(BlocProvider.value(
        value: cubit,
        child: const MaterialApp(
          home: BoardScreen(),
        ),
      ));

      expect(find.byKey(const Key('EmptyState')), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));

      expect(find.byKey(const Key('FailureState')), findsOneWidget);
    },
  );
}
