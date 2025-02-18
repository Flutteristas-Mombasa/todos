import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/todos_provider/todos_create_page.dart';
import 'package:todos/todos_provider/todos_provider.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TodosProvider>(context, listen: false).getTodos();
    });

    final todos = Provider.of<TodosProvider>(context).todos;
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
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<TodosProvider>(context, listen: false).getTodos();
        },
        child: ListView.builder(
            itemCount: todos.length,
            itemBuilder: (_, i) => ListTile(
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
                )),
      ),
    );
  }
}
