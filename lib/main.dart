import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/repository/database_creator.dart';
import 'package:flutterapp/repository/repository_service_todo.dart';

import 'models/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseCreator().initDatabase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SqfLiteCrud(),
    );
  }
}

class SqfLiteCrud extends StatefulWidget {
  SqfLiteCrud({Key key}) : super(key: key);

  @override
  _SqfLiteCrudState createState() => _SqfLiteCrudState();
}

class _SqfLiteCrudState extends State<SqfLiteCrud> {
  int _selectedIndex = 0;

  final _widgetOptions = [
    CreatebleTask(),
    MyList()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: Text('ToDo List'),
        ),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            title: Text('Create'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_list),
            title: Text('List'),
          )
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen[500],
        onTap: _onItemTapped,
      ),
    );
  }
}

class MyList extends StatefulWidget {
  @override
  _MyListState createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  Future<List<Todo>> future;
  String name;
  int id;

  @override
  initState() {
    super.initState();
    future = RepositoryServiceTodo.getAllTodos();
  }

  deleteTodo(Todo todo) async {
    await RepositoryServiceTodo.deleteTodo(todo);
    setState(() {
      id = null;
      future = RepositoryServiceTodo.getAllTodos();
    });
  }

  Card buildItem(Todo todo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              todo.name,
              style: TextStyle(fontSize: 30,),
            ),
            Row(
              children: <Widget>[
                  Expanded(
                    child: Text(
                      todo.desk,
                      style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                    ),
                  ),
                  FlatButton(
                      onPressed: () => deleteTodo(todo),
                      child: Text('Delete'),
                    ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8),
      children: <Widget>[
        FutureBuilder<List<Todo>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(children: snapshot.data.map((todo) => buildItem(todo)).toList());
            } else {
              return SizedBox();
            }
          },
        )
      ],
    );
  }
}

class CreatebleTask extends StatefulWidget {
  @override
  _CreatebleTaskState createState() => _CreatebleTaskState();
}

class _CreatebleTaskState extends State<CreatebleTask> {
  final _formKey = GlobalKey<FormState>();
  Future<List<Todo>> future;
  String name;
  String description;
  int id;

  @override
  initState() {
    super.initState();
    future = RepositoryServiceTodo.getAllTodos();
  }

  deleteTodo(Todo todo) async {
    await RepositoryServiceTodo.deleteTodo(todo);
    setState(() {
      id = null;
      future = RepositoryServiceTodo.getAllTodos();
    });
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
      },
      onSaved: (value) => name = value,
    );
  }

  void createTodo() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      int count = await RepositoryServiceTodo.todosCount();
      final todo = Todo(count, name, description, false);
      await RepositoryServiceTodo.addTodo(todo);
      setState(() {
        id = todo.id;
        future = RepositoryServiceTodo.getAllTodos();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child:  Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "name"
                    ),
                    onSaved: (value) => name = value,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        labelText: "description"
                    ),
                    onSaved: (value) => description = value,
                  )
                ],
              )
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: createTodo,
                  child: Text('Create', style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                )
              ],
            ),
          ],
    )
    );
  }
}

