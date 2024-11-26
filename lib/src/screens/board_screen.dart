import 'dart:io';

import 'package:curso_testes_flutterando/src/cubits/board_cubit.dart';
import 'package:curso_testes_flutterando/src/models/task.dart';
import 'package:curso_testes_flutterando/src/states/boart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BoardScreen extends StatefulWidget {
  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async => await context.read<BoardCubit>().fetchTask(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<BoardCubit>();
    final state = cubit.state;

    Widget body = Container(
      color: Colors.red,
      height: double.infinity,
      width: double.infinity,
    );

    if (state is FailureBoardState) {
      body = const Center(
        key: Key('FailureState'),
        child: Text('Falha ao recuperar tarefas!'),
      );
    } else if (state is EmptyBoardState) {
      body = const Center(
        key: Key('EmptyState'),
        child: Text('Adicione uma nova tarefa!'),
      );
    } else if (state is GettedTaskBoardState) {
      body = ListView.builder(
        key: const Key('GettedState'),
        itemCount: state.tasks.length,
        itemBuilder: (context, int index) {
          final task = state.tasks[index];
          return GestureDetector(
            onLongPress: () => removeTaskDialog(task),
            child: CheckboxListTile(
              value: task.check,
              title: Text(task.description),
              onChanged: (_) => cubit.checkTask(task),
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
      ),
      body: body,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void addTaskDialog() {
    String description = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('Adicionar uma task'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Sair'),
          ),
          TextButton(
            onPressed: () {
              final task = Task(
                id: -1,
                description: description,
              );

              context.read<BoardCubit>().addTask(task);

              Navigator.pop(context);
            },
            child: const Text('Criar'),
          ),
        ],
        content: TextField(
          onChanged: (value) => description = value,
        ),
      ),
    );
  }

  void removeTaskDialog(Task task) => showDialog(
        context: context,
        builder: (context) => AlertDialog.adaptive(
          title: const Text('Remover a tarefa?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () {
                context.read<BoardCubit>().removeTask(task);

                Navigator.pop(context);
              },
              child: const Text('Sim'),
            ),
          ],
        ),
      );
}
