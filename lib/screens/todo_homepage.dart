import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noteapp/screens/sidebar.dart';
import 'package:noteapp/style/app_style.dart';
import '../widgets/todo_card.dart';

class TodoHomepage extends StatefulWidget {
  TodoHomepage({Key? key}) : super(key: key);

  @override
  State<TodoHomepage> createState() => _HomeState();
}

class _HomeState extends State<TodoHomepage> {
  List<Map<String, dynamic>> _foundToDo = [];
  final _todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToDoFromFirestore();
  }

  // Memuat data dari Firestore
  Future<void> _loadToDoFromFirestore() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('Todo').get();
      setState(() {
        _foundToDo = snapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                })
            .toList();
      });
    } catch (e) {
      print('Error loading Todo: $e');
    }
  }

  Future<void> _addToDoItem(String toDo) async {
    if (toDo.isNotEmpty) {
      try {
        final newToDo = {
          'todoText': toDo,
          'isDone': false,
        };

        final docRef = await FirebaseFirestore.instance.collection('Todo').add(newToDo);

        setState(() {
          _foundToDo.add({'id': docRef.id, ...newToDo});
        });

        _todoController.clear();
      } catch (e) {
        print('Error adding todo: $e');
      }
    }
  }

  Future<void> _updateToDoStatus(Map<String, dynamic> todo) async {
    try {
      final newStatus = !todo['isDone'];

      await FirebaseFirestore.instance.collection('Todo').doc(todo['id']).update({
        'isDone': newStatus,
      });

      setState(() {
        final index = _foundToDo.indexWhere((item) => item['id'] == todo['id']);
        if (index != -1) {
          _foundToDo[index]['isDone'] = newStatus;
        }
      });
    } catch (e) {
      print('Error updating todo status: $e');
    }
  }

  Future<void> _deleteToDoItem(String id) async {
    try {
      await FirebaseFirestore.instance.collection('Todo').doc(id).delete();

      setState(() {
        _foundToDo.removeWhere((todo) => todo['id'] == id);
      });
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      _loadToDoFromFirestore();
    } else {
      results = _foundToDo
          .where((item) => item['todoText']
              .toString()
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    setState(() {
      _foundToDo = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title : Text("NotesUp",style: GoogleFonts.roboto(color:Colors.black, fontWeight: FontWeight.bold, fontSize: 26)),
        centerTitle: true,
        backgroundColor: AppStyle.bg2Color,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                SizedBox(height: 20),
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          'All to Dos',
                          style: GoogleFonts.roboto(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ..._foundToDo.map(
                        (todo) => ToDoItem(
                          todo: todo,
                          onToDoChanged: _updateToDoStatus,
                          onDeleteItem: _deleteToDoItem,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(
                      bottom: 20,
                      right: 20,
                      left: 20,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        )
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      decoration: InputDecoration(
                        hintText: 'Add a new To Do item',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 20,
                    right: 20,
                  ),
                  child: ElevatedButton(
                    child: Text(
                      '+',
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    ),
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppStyle.accentColor,
                      minimumSize: Size(60, 60),
                      elevation: 10,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget searchBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          prefixIcon: Icon(
            Icons.search,
            color: AppStyle.bgColor,
            size: 20,
          ),
          prefixIconConstraints: BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: 'Search',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
