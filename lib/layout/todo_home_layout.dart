import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:laila_flutter/shared/components/components.dart';
import 'package:laila_flutter/shared/cubitt/cubit.dart';
import 'package:laila_flutter/shared/cubitt/states.dart';

class HomeLayout extends StatelessWidget {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var timeController = TextEditingController();
  var dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..CreateDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (BuildContext context, AppStates state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (BuildContext context, AppStates state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(
                cubit.titles[cubit.current_index],
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontFamily: 'Ubuntu',
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.orange,
              elevation: 0.0,
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              //the condition
              builder: (context) => cubit.screens[cubit.current_index],
              //if true
              fallback: (context) =>
                  Center(child: CircularProgressIndicator()), //else
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.orange,
              onPressed: () {
                if (cubit.isbottomsheetshown) {
                  if (formKey.currentState.validate()) {
                    cubit.InsertToDatabase(
                        title: titleController.text,
                        time: timeController.text,
                        date: dateController.text);
                    titleController.text = '';
                    timeController.text = '';
                    dateController.text = '';
                  }
                } else {
                  scaffoldKey.currentState
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultformfield(
                                  controller: titleController,
                                  type: TextInputType.text,
                                  validate: (String value) {
                                    if (value.isEmpty)
                                      return 'title must not be empty';
                                    return null;
                                  },
                                  labeltext: " task title",
                                  prefix: Icons.title,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultformfield(
                                  controller: timeController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now())
                                        .then((value) {
                                      timeController.text =
                                          value.format(context);
                                      print(value.format(context));
                                    });
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty)
                                      return 'time must not be empty';
                                    return null;
                                  },
                                  labeltext: " task time",
                                  prefix: Icons.watch_later_outlined,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                defaultformfield(
                                  controller: dateController,
                                  type: TextInputType.datetime,
                                  onTap: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      currentTime: DateTime.now(),
                                      minTime: DateTime.parse('2023-01-01'),
                                      maxTime: DateTime.parse('2023-12-30'),
                                    ).then((value) {
                                      dateController.text =
                                          DateFormat.yMMMd().format(value);
                                    });
                                  },
                                  validate: (String value) {
                                    if (value.isEmpty)
                                      return 'date must not be empty';
                                    return null;
                                  },
                                  labeltext: " task date",
                                  prefix: Icons.calendar_today_sharp,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 20.0,
                      )
                      .closed
                      .then((value) {
                    //trying to detect the hand closing
                    cubit.ChangeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.ChangeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
              child: Icon(
                cubit.fabicon,
                color: Colors.white,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.grey[100],
              elevation: 0.0,
              unselectedItemColor: Colors.blueGrey,
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.current_index,
              selectedItemColor: Colors.orange,
              onTap: (index) {
                cubit.ChangeIndex(index);
              },
              items: [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.menu,
                    ),
                    label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.check_circle_outline,
                    ),
                    label: 'Done'),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.archive_outlined,
                  ),
                  label: 'Archived',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
