// api.dart
import 'package:http/http.dart' as http;

// ngrok public URL (changes every time you restart ngrok unless you have a reserved domain)
const String host = "https://noninvincibly-unstocked-rosena.ngrok-free.dev";
// relative path to your PHP API inside htdocs
const String serverPath = "/ict-server-testing/api/index.php";
// build the base URL
const String API_BASE_URL = "$host$serverPath";// Example usage
String validateLoginAPI = "$host$serverPath/Student/login";


// App info
String currentVersion = "1.0";
String validApiKey = "ictmu";
String updateURL = 'https://devanpatel28.blogspot.com/';

// ====================== AUTHENTICATION ======================
String updatePasswordAPI = '$host$serverPath/Password/updatePassword';
String validateVersionAPI = '$host$serverPath/AppVersion/check';
// String validateLoginAPI = '$host$serverPath/Student/login';
String validateLogoutAPI = '$host$serverPath/Student/logout';

// ====================== ATTENDANCE ======================
String totalAttendanceAPI = '$host$serverPath/Attendance/TotalAttendance';
String attendanceByDateAPI = '$host$serverPath/Attendance/AttendanceByDate';

// ====================== PARENT / FACULTY ======================
String facultyContactAPI = '$host$serverPath/Faculty/getFacultyListByStudent';
String timetableAPI = '$host$serverPath/Parent/getStudentTimetable';

// ====================== EXAM ======================
String examListAPI = '$host$serverPath/Exam/getExamList';

// ====================== HOLIDAYS ======================
String holidayListAPI = '$host$serverPath/Holiday/getAllHolidays';
String upcomingHolidayAPI = '$host$serverPath/Holiday/getNextUpcomingHoliday';

// ====================== PLACEMENTS ======================
String recentlyPlacedAPI = '$host$serverPath/Placement/recentlyPlaced';
String companyListAPI = '$host$serverPath/Placement/companyList';
String campusDriveListAPI =
    '$host$serverPath/Placement/campusDriveByStudentList';
String statusUpdateCampusDriveAPI =
    '$host$serverPath/Placement/statusUpdateCampusDrive';
String campusDriveStudentRoundsAPI =
    '$host$serverPath/Placement/campusDriveStudentRoundList';

// ====================== LEAVE ======================
String leaveRequestAPI = '$host$serverPath/Leave/leaveRequest';
String leaveHistoryAPI = '$host$serverPath/Leave/getLeaveHistory';

// ====================== INTERVIEW BANK ======================
String interviewBankListAPI = '$host$serverPath/InterviewBank/list';
String interviewBankCreateAPI = "$host$serverPath/InterviewBank/create";
String interviewBankGetAPI = "$host$serverPath/InterviewBank/get"; // append &id=
String interviewBankUpdateAPI = "$host$serverPath/InterviewBank/update"; // append &id=
String interviewBankDeleteAPI = "$host$serverPath/InterviewBank/delete"; // append &id=


String announcementListAPI = '$host$serverPath/Announcement/list';




// ====================== EVENTS ======================
String eventListAPI = '$host$serverPath/Event/list';
String upcomingEventAPI = '$host$serverPath/Event/getUpcomingEvent';

// ====================== FEEDBACK ======================
String feedbackHistory = '$host$serverPath/Feedback/by-student';
String feedbackAdd = '$host$serverPath/Feedback/add';

// ====================== FACULTY LIST ======================
String facultyListAPI = '$host$serverPath/Faculty/getFacultyListByStudent';

// ====================== IMAGE HANDLERS ======================
String studentImageAPI(gr) {
  // Returns student image by GR number
  return "https://student.marwadiuniversity.ac.in:553/handler/getImage.ashx?SID=$gr";
}

String facultyImageAPI(fId) {
  // Returns faculty image by faculty ID
  return "https://marwadieducation.edu.in/MEFOnline/handler/getImage.ashx?Id=$fId";
}

// ====================== EXAMPLE REQUEST ======================
// ⚠️ Previously this was calling "$API_BASE_URL/students"
// which does not exist in your backend.
// ✅ Updated to call an actual endpoint (Student/list)
Future<void> fetchStudents() async {
  final response = await http.get(Uri.parse("$API_BASE_URL/Student/list"));
  print(response.body);
}
