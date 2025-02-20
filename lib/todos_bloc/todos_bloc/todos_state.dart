part of 'todos_bloc.dart';

sealed class TodosState extends Equatable {
  const TodosState();

  @override
  List<Object> get props => [];
}

final class TodosInitial extends TodosState {}

final class TodosLoading extends TodosState {}

final class TodosCreated extends TodosState {}

final class TodosUpdated extends TodosState {}

final class TodosDeleted extends TodosState {}

final class TodosSuccess extends TodosState {
  final List<TodoModel> todos;

  TodosSuccess(this.todos);
}

final class TodosError extends TodosState {
  final String? errorMessage;

  TodosError(this.errorMessage);
}
