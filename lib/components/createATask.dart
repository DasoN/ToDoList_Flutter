import 'package:flutter/material.dart';
import 'package:flutterapp/models/todo.dart';
import 'package:flutterapp/repository/repository_service_todo.dart';

import 'listPage.dart';

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

  Future<void> _showMyDialog() async {
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
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Task was added to the list!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Task was added!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
                    SizedBox(height: 10,),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.title),
                          hintText: "Title",
                          border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => name = value,
                    ),
                    SizedBox(height: 10,),
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(Icons.description),
                          hintText: "Description",
                          border: OutlineInputBorder(),
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
                  onPressed: _showMyDialog,
                  child: Text('Create', style: TextStyle(color: Colors.white, fontSize: 30)),
                  color: Colors.green,
                )
              ],
            ),
          ],
        )
    );
  }
}