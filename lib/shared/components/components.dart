import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:laila_flutter/shared/cubitt/cubit.dart';

Widget defaultformfield({
  @required TextEditingController controller,
  @required TextInputType type,
  @required Function validate,
  @required String labeltext,
  @required IconData prefix,
  Function onTap,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labeltext,
        border: OutlineInputBorder(),
        prefixIcon: Icon(prefix),
      ),
      validator: validate,
    );

Widget BuildTaskItem(Map model, context) => Dismissible(
      key: Key(model['id'].toString()),
      child: Container(
        //add the background color
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 3.0),
          child: Container(
            height: 100.0,
            width: double.infinity,
            child: Card(
              elevation: 3.0,
              shadowColor: Colors.grey,
              child: Row(
                children: [
                  SizedBox(
                    width: 5.0,
                  ),
                  CircleAvatar(
                    radius: 30.0,
                    child: Text(
                      '${model['time']}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                    backgroundColor: Colors.orange,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model['title']}',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 20.0,
                          ),
                        ),
                        SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          '${model['date']}',
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  //Done
                  IconButton(
                      icon: Icon(
                        Icons.check_box_rounded,
                        color: Colors.green,
                        size: 25,
                      ),
                      onPressed: () {
                        AppCubit.get(context)
                            .UpdateData(status: 'done', id: model['id']);
                      }),
                  //Archived
                  IconButton(
                      icon: Icon(
                        Icons.archive,
                        color: Colors.black54,
                        size: 25,
                      ),
                      onPressed: () {
                        AppCubit.get(context)
                            .UpdateData(status: 'archive', id: model['id']);
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        AppCubit.get(context).deleteData(id: model['id']);
      },
    );

Widget taskBuilder({@required List<Map> tasks, @required String state}) =>
    ConditionalBuilder(
      condition: tasks.length > 0,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return BuildTaskItem(tasks[index], context);
            },
            separatorBuilder: (context, index) => SizedBox(
                  height: 5.0,
                ),
            itemCount: tasks.length),
      ),
      fallback: (context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 100,
              color: Colors.orange,
            ),
            Text(
              'No $state Tasks',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange),
            )
          ],
        ),
      ),
    );
