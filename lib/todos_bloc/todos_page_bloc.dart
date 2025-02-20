import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:todos/todos_bloc/add_todos_page_bloc.dart';
import 'package:todos/todos_bloc/todos_bloc/todos_bloc.dart';
import 'package:todos/todos_provider/todo_db_helper.dart';

class TodosPageBloc extends StatelessWidget {
  const TodosPageBloc({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // Initialize the bloc and get todos
      create: (context) => TodosBloc(TodoDbHelper())..add(GetTodosEvent()),
      child: TodosBlocView(),
    );
  }
}

class TodosBlocView extends StatelessWidget {
  const TodosBlocView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<TodosBloc>(context),
                      child: TodosCreatePageBloc(),
                    )));
          }),
      appBar: AppBar(
        title: Text('Todos Bloc'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: BlocConsumer<TodosBloc, TodosState>(builder: (_, state) {
          if (state is TodosLoading) {
            return Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
          if (state is TodosSuccess) {
            return ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (_, i) => Dismissible(
                      background: Container(color: Colors.red),
                      key: UniqueKey(),
                      onDismissed: (l) {
                        BlocProvider.of<TodosBloc>(context)
                            .add(DeleteTodosEvent((state.todos[i].id!)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          tileColor: state.todos[i].completed == 1
                              ? Colors.greenAccent
                              : null,
                          onTap: () {
                            // Navigate to the TodosCreatePageBloc, passing the selected todo item.
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                      value:
                                          BlocProvider.of<TodosBloc>(context),
                                      child: TodosCreatePageBloc(
                                        todoModel: state.todos[i],
                                      ),
                                    )));
                          },
                          leading: Text(state.todos[i].id.toString()),
                          subtitle: Text(state.todos[i].description ?? ''),
                          title: Text(state.todos[i].title ?? ''),
                        ),
                      ),
                    ));
          }

          return Center(
            child: Text('Empty'),
          );
        }, listener: (_, state) {
          if (state is TodosDeleted) {
            toastification.show(
              context: context,
              alignment: Alignment.bottomCenter,
              style: ToastificationStyle.flatColored,
              showProgressBar: false,
              title: Text('Success'),
              description: Text('Todo was deleted'),
              type: ToastificationType.info,
              autoCloseDuration: const Duration(seconds: 5),
            );
          }
          if (state is TodosError) {
            toastification.show(
              context: context,
              alignment: Alignment.bottomCenter,
              style: ToastificationStyle.flatColored,
              showProgressBar: false,
              title: Text('Error'),
              description: Text(state.errorMessage ?? ''),
              type: ToastificationType.error,
              autoCloseDuration: const Duration(seconds: 5),
            );
          }
        }),
      ),
    );
  }
}
