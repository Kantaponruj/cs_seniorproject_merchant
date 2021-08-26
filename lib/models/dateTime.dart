class DateTime {
  String openTime;
  String closeTime;
  List dates = [];

  DateTime();

  DateTime.fromMap(Map<String, dynamic> data) {
    openTime = data['openTime'];
    closeTime = data['closeTime'];
    dates = data['date'];
  }

  Map<String, dynamic> toMap() {
    return {'openTime': openTime, 'closeTime': closeTime, 'date': dates};
  }
}