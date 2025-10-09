class HolidayListModel {
  int id;
  String holidayName;
  String holidayDate;

  HolidayListModel({
    required this.id,
    required this.holidayName,
    required this.holidayDate
  });

  factory HolidayListModel.fromJson(Map<String, dynamic> json) {
    return HolidayListModel(
        id :json['id'],
        holidayName: json['holiday_name'] ?? "",
        holidayDate :json['holiday_date'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'holiday_name': holidayName,
      'holiday_date': holidayDate,
    };
  }
}