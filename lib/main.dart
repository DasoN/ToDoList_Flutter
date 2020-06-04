import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/repository/database_creator.dart';
import 'package:flutterapp/repository/repository_service_todo.dart';

import 'components/createATask.dart';
import 'components/listPage.dart';
import 'components/profile.dart';
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
      home: MainComponent(),
    );
  }
}

class MainComponent extends StatefulWidget {
  MainComponent({Key key}) : super(key: key);

  @override
  _MainComponent createState() => _MainComponent();
}

class _MainComponent extends State<MainComponent> {
  int _selectedIndex = 0;
  int counter = 0;

  final _widgetOptions = [
    MyList(),
    CreatebleTask(),
    Profile()
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
            icon: Icon(Icons.view_list),
            title: Text('List'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.create),
            title: Text('Create'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text('Profile'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.lightGreen[500],
        onTap: _onItemTapped,
      ),
    );
  }
}

