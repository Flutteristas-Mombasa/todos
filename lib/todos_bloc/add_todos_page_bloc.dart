import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:todos/todos_bloc/todos_bloc/todos_bloc.dart';
import 'package:todos/todos_provider/todo_model.dart';

class TodosCreatePageBloc extends StatefulWidget {
  const TodosCreatePageBloc({super.key, this.todoModel});
  final TodoModel? todoModel;

  @override
  State<TodosCreatePageBloc> createState() => _TodosCreatePageBlocState();
}

class _TodosCreatePageBlocState extends State<TodosCreatePageBloc> {
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
      body: SingleChildScrollView(
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
                  BlocConsumer<TodosBloc, TodosState>(
                    listener: (context, state) {
                      if (state is TodosError) {
                        toastification.show(
                          context: context,
                          alignment: Alignment.bottomCenter,
                          style: ToastificationStyle.fillColored,
                          showProgressBar: false,
                          title: Text('Error'),
                          description: Text(state.errorMessage ?? ''),
                          type: ToastificationType.error,
                          autoCloseDuration: const Duration(seconds: 5),
                        );
                      }
                      if (state is TodosCreated) {
                        toastification.show(
                          context: context,
                          alignment: Alignment.bottomCenter,
                          style: ToastificationStyle.fillColored,
                          showProgressBar: false,
                          title: Text('Success'),
                          description: Text('Todo Created'),
                          type: ToastificationType.success,
                          autoCloseDuration: const Duration(seconds: 5),
                        );
                        Navigator.of(context).pop();
                      }

                      if (state is TodosUpdated) {
                        toastification.show(
                          context: context,
                          alignment: Alignment.bottomCenter,
                          style: ToastificationStyle.fillColored,
                          showProgressBar: false,
                          title: Text('Success'),
                          description: Text('Todo Updated'),
                          type: ToastificationType.success,
                          autoCloseDuration: const Duration(seconds: 5),
                        );
                        Navigator.of(context).pop();
                      }
                    },
                    builder: (context, state) {
                      if (state is TodosLoading) {
                        return Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                      return ElevatedButton(
                          onPressed: () {
                            // Update if TodoModel is not None
                            if (widget.todoModel != null) {
                              BlocProvider.of<TodosBloc>(context)
                                  .add(UpdateTodosEvent((TodoModel(
                                id: widget.todoModel
                                    ?.id, // Unique identifier used to identify todos in the database
                                title: titleController.text,
                                description: descriptionController.text,
                                completed: completed == true ? 1 : 0,
                              ))));
                            } else {
                              // create a new Todo
                              BlocProvider.of<TodosBloc>(context)
                                  .add(CreateTodosEvent(TodoModel(
                                title: titleController.text,
                                description: descriptionController.text,
                                completed: completed == true ? 1 : 0,
                              )));
                            }
                          },
                          child: Text('Save'));
                    },
                  ),
                  SizedBox(
                    height: 56,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
