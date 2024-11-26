import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../models/task.dart';
import '../repositories/board_repository.dart';
import '../states/boart_state.dart';

class BoardCubit extends Cubit<BoardState> {
  final BoardRepository _repository;

  BoardCubit({required BoardRepository repository})
      : _repository = repository,
        super(EmptyBoardState());

  Future<void> fetchTask() async {
    emit(LoadingBoardState());
    try {
      final tasks = await _repository.fetch();
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState('Error: $e'));
    }
  }

  Future<void> addTask(Task newTask) async {
    final List<Task>? tasks = _getTasks();

    if (tasks == null) {
      return;
    }

    tasks.add(newTask);

    await _emitTasks(tasks);
  }

  Future<void> removeTask(Task task) async {
    final List<Task>? tasks = _getTasks();

    if (tasks == null || tasks.isEmpty) {
      return;
    }

    tasks.remove(task);

    await _emitTasks(tasks);
  }

  Future<void> checkTask(Task taskToChangeCheck) async {
    final List<Task>? tasks = _getTasks();

    if (tasks == null || tasks.isEmpty) {
      return;
    }

    //* 1º encontra o index da tarefa a ser alterada na lista de tarefas
    final int taskIndex = tasks.indexOf(taskToChangeCheck);
    //* 2º substitui a tarefa dentro da lista
    tasks[taskIndex] = taskToChangeCheck.copyWith(
      check: !(taskToChangeCheck.check),
    );

    await _emitTasks(tasks);
  }

  List<Task>? _getTasks() {
    final state = this.state;

    /// Está se fazendo uma `promoção de tipo` na `condicional` abaixo.
    if (state is! GettedTaskBoardState) {
      return null;
    }

    /// Sem a `promoção de tipo` a propriedade `state.tasks` não seria compilada.
    return state.tasks.toList();
  }

  Future<void> _emitTasks(List<Task> tasks) async {
    try {
      _repository.update(tasks);
      emit(GettedTaskBoardState(tasks: tasks));
    } catch (e) {
      emit(FailureBoardState('Error: $e'));
    }
  }

  @visibleForTesting
  void addTasks(List<Task> tasks) => emit(GettedTaskBoardState(tasks: tasks));
}
