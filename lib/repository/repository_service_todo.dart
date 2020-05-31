import 'package:flutterapp/models/todo.dart';
import 'package:flutterapp/repository/database_creator.dart';

class RepositoryServiceTodo {
  static Future<List<Todo>> getAllTodos() async {
    final sql = '''SELECT * FROM ${DatabaseCreator.todoTable}
    WHERE ${DatabaseCreator.isDeleted} = 0''';
    final data = await db.rawQuery(sql);
    List<Todo> todos = List();

    for (final node in data) {
      final todo = Todo.fromJson(node);
      todos.add(todo);
    }
    return todos;
  }

  static Future<Todo> getTodo(int id) async {
    final sql = '''SELECT * FROM ${DatabaseCreator.todoTable}
    WHERE ${DatabaseCreator.id} = ?''';

    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);

    final todo = Todo.fromJson(data.first);
    return todo;
  }

  static Future<void> addTodo(Todo todo) async {
    final sql = '''INSERT INTO ${DatabaseCreator.todoTable}
    (
      ${DatabaseCreator.id},
      ${DatabaseCreator.name},
      ${DatabaseCreator.desk},
      ${DatabaseCreator.isDeleted}
    )
    VALUES (?,?,?,?)''';
    List<dynamic> params = [todo.id, todo.name, todo.desk, todo.isDeleted ? 1 : 0];
    await db.rawInsert(sql, params);
}

  static Future<void> deleteTodo(Todo todo) async {
    final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.isDeleted} = 1
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [todo.id];
    await db.rawUpdate(sql, params);
  }

  static Future<void> updateTodo(Todo todo) async {
    final sql = '''UPDATE ${DatabaseCreator.todoTable}
    SET ${DatabaseCreator.name} = ?
    WHERE ${DatabaseCreator.id} = ?
    ''';

    List<dynamic> params = [todo.name, todo.id];
    await db.rawUpdate(sql, params);
  }

  static Future<int> todosCount() async {
    final data = await db.rawQuery('''SELECT COUNT(*) FROM ${DatabaseCreator.todoTable}''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }
}