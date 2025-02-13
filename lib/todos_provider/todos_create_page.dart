import 'package:flutter/material.dart';

class TodosCreatePage extends StatefulWidget {
  const TodosCreatePage({super.key});

  @override
  State<TodosCreatePage> createState() => _TodosCreatePageState();
}

class _TodosCreatePageState extends State<TodosCreatePage> {
  bool completed = false;
  final descriptionController = TextEditingController();
  final titleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
                  ElevatedButton(onPressed: () {}, child: Text('Save')),
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
