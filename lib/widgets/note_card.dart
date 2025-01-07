import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noteapp/style/app_style.dart';

Widget noteCard(Function()? onTap, QueryDocumentSnapshot doc, BuildContext context) {
  return GestureDetector(
    onTap: onTap,
    onLongPress: () async {
      // Menampilkan dialog konfirmasi
      bool? confirmDelete = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Delete Note"),
          content: Text("Are you sure you want to delete this note?"),
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

      // Jika konfirmasi pengguna adalah true, hapus catatan
      if (confirmDelete == true) {
        await FirebaseFirestore.instance.collection("Notes").doc(doc.id).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Note deleted successfully")),
        );
      }
    },
    child: Container(
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: AppStyle.cardsColor[doc['color_id']],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            doc["note_title"],
            style: AppStyle.mainTitle,
          ),
          SizedBox(height: 4.0),
          Text(
            doc["creation_date"] is Timestamp
                ? DateFormat('yyyy-MM-dd – HH:mm')
                    .format((doc["creation_date"] as Timestamp).toDate())
                : doc["creation_date"].toString(),
            style: AppStyle.dateTitle,
          ),
          SizedBox(height: 8.0),
          Text(
            doc["note_content"],
            style: AppStyle.mainContent,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
  );
}
