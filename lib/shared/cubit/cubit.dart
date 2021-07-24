import 'package:todo_tasks/modules/archived_tasks/archived_tasks.dart';
import 'package:todo_tasks/modules/done_tasks/done_tasks.dart';
import 'package:todo_tasks/modules/new_tasks/new_tasks.dart';
import 'package:todo_tasks/shared/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:bloc/bloc.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screen = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];

  List<String> titleAppBar = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void selectedPage(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavBarState());
  }

  // 1. create database
  // 2. create tables
  // 3. open database
  // 4. insert to database
  // 5. get from database
  // 6. update database
  // 7. delete database

  Database? database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  void createDatabase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('database created');
        // table name : tasks
        // id integer primary key
        // title text
        // time text
        // date text
        // status text
        database.execute(
          'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT)',
        ).then((value) {
          print('table created');
        }).catchError((error) {
          print('table not created because ${error.toString()}');
        });
      },
      onOpen: (database) {
        print('database opened');
      },
    ).then((value) {
      database = value;
      emit(AppCreateDatabaseState());
      getDataFromDatabase(database);
    });
  }

  insertDatabase({
    required String title,
    required String time,
    required String date,
  }) async {
     await database!.transaction((txn) async {
      txn.rawInsert(
        'INSERT INTO tasks (title, time, date, status) VALUES ("$title", "$time", "$date", "new")',
      ).then((value) {
        print('$value record inserted');
        emit(AppInsertDatabaseState());
        getDataFromDatabase(database);
      }).catchError((error) {
        print('record not inserted because ${error.toString()}');
      });
      return null;
    });
  }

  void getDataFromDatabase(database)
  {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    // emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element)
      {
        if(element['status'] == 'new')
          newTasks.add(element);
        else if(element['status'] == 'done')
          doneTasks.add(element);
        else archiveTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void updateDatabase({
    required String status,
    required int id,
  }) async {
    database?.rawUpdate(
      'UPDATE tasks SET status = ? WHERE id = ?',
      ['$status', id],
    ).then((value) {
      print('$value it is updated');
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    }).catchError((error){
      print ('not updated because ${error.toString()}');
    });
  }
  void deleteDatabase({
    required int id,
  }) async {
    database?.rawDelete(
      'DELETE FROM tasks WHERE id = ?',
      [id],
    ).then((value) {
      print('$value it is deleted');
      getDataFromDatabase(database);
      emit((AppDeleteDatabaseState()));
    }).catchError((error){
      print ('not deleted because ${error.toString()}');
    });
  }

  bool isButtonSheetShown = false;

  void changeBottomSheetBar({
    required bool bottomSheet,
  }) {
    isButtonSheetShown = bottomSheet;
    emit(AppChangeBottomSheetState());
  }
}
