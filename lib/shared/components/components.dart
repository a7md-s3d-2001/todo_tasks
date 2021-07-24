import 'package:todo_tasks/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';

Widget defaultInputText({
  required TextEditingController controller,
  required IconData prefixIcon,
  required String label,
  required var validator,
  required var type,
  var onTap,
  bool enabled = true,
}) {
  return TextFormField(
    enabled: enabled,
    controller: controller,
    validator: validator,
    onTap: onTap,
    keyboardType: type,
    decoration: InputDecoration(
      prefixIcon: Icon(prefixIcon),
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.grey[400],
      ),
      border: OutlineInputBorder(),
    ),
  );
}

Widget buildTaskItem(Map model, context) {
  AppCubit cubit = AppCubit.get(context);
  return Dismissible(
    key: Key(model['id'].toString()),
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            child: Text("${model['time']}"),
          ),
          SizedBox(
            width: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${model['title']}",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // SizedBox(height: 10.0,),
                Text(
                  "${model['date']}",
                  style: TextStyle(
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          IconButton(
            onPressed: () {
              cubit.updateDatabase(
                status: 'done',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.check_box_outlined,
              color: Colors.green,
            ),
          ),
          IconButton(
            onPressed: () {
              cubit.updateDatabase(
                status: 'archived',
                id: model['id'],
              );
            },
            icon: Icon(
              Icons.archive_outlined,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
    onDismissed: (direction) {
      cubit.deleteDatabase(id: model['id']);
    },
  );
}

Widget view (List<Map> tasks,) {
  return tasks.length <= 0? Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, please Add some Tasks',
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.grey
          ),
        ),
      ],
    ),
  ):  ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
        end: 20.0,
      ),
      child: Container(
        height: 2.0,
        width: double.infinity,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  );
}