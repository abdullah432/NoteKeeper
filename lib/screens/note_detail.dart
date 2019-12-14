import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  NoteDetail(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(note, appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  Note note;
  NoteDetailState(this.note, this.appBarTitle);
  var dropDown = ['Low', 'High'];
  var minimumPadding = 5.0;
  DatabaseHelper databaseHelper = DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  
  // @override
  // void initState() {
  //   super.initState();
  //   selectedValue = dropDown[0];
  // }
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = this.note.title;
    descriptionController.text = this.note.description;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                moveToLastScreen();
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15, left: 10, right: 10),
            child: ListView(
              children: <Widget>[
                DropdownButton<String>(
                  items: dropDown.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: getPriorityAsString(note.priority),
                  style: textStyle,
                  onChanged: (String newValueSelected) {
                    setState(() {
                      updatePriorityAsInt(newValueSelected);
                    });
                  },
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: minimumPadding * 3, bottom: minimumPadding) * 2,
                    child: TextFormField(
                      controller: titleController,
                      onChanged: (value) {
                        updateTitle();
                      },
                      decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: textStyle,
                          hintText: 'Enter Title',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      style: textStyle,
                    )),
                Padding(
                    padding: EdgeInsets.only(
                        top: minimumPadding * 3, bottom: minimumPadding * 5),
                    child: TextField(
                      controller: descriptionController,
                      onChanged: (value) {
                        updateDescription();
                      },
                      decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: textStyle,
                          hintText: 'Enter Description',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5))),
                      style: textStyle,
                    )),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('SAVE', style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          saveButton();
                        },
                      ),
                    ),
                    Container(width: 5.0),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text('DELETE', style: TextStyle(fontSize: 16)),
                        onPressed: () {
                          deleteButton();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void updatePriorityAsInt(String priority) {
    switch (priority) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = 'High';
        break;
      case 2:
        priority = 'Low';
        break;
      default:
        priority = 'Low';
    }
    return priority;
  }

  void updateTitle() {
    this.note.title = titleController.text;
  }

  void updateDescription() {
    this.note.description = descriptionController.text;
  }

  void saveButton() async {

    moveToLastScreen();

    int result;
    note.date = DateFormat.yMMMd().format(DateTime.now());

    if (note.id == null) {
      //insert operation
      result = await databaseHelper.insertNote(note);
      debugPrint('insert operation');
    } else {
      //update operation
      debugPrint('update operation');
      result = await databaseHelper.updateNote(note);
    }

    if (result != 0) {
      showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      showAlertDialog('Status', 'Fail to Saved');
    }
  }

  void deleteButton() async {

    moveToLastScreen();

    if (note.id == null) {
      showAlertDialog('Status', 'No node was deleted');
      return;
    } else {
      databaseHelper.deleteNote(note.id);
    }
  }

  void showAlertDialog(String title, String msg) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(msg));
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
