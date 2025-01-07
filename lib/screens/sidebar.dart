import 'package:flutter/material.dart';
import 'package:noteapp/screens/note_homepage.dart';
import 'package:noteapp/screens/todo_homepage.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue, // Sesuaikan dengan warna tema aplikasi
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "NotesUp", // Nama aplikasi
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.note),
            title: const Text("Note"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NoteHomepage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text("To-Do"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TodoHomepage()));
            },
          ),
        ],
      ),
    );
  }
}
