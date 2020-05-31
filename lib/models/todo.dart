import 'package:flutterapp/repository/database_creator.dart';

class Todo {
  int id;
  String name;
  String desk;
  bool isDeleted;

  Todo(this.id, this.name, this.desk, this.isDeleted);

  Todo.fromJson(Map<String, dynamic> json) {
    this.id = json[DatabaseCreator.id];
    this.name = json[DatabaseCreator.name];
    this.desk = json[DatabaseCreator.desk];
    this.isDeleted = json[DatabaseCreator.isDeleted] == 1;
  }
}