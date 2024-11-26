import 'package:curso_testes_flutterando/src/cubits/board_cubit.dart';
import 'package:curso_testes_flutterando/src/repositories/board_repository.dart';
import 'package:curso_testes_flutterando/src/repositories/isar/isar_datasource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'src/repositories/isar/isar_board_repository.dart';
import 'src/screens/board_screen.dart';

void main() {
  runApp(const AppWidget());
}

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider(
          create: (_) => IsarDatasource(),
        ),
        RepositoryProvider<BoardRepository>(
          create: (context) => IsarBoardRepository(
            context.read(),
          ),
        ),
        BlocProvider(
          create: (context) => BoardCubit(
            repository: context.read(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Tasks Teste',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const BoardScreen(),
      ),
    );
  }
}
