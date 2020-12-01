// todo object
class Todo {

  int _id;
  String _title;
  String _date;
  String _done = '0'; // init done = 0 (not yet done)
  // String _description;

  int _dateCreated; // millisSinceEpoch

  Todo( this._title, this._date );

  Todo.withId( this._id, this._title, this._date );

  int get id => _id;

  String get title => _title;

  String get date => _date;

  String get done => _done;

  int get dateCreated => _dateCreated;

  set title(String titleInput) {
    if (titleInput.length <= 255) {
      this._title = titleInput;
    }
  }

  set date(String dateInput) {
    this._date = dateInput;
  }

  set done(String doneInput) {
    this._done = doneInput;
  }

  set dateCreated(int dateCreatedInput) {
    this._dateCreated = dateCreatedInput;
  }

  // convert node to map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['date'] = _date;
    map['done'] = _done;
    map['dateCreated'] = _dateCreated;

    return map;
  }

  // extract node from map object
  Todo.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._date = map['date'];
    this._done = map['done'];
    this._dateCreated = map['dateCreated'];
  }

  // updating node to done (done value 1)
  Map<String, dynamic> updateDoneToMap(String doneValue) {
    var map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['date'] = _date;
    map['dateCreated'] = _dateCreated;

    map['done'] = doneValue;

    return map;
  }

}