import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';
import 'package:todos/todos_provider/todo_model.dart';
import 'package:todos/todos_provider/todos_provider.dart';

class TodosCreatePage extends StatefulWidget {
  const TodosCreatePage({super.key, this.todoModel});
  final TodoModel? todoModel;

  @override
  State<TodosCreatePage> createState() => _TodosCreatePageState();
}

class _TodosCreatePageState extends State<TodosCreatePage> {
  bool completed = false;
  final descriptionController = TextEditingController();
  final titleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setText();
  }

  /// Updates the text controllers and the completed state based on the provided [todoModel].
  void setText() {
    if (widget.todoModel != null) {
      descriptionController.text = widget.todoModel?.description ?? '';
      titleController.text = widget.todoModel?.title ?? '';
      completed = widget.todoModel?.completed == 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Todos'),
      ),
      body: Consumer<TodosProvider>(
          builder: (BuildContext context, TodosProvider todosProvider, child) {
        // show a success toast and navigate user to `TodosPage`
        if (todosProvider.created || todosProvider.updated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            toastification.show(
              context: context,
              alignment: Alignment.bottomCenter,
              style: ToastificationStyle.flatColored,
              showProgressBar: false,
              title: Text('Success'),
              description:
                  Text(todosProvider.created ? 'Todo Created' : 'Todo Updated'),
              type: ToastificationType.success,
              autoCloseDuration: const Duration(seconds: 5),
            );
            Provider.of<TodosProvider>(context, listen: false).resetProvider();
            Navigator.of(context).pop();
          });
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
                key: _formKey,
                child: Column(
                  spacing: 10,
                  children: [
                    TextFormField(
                      controller: titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      decoration: InputDecoration(label: Text('Title')),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: descriptionController,
                      decoration: InputDecoration(label: Text('Description')),
                    ),
                    SwitchListTile(
                        title: Text('Completed'),
                        value: completed,
                        onChanged: (bool _completed) {
                          setState(() {
                            completed = _completed;
                          });
                        }),
                    if (todosProvider.loading)
                      Center(
                        child: CircularProgressIndicator.adaptive(),
                      )
                    else
                      ElevatedButton(
                          onPressed: () {
                            // Update if TodoModel is not None
                            if (widget.todoModel != null) {
                              Provider.of<TodosProvider>(context, listen: false)
                                  .insertATodo(TodoModel(
                                id: widget.todoModel
                                    ?.id, // Unique identifier used to identify todos in the database
                                title: titleController.text,
                                description: descriptionController.text,
                                completed: completed == true ? 1 : 0,
                              ));
                            } else {
                              // create a new Todo
                              Provider.of<TodosProvider>(context, listen: false)
                                  .insertATodo(TodoModel(
                                title: titleController.text,
                                description: descriptionController.text,
                                completed: completed == true ? 1 : 0,
                              ));
                            }
                          },
                          child: Text('Save')),
                    SizedBox(
                      height: 56,
                    ),
                  ],
                )),
          ),
        );
      }),
    );
  }
}
