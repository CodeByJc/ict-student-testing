class UserData {
  ParentDetails? parentDetails;
  StudentDetails? studentDetails;
  ClassDetails? classDetails;

  UserData({this.parentDetails, this.studentDetails, this.classDetails});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      parentDetails: json['parent_details'] != null ? ParentDetails.fromJson(json['parent_details']) : null,
      studentDetails: json['student_details'] != null ? StudentDetails.fromJson(json['student_details']) : null,
      classDetails: json['class_details'] != null ? ClassDetails.fromJson(json['class_details']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_details': parentDetails?.toJson(),
      'student_details': studentDetails?.toJson(),
      'class_details': classDetails?.toJson(),
    };
  }
}

class ParentDetails {
  int? parentId;
  String? parentName;
  String? profession;
  String? email;
  String? phone;

  ParentDetails({this.parentId, this.parentName, this.profession, this.email, this.phone});

  factory ParentDetails.fromJson(Map<String, dynamic> json) {
    return ParentDetails(
      parentId: json['parent_id'],
      parentName: json['parent_name'],
      profession: json['profession'],
      email: json['p_email'],
      phone: json['p_phone_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_id': parentId,
      'parent_name': parentName,
      'profession': profession,
      'p_email': email,
      'p_phone_no': phone,
    };
  }
}

class StudentDetails {
  int? studentId;
  String? enrollmentNo;
  String? grNo;
  String? firstName;
  String? lastName;
  String? course;
  int? batchId;
  int? batchStartYear;
  int? batchEndYear;
  String? email;
  String? phone;

  StudentDetails(
      {this.studentId, this.enrollmentNo, this.grNo, this.firstName, this.lastName, this.course,this.batchId, this.batchStartYear, this.batchEndYear, this.email, this.phone});

  factory StudentDetails.fromJson(Map<String, dynamic> json) {
    return StudentDetails(
      studentId: json['student_id'],
      enrollmentNo: json['enrollment_no'],
      grNo: json['gr_no'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      course: json['course'],
      batchId: json['batch_info_id'],
      batchStartYear: json['batch_start_year'],
      batchEndYear: json['batch_end_year'],
      email: json['s_email'],
      phone: json['s_phone_no'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'enrollment_no': enrollmentNo,
      'gr_no': grNo,
      'first_name': firstName,
      'last_name': lastName,
      'course': course,
      'batch_info_id':batchId,
      'batch_start_year': batchStartYear,
      'batch_end_year': batchEndYear,
      's_email': email,
      's_phone_no': phone,
    };
  }
}

class ClassDetails {
  int? classId;
  String? className;
  int? semester;
  int? semId;
  String? batch;

  ClassDetails({this.classId,this.semId, this.className, this.semester, this.batch});

  factory ClassDetails.fromJson(Map<String, dynamic> json) {
    return ClassDetails(
      classId: json['class_id'],
      className: json['classname'],
      semester: json['semester'],
      batch: json['batch'],
      semId: json['sem_id']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'class_id': classId,
      'classname': className,
      'semester': semester,
      'batch': batch,
      'sem_id':semId
    };
  }
}
