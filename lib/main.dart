import 'package:todo_tasks/modules/home/home.dart';
import 'package:todo_tasks/shared/bloc_observer.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo Tasks',
      home: HomePage(),
    );
  }
}
