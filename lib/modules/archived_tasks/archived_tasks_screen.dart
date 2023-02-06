import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:laila_flutter/shared/components/components.dart';
import 'package:laila_flutter/shared/cubitt/cubit.dart';
import 'package:laila_flutter/shared/cubitt/states.dart';

class ArchivedTasksScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context ,state)=>{},
      builder: (cxt ,state){
        var tasks = AppCubit.get(cxt).archivedTasks;
        return taskBuilder(tasks: tasks, state: 'Archived');
      },
    );
  }
}
