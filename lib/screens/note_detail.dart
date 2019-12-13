import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteDetail extends StatefulWidget {
  var appBarTitle;
  NoteDetail(String appBarTitle){
    this.appBarTitle = appBarTitle;
  }
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(appBarTitle);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String appBarTitle;
  NoteDetailState(appBarTitle){
    this.appBarTitle = appBarTitle;
  }
  var dropDown = ['Low', 'High'];
  var selectedValue = 'Low';
  var minimumPadding = 5.0;
  // @override
  // void initState() {
  //   super.initState();
  //   selectedValue = dropDown[0];
  // }
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle;

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
              value: selectedValue,
              style: textStyle,
              onChanged: (String newValueSelected) {
                setState(() {
                  selectedValue = newValueSelected;
                });
              },
            ),
            Padding(
                padding: EdgeInsets.only(
                    top: minimumPadding, bottom: minimumPadding),
                child: TextFormField(
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
                child: TextFormField(
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

                    },
                  ),
                ),
                Container(width: 5.0),
                Expanded(
                  child: RaisedButton(
                    color: Theme.of(context).primaryColorDark,
                    textColor: Theme.of(context).primaryColorLight,
                    child: Text('DELETE'),
                    onPressed: () {},
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
