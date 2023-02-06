import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laila_flutter/layout/todo_home_layout.dart';
import 'shared/bloc__observer.dart';

void main() async {
  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext cxt) {
    return MaterialApp(
      home: HomeLayout(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[100],
        primarySwatch: Colors.amber,
      ),
    );
  }
}
