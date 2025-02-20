import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:todos/todos_provider/todos_create_page.dart';
import 'package:todos/todos_provider/todos_provider.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get todos on widget build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodosProvider>(context, listen: false).getTodos();
    });

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => TodosCreatePage()));
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text('Todos Provider'),
      ),
      body: Consumer<TodosProvider>(builder: (context, todosProvider, child) {
        final todos = todosProvider.todos;
        if (todosProvider.deleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Reset The provider states and get todos from the database
            Provider.of<TodosProvider>(context, listen: false)
              ..resetProvider()
              ..getTodos();
            // Show a toast to let the user know the todo was deleted
            toastification.show(
              context: context,
              alignment: Alignment.bottomCenter,
              style: ToastificationStyle.flatColored,
              showProgressBar: false,
              title: Text('Success'),
              description: Text('Deleted'),
              type: ToastificationType.info,
              autoCloseDuration: const Duration(seconds: 5),
            );
          });
        }
        return RefreshIndicator(
          onRefresh: () async {
            // PUll down to refresh todos
            Provider.of<TodosProvider>(context, listen: false).getTodos();
          },
          child: ListView.builder(
              itemCount: todos.length,
              itemBuilder: (_, i) => Dismissible(
                    background: Container(color: Colors.red),
                    key: UniqueKey(),
                    onDismissed: (l) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Provider.of<TodosProvider>(context, listen: false)
                            .deleteATodo(todos[i].id!);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        tileColor:
                            todos[i].completed == 1 ? Colors.greenAccent : null,
                        onTap: () {
                          // Navigate to the TodosCreatePage, passing the selected todo item.
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => TodosCreatePage(
                                    todoModel: todos[i],
                                  )));
                        },
                        subtitle: Text(todos[i].description ?? ''),
                        leading: Text('${todos[i].id}'),
                        title: Text(todos[i].title ?? ''),
                      ),
                    ),
                  )),
        );
      }),
    );
  }
}
