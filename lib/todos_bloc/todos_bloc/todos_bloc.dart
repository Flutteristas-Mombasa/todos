import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:todos/todos_provider/todo_db_helper.dart';
import 'package:todos/todos_provider/todo_model.dart';

part 'todos_event.dart';
part 'todos_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  TodosBloc(this._dbHelper) : super(TodosInitial()) {
    on<GetTodosEvent>((event, emit) async {
      try {
        emit(TodosLoading());
        final result = await _dbHelper.todos();
        emit(TodosSuccess(result));
      } catch (e) {
        emit(TodosError(e.toString()));
      }
    });

    on<UpdateTodosEvent>((event, emit) async {
      try {
        emit(TodosLoading());
        await _dbHelper.updateTodo(event.todoModel!);
        emit(TodosUpdated());
        // Fetch the todos
        add(GetTodosEvent());
      } catch (e) {
        emit(TodosError(e.toString()));
      }
    });

    on<DeleteTodosEvent>((event, emit) async {
      try {
        emit(TodosLoading());
        await _dbHelper.deleteTodo(event.id!);
        emit(TodosDeleted());
        // Fetch the todos
        add(GetTodosEvent());
      } catch (e) {
        emit(TodosError(e.toString()));
      }
    });

    on<CreateTodosEvent>((event, emit) async {
      try {
        emit(TodosLoading());
        await _dbHelper.insertTodo(event.todoModel!);
        emit(TodosCreated());
        // Fetch the todos
        add(GetTodosEvent());
      } catch (e) {
        emit(TodosError(e.toString()));
      }
    });
  }

  final TodoDbHelper _dbHelper;
}
