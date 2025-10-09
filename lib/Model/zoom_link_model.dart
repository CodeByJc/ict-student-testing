class ZoomLinkModel {
  String zoomLink;
  String zoomDate;
  String zoomTime;
  String zoomTitle;
  String facultyName;

  ZoomLinkModel({
    required this.zoomLink,
    required this.zoomDate,
    required this.zoomTime,
    required this.zoomTitle,
    required this.facultyName
  });

  factory ZoomLinkModel.fromJson(Map<String, dynamic> json) {
    return ZoomLinkModel(
        zoomLink :json['zoom_link'],
        zoomDate: json['zoom_date'],
        zoomTime :json['zoom_link_time'],
        zoomTitle :json['zoom_link_title'],
        facultyName :json['faculty_name']

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'zoom_link': zoomLink,
      'zoom_date': zoomDate,
      'zoom_link_time': zoomTime,
      'zoom_link_title': zoomTitle,
      'faculty_name': facultyName
    };
  }
}