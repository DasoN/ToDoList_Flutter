import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/models/todo.dart';
import 'package:flutterapp/repository/repository_service_todo.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int future;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    RepositoryServiceTodo.todosCount().then((value) {
      setState(() {
        future = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          child: Padding(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                '''How much task you created: ${future}\n''',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 25
                ),
              )
          )
      ),
    );
  }
}
