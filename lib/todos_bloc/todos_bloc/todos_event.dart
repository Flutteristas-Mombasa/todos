part of 'todos_bloc.dart';

sealed class TodosEvent extends Equatable {
  const TodosEvent();

  @override
  List<Object> get props => [];
}

class GetTodosEvent extends TodosEvent {}

class UpdateTodosEvent extends TodosEvent {
  const UpdateTodosEvent(this.todoModel);

  final TodoModel? todoModel;
}

class CreateTodosEvent extends TodosEvent {
  const CreateTodosEvent(this.todoModel);

  final TodoModel? todoModel;
}

class DeleteTodosEvent extends TodosEvent {
  const DeleteTodosEvent(this.id);

  final int? id;
}
