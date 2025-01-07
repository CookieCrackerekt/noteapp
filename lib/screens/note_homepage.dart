import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noteapp/screens/note_editor.dart';
import 'package:noteapp/screens/note_reader.dart';
import 'package:noteapp/screens/sidebar.dart';
import 'package:noteapp/style/app_style.dart';
import 'package:noteapp/widgets/note_card.dart';

class NoteHomepage extends StatefulWidget {
  const NoteHomepage({super.key});

  @override
  State<NoteHomepage> createState() => _HomePageState();
}

class _HomePageState extends State<NoteHomepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Sidebar(),
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title : Text("NotesUp",style: GoogleFonts.roboto(color:Colors.black, fontWeight: FontWeight.bold, fontSize: 26)),
        centerTitle: true,
        backgroundColor: AppStyle.bg2Color,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Your Recent Notes",style: GoogleFonts.roboto(
              color:Colors.black, 
              fontWeight: FontWeight.bold, 
              fontSize: 22 
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("Notes").snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                  //checking the connection state, if we stoll load the data we can display a progress bar
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData){
                    return GridView(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                      children: snapshot.data!.docs.map((note) => noteCard((){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => NoteReaderPage(note)),
                          );
                        }, note,context)).toList(),
                    );
                  }
                  return 
                    Text("There is no note", 
                    style: GoogleFonts.nunito(color: Colors.white),);
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppStyle.accentColor,
        label: Text("Add Note"),
        icon: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => NoteEditorPage()));
        }, 
      ),
    );
  }
}