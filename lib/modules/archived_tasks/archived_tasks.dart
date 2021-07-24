import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_tasks/shared/components/components.dart';
import 'package:todo_tasks/shared/cubit/cubit.dart';
import 'package:todo_tasks/shared/cubit/state.dart';

class ArchivedTasks extends StatelessWidget {
  const ArchivedTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        List<Map> tasks = AppCubit.get(context).archiveTasks;
        return view(tasks);
      },
    );
  }
}
