import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/Components.dart';
import 'package:ict_mu_students/Helper/colors.dart';
import 'package:ict_mu_students/Helper/size.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class FacultyContactCard extends StatelessWidget {
  final String subjectShortName;
  final String subjectName;
  final String facultyName;
  final String mobileNo;

  const FacultyContactCard({
    super.key,
    required this.subjectShortName,
    required this.subjectName,
    required this.facultyName,
    required this.mobileNo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: muGrey, borderRadius: BorderRadius.circular(borderRad)),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HugeIcon(
                      icon: HugeIcons.strokeRoundedBook02, color: muColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: getWidth(context, 0.75),
                      child: Text(
                        "$subjectShortName - ( $subjectName )",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HugeIcon(icon: HugeIcons.strokeRoundedUserCircle, color: muColor),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SizedBox(
                      width: getWidth(context, 0.75),
                      child:Text(facultyName,
                        style: const TextStyle(
                            fontSize: 16,
                            overflow: TextOverflow.visible),
                      ),
                    ),
                  ),
                ],
              ),
              Divider(height: 20,color: muGrey2),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    width: getWidth(context, 0.4),
                    decoration: BoxDecoration(
                      color: muGrey2.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(borderRad*borderRad)
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (mobileNo.isNotEmpty) {
                          Uri whatsappUrl = Uri.parse("https://wa.me/+91$mobileNo");
                          await launchUrl(whatsappUrl);
                        } else {
                          _showErrorSnackbar("Error", "Mobile number is empty");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedWhatsapp,
                            color: Colors.green,
                            size: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "WhatsApp",
                              style: TextStyle(color:Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: getWidth(context, 0.4),
                    decoration: BoxDecoration(
                        color: muGrey2.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(borderRad*borderRad)
                    ),
                    child: TextButton(
                      onPressed: () async {
                        Uri telUrl = Uri.parse("tel:$mobileNo");
                        if (await canLaunchUrl(telUrl)) {
                          await launchUrl(telUrl);
                        } else {
                          _showErrorSnackbar("Error", "Could not launch dialer");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedCall,
                            color:Colors.blue,
                            size: 20,
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              "Call",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.red,
      colorText: backgroundColor,
    );
  }
}
