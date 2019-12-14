class Note {
  int _id;
  String _title;
  String _description;
  int _priority;
  String _date;

  Note(this._title, this._priority, this._date, [this._description]);
  Note.withID(this._title, this._priority, this._date, [this._description]);

  int get id => this._id;
  String get title => this.title;
  String get description => this._description;
  int get priority => this._priority;
  String get date => this._date;

  set title(String newTitle) {
    if (title.length <= 255) this._title = newTitle;
  }

  set description(String newDescription) {
    if (newDescription.length <= 255) this._description = newDescription;
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 0) this._priority = newPriority;
  }

  set date(String newDate){
    this._date = newDate;
  }

  //SQLFlite only get and return value in form of map

  //Convert Note object to Map object
  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    if (_id != null)
      map['id'] = _id;
    
    map['title'] = _title;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

  //Convert Map object to Note object
  Note.fromMapObject(Map<String, dynamic> map){
    _id = map['id'];
    _title = map['title'];
    _priority = map['priority'];
    _date = map['date'];
    _description = map['description'];
  }

  
}
