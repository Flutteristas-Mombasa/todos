import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todos/todos_provider/todos_page.dart';
import 'package:todos/todos_provider/todos_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TodosProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Todos',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todos'),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => TodosPage()));
            },
            title: Text('Todos Provider'),
          ),
          ListTile(
            title: Text('Todos Bloc'),
          ),
        ],
      ),
    );
  }
}
