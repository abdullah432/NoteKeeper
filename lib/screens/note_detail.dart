import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper/models/note.dart';
import 'package:notekeeper/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String appBarTitle;
  Note note;
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
  var selectedValue = 'Low';
  var minimumPadding = 5.0;
  DatabaseHelper databaseHelper = new DatabaseHelper();

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  // @override
  // void initState() {
  //   super.initState();
  //   selectedValue = dropDown[0];
  // }
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;

    titleController.text = this.note.title;
    descriptionController.text = this.note.description;

    return Scaffold(
      appBar: AppBar(title: Text(appBarTitle)),
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
              value: getPriorityAsString(this.note.priority),
              style: textStyle,
              onChanged: (String newValueSelected) {
                setState(() {
                  updatePriorityAsInt(newValueSelected);
                });
              },
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: minimumPadding, bottom: minimumPadding),
                child: TextField(
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
                    top: minimumPadding, bottom: minimumPadding),
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
                    child: Text('SAVE'),
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
                    child: Text('DELETE'),
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
    );
  }

  void updatePriorityAsInt(String priority) {
    switch (priority) {
      case 'High':
        this.note.priority = 2;
        break;
      case 'Low':
        this.note.priority = 1;
        break;
    }
  }

  String getPriorityAsString(int priority) {
    switch (priority) {
      case 1:
        selectedValue = dropDown[0];
        return selectedValue;
        break;
      case 2:
        selectedValue = dropDown[1];
        return selectedValue;
        break;
      default:
        return 'Low';
    }
  }

  void updateTitle() {
    this.note.title = titleController.text;
  }

  void updateDescription() {
    this.note.description = titleController.text;
  }

  void saveButton() async {
    int result;
    note.date = DateFormat.yMMMd().format(DateTime.now());

    if (note.id == null) {
      //insert operation
      result = await databaseHelper.updateNote(note);
    } else {
      //update operation
      result = await databaseHelper.insertNote(note);
    }

    if (result != 0) {
      showAlertDialog('Status', 'Note Saved Successfully');
    } else {
      showAlertDialog('Status', 'Note not Saved');
    }
  }

  void deleteButton()async{
    if (note.id == null){
      showAlertDialog('Status', 'No node was deleted');
      return;
    }else {
      databaseHelper.deleteNote(note.id);
    }
  }

  void showAlertDialog(String title, String msg) {
    AlertDialog alertDialog =
        AlertDialog(title: Text(title), content: Text(msg));
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
