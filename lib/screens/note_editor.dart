import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/style/app_style.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({super.key});

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  TextEditingController _titleController = TextEditingController();
  TextEditingController _notecontentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        backgroundColor: AppStyle.mainColor,
        elevation: 0.0,
        title: Text("Add New Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Note Title',
              ),
              style: AppStyle.mainTitle,
            ),
            SizedBox(height: 8.0),
            Text(
              DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()), // Menampilkan waktu saat ini (optional)
              style: AppStyle.dateTitle,
            ),
            SizedBox(height: 28.0),
            TextField(
              controller: _notecontentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Type here',
              ),
              style: AppStyle.mainContent,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.accentColor,
        onPressed: () async {
        try {
          DocumentReference docRef = await FirebaseFirestore.instance.collection("Notes").add({
            "color_id": color_id,
            "creation_date": FieldValue.serverTimestamp(),
            "note_title": _titleController.text,
            "note_content": _notecontentController.text,
          });
          print("Note added with ID: ${docRef.id}");
          Navigator.pop(context);
          } catch (error) {
          print("Failed to add new note due to $error");
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}