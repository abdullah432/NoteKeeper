import 'package:flutter/material.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/screens/note_detail.dart';
import 'package:notekeeper/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Note> noteList;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    if (noteList == null) {
      noteList = new List<Note>();
      updateNoteList();
          }
      
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              tooltip: 'AddNote',
              child: Icon(Icons.add),
              onPressed: () {
                debugPrint("Add");
                navigateToDetail(Note('',2,''), 'Add Note');
              },
            ),
            appBar: AppBar(title: Text('Note')),
            body: getNoteList(),
          );
        }
      
        ListView getNoteList() {
          TextStyle titleStyle = Theme.of(context).textTheme.subtitle;
          return ListView.builder(
            itemCount: count,
            itemBuilder: (BuildContext context, int position) {
              return Card(
                color: Colors.white,
                elevation: 2.0,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: getPriorityColor(this.noteList[position].priority),
                    child: getPriorityIcon(this.noteList[position].priority),
                  ),
                  title: Text(this.noteList[position].title, style: titleStyle),
                  subtitle: Text(this.noteList[position].date),
                  trailing: GestureDetector(
                    child: Icon(Icons.delete),
                    onTap: (){
                      deleteNote(context, this.noteList[position].priority);
                      updateNoteList();
                    },
                    ),
                  onTap: () {
                    navigateToDetail(this.noteList[position],'Edit Note');
                  },
                ),
              );
            },
          );
        }
      
        void navigateToDetail(Note note, String title) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return NoteDetail(note, title);
          }));
        }
      
        Color getPriorityColor(int priority) {
          switch (priority) {
            case 1:
              return Colors.red;
              break;
            case 2:
              return Colors.yellow;
              break;
            default:
              return Colors.yellow;
          }
        }
      
        Icon getPriorityIcon(int priority) {
          switch (priority) {
            case 1:
              return Icon(Icons.play_arrow);
              break;
            case 2:
              return Icon(Icons.keyboard_arrow_right);
              break;
      
            default:
              return Icon(Icons.keyboard_arrow_right);
          }
        }
      
        void deleteNote(BuildContext context, int priority) async {
          int result = await databaseHelper.deleteNote(priority);
          if (result != 0) {
            showSnackBar(context, 'Note is successfully Deleted');
          }
        }
      
        void showSnackBar(context, msg) {
          SnackBar snackbar = SnackBar(content: Text(msg));
          Scaffold.of(context).showSnackBar(snackbar);
        }
      
        void updateNoteList() {
          final Future<Database> dbFuture = databaseHelper.initializeDatabase();
          dbFuture.then((database){
            Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
            noteListFuture.then((noteList){
              setState(() {
                this.noteList = noteList;
                this.count = this.noteList.length;
              });
            });
          });
        }
}
