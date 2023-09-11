import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/widgets/update_task_dialog.dart';

import '../utils/colors.dart';
import '../widgets/delete_task_dialog.dart';

class Tasks extends StatefulWidget {
  const Tasks({Key? key}) : super(key: key);
  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  final fireStore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10.0),
      child: StreamBuilder<QuerySnapshot>(
        stream: fireStore.collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('No tasks to display');
          } else {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

                // Vérifiez si les valeurs sont null avant de les utiliser
                String? taskName = data['taskName'];
                String? taskDesc = data['taskDesc'];
                String? taskId = data['id'];
                String? taskTag = data['taskTag'];

                Color taskColor = AppColors.blueShadeColor;
                if (taskTag == 'Work') {
                  taskColor = AppColors.salmonColor;
                } else if (taskTag == 'School') {
                  taskColor = AppColors.greenShadeColor;
                }

                return Container(
                  height: 100,
                  margin: const EdgeInsets.only(bottom: 15.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadowColor,
                        blurRadius: 5.0,
                        offset: Offset(0, 5), // shadow direction: bottom right
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 20,
                      height: 20,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: taskColor,
                      ),
                    ),
                    title: Text(taskName ?? ''), // Utilisez taskName avec une valeur par défaut
                    subtitle: Text(taskDesc ?? ''), // Utilisez taskDesc avec une valeur par défaut
                    isThreeLine: true,
                    trailing: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 'edit',
                            child: const Text(
                              'Edit',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: () {
                              // Vérifiez si taskId est null avant de l'utiliser
                              if (taskId != null) {
                                Future.delayed(
                                  const Duration(seconds: 0),
                                      () => showDialog(
                                    context: context,
                                    builder: (context) => UpdateTaskAlertDialog(
                                      taskId: taskId,
                                      taskName: taskName ?? '',
                                      taskDesc: taskDesc ?? '',
                                      taskTag: taskTag ?? '',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: const Text(
                              'Delete',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            onTap: () {
                              // Vérifiez si taskId est null avant de l'utiliser
                              if (taskId != null) {
                                Future.delayed(
                                  const Duration(seconds: 0),
                                      () => showDialog(
                                    context: context,
                                    builder: (context) => DeleteTaskDialog(
                                      taskId: taskId,
                                      taskName: taskName ?? '',
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ];
                      },
                    ),
                    dense: true,
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
