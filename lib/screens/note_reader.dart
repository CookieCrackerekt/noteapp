import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:noteapp/style/app_style.dart';
import 'package:intl/intl.dart';

class NoteReaderPage extends StatefulWidget {
  NoteReaderPage(this.doc, {super.key});
  final QueryDocumentSnapshot doc;

  @override
  State<NoteReaderPage> createState() => _NoteReaderPageState();
}

class _NoteReaderPageState extends State<NoteReaderPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late String formattedDate;
  bool _isEditing = false; // Flag untuk mengontrol mode edit

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.doc["note_title"]);
    _contentController = TextEditingController(text: widget.doc["note_content"]);

    Timestamp timestamp = widget.doc["creation_date"] as Timestamp;
    DateTime dateTime = timestamp.toDate();
    formattedDate = DateFormat('yyyy-MM-dd - HH:mm').format(dateTime);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    try {
      // Update Firestore dengan data baru
      await FirebaseFirestore.instance
          .collection("Notes")
          .doc(widget.doc.id)
          .update({
        "note_title": _titleController.text,
        "note_content": _contentController.text,
        "creation_date": FieldValue.serverTimestamp(), // Timestamp saat ini
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Note updated successfully!")),
      );

      setState(() {
        _isEditing = false; // Kembali ke mode view setelah menyimpan
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update note: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        backgroundColor: AppStyle.mainColor,
        elevation: 0.0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: AppStyle.mainTitle,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Enter Title",
              ),
              readOnly: !_isEditing, // Kontrol editabilitas
            ),
            SizedBox(height: 4.0),
            Text(
              _isEditing
                  ? "Editing..." // Tampilkan teks saat sedang mengedit
                  : formattedDate, // Tampilkan tanggal yang diformat
              style: AppStyle.dateTitle,
            ),
            SizedBox(height: 28.0),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: AppStyle.mainContent,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter Content",
                ),
                readOnly: !_isEditing, // Kontrol editabilitas
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_isEditing) {
            _saveChanges(); // Simpan perubahan jika sedang mengedit
          } else {
          setState(() {
            _isEditing = true; // Aktifkan mode edit
           });
         }
        },
        backgroundColor: AppStyle.accentColor,
        icon: Icon(_isEditing ? Icons.save : Icons.edit),
        label: Text(_isEditing ? "Save" : "Edit"),
      ),
    );
  }
}