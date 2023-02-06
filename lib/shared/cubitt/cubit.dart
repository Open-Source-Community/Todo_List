import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laila_flutter/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:laila_flutter/modules/done_tasks/done_tasks_screen.dart';
import 'package:laila_flutter/modules/new_tasks/new_tasks_screen.dart';
import 'package:laila_flutter/shared/cubitt/states.dart';
import 'package:sqflite/sqflite.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppIntialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int current_index = 0;
  Database database;
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archivedTasks = [];

  List<Widget> screens = [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles = [' New Tasks', 'Done Tasks', 'Archived Tasks'];

  void ChangeIndex(int index) {
    current_index = index;
    emit(AppChangeBottomNavBarState());
  }

  void CreateDatabase() {
    // var database;
    openDatabase('todo.db', version: 1,
        //on create is called in the first time
        onCreate: (database, version) {
      print('database is created');
      database
          .execute(
              'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT,date TEXT,time TEXT,status TEXT)')
          .then((value) {
        print('table created');
      }).catchError((error) {
        print('error while creating the table${error.tostring()}');
      });
    },
        //on open iss called multiple times
        onOpen: (database) {
      print('database is opened');
    }).then((value) {
      database = value;
      GetDataFromDatabase();
      emit(AppCreateDatabaseState());
    });
  }

  InsertToDatabase({
    @required title,
    @required time,
    @required date,
  }) async {
    await database.transaction((txn) {
      txn
          .rawInsert(
              'INSERT INTO tasks(title,date,time,status) VALUES("$title","$date","$time","new")')
          .then((value) {
        print('$value inserted successfully');
        emit(AppInsertDatabaseState());
        GetDataFromDatabase();
      }).catchError((error) {
        print('${error.toString()} when inserting new row');
      });

      return null;
    });
  }

  void GetDataFromDatabase() {
    newTasks = [];
    doneTasks = [];
    archivedTasks = [];

    emit(AppGetDatabaseLoadingState());
    database.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new')
          newTasks.add(element);
        else if (element['status'] == 'done')
          doneTasks.add(element);
        else
          archivedTasks.add(element);
      });
      emit(AppGetDatabaseState());
    });
  }

  void UpdateData({@required String status, @required int id}) async {
    database.rawUpdate('UPDATE tasks SET status = ? WHERE id = ?',
        ['$status', id]).then((value) {
      GetDataFromDatabase();
      emit(AppUpdateDatabaseState());
    });
  }

  void deleteData({@required int id}) async {
    database.rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      GetDataFromDatabase();
      emit(AppDeleteDatabaseState());
    });
  }

  bool isbottomsheetshown = false;
  IconData fabicon = Icons.edit;

  void ChangeBottomSheetState({
    @required bool isShow,
    @required IconData icon,
  }) {
    isbottomsheetshown = isShow;
    fabicon = icon;
    emit(AppChangeBottomSheetState());
  }

  //bool isDark = false;

  // void SwitchDarkMode({bool cachedIsDark}) {
  //   if (cachedIsDark != null) {
  //     isDark = cachedIsDark;
  //     emit(SwitchDarkModeSuccessState());
  //   } else {
  //     isDark = !isDark;
  //     emit(SwitchDarkModeSuccessState());
  //     CacheHelper.putBooleanData('dark', isDark).then((value) {
  //       emit(SwitchDarkModeSuccessState());
  //     }).catchError((error) {
  //       print('error switched');
  //       emit(SwitchDarkModeErrorState());
  //     });
  //   }
  // }
}
