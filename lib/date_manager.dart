class DateManager {
  static final DateManager instance = DateManager._internal();
  late DateTime _date;

  DateManager._internal() {
    _date = DateTime.now();
  }

  void setDate(DateTime date) {
    _date = date;
  }

  DateTime get date => _date;
}