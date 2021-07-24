import 'package:todo_tasks/shared/components/components.dart';
import 'package:todo_tasks/shared/cubit/cubit.dart';
import 'package:todo_tasks/shared/cubit/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleTaskController = TextEditingController();
  var timeTaskController = TextEditingController();
  var dateTaskController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
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
              title: Text(cubit.titleAppBar[cubit.currentIndex]),
            ),
            body: cubit.screen[cubit.currentIndex],
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isButtonSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertDatabase(
                      title: titleTaskController.text,
                      time: timeTaskController.text,
                      date: dateTaskController.text,
                    );
                  }
                } else {
                  scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          // height: 300.0,
                          width: double.infinity,
                          color: Colors.white,
                          padding: const EdgeInsets.all(20.0),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultInputText(
                                  label: 'Title task',
                                  prefixIcon: Icons.title,
                                  controller: titleTaskController,
                                  type: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Title must be not empty';
                                    }
                                    return null;
                                  },
                                  enabled: true,
                                  onTap: () {},
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultInputText(
                                  label: 'Time task',
                                  prefixIcon: Icons.watch_later_outlined,
                                  controller: timeTaskController,
                                  type: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Time must be not empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) {
                                      timeTaskController.text =
                                          value!.format(context).toString();
                                      print(value.format(context));
                                    }).catchError((error) {});
                                  },
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                defaultInputText(
                                  label: 'Date task',
                                  prefixIcon: Icons.calendar_today,
                                  controller: dateTaskController,
                                  type: TextInputType.text,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Date must be not empty';
                                    }
                                    return null;
                                  },
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-01-01'),
                                    ).then((value) {
                                      dateTaskController.text =
                                          DateFormat.yMMMd().format(value!);
                                    }).catchError((error) {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetBar(
                      bottomSheet: false,
                    );
                  });
                }

                cubit.changeBottomSheetBar(
                  bottomSheet: true,
                );
              },
              child:
                  cubit.isButtonSheetShown ? Icon(Icons.add) : Icon(Icons.edit),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.selectedPage(index);
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'New',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.done_all_outlined),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
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
