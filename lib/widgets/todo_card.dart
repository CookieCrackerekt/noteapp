import 'package:flutter/material.dart';
import 'package:noteapp/style/app_style.dart';

class ToDoItem extends StatelessWidget {
  final Map<String, dynamic> todo;
  final Function(Map<String, dynamic>) onToDoChanged;
  final Function(String) onDeleteItem;

  const ToDoItem({
    Key? key,
    required this.todo,
    required this.onToDoChanged,
    required this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: ListTile(
        onTap: () {
          onToDoChanged(todo);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        tileColor: Colors.white,
        leading: Icon(
          todo['isDone'] ? Icons.check_box : Icons.check_box_outline_blank,
          color: AppStyle.accentColor,
        ),
        title: Text(
          todo['todoText'] ?? '',
          style: TextStyle(
            fontSize: 16,
            color: AppStyle.bgColor,
            decoration:
                todo['isDone'] ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.symmetric(vertical: 1),
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5),
          ),
          child: IconButton(
            color: Colors.white,
            iconSize: 18,
            icon: Icon(Icons.delete),
            onPressed: () async {
              bool? confirmDelete = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Delete To-Do"),
                  content: Text("Are you sure you want to delete this item?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text("Delete"),
                    ),
                  ],
                ),
              );

              if (confirmDelete == true) {
                onDeleteItem(todo['id']);
              }
            },
          ),
        ),
      ),
    );
  }
}
