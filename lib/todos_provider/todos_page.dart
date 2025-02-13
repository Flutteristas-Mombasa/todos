import 'package:flutter/material.dart';
import 'package:todos/todos_provider/todos_create_page.dart';

class TodosPage extends StatelessWidget {
  const TodosPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Text('Todos List Here'),
      ),
    );
  }
}
