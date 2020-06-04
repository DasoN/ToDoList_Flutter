import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/todo.dart';
import 'package:flutterapp/repository/repository_service_todo.dart';

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
                  color: Colors.redAccent[100],
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