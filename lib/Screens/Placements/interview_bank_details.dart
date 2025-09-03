import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Controllers/interview_bank_controller.dart';
import 'package:ict_mu_students/Helper/size.dart';
import 'package:ict_mu_students/Model/interview_bank_model.dart';
import 'package:ict_mu_students/Widgets/html_clickable_text.dart';
import 'package:intl/intl.dart';
import '../../Helper/Components.dart';
import '../../Helper/Style.dart';
import '../../Helper/colors.dart';

class InterviewBankDetails extends GetView<InterviewBankController> {
  const InterviewBankDetails({super.key});
  @override
  Widget build(BuildContext context) {

    InterviewBankModel interview = Get.arguments['interview']; 


    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Interview Details",
            style: appbarStyle(context),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body:
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: muGrey,
                    borderRadius: BorderRadius.circular(borderRad)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            HugeIcon(icon: HugeIcons.strokeRoundedBuilding05, color: muColor),
                            const SizedBox(width: 10,),
                            Flexible(child: Text(interview.IBCompanyName,style: TextStyle(fontSize: getSize(context, 2),fontWeight: FontWeight.bold),)),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            HugeIcon(icon: HugeIcons.strokeRoundedTag01, color: muColor),
                            const SizedBox(width: 10,),
                            Flexible(child: Text(interview.IBCompanyType,style: TextStyle(fontSize: getSize(context, 2)))),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            HugeIcon(icon: HugeIcons.strokeRoundedUser, color: muColor),
                            const SizedBox(width: 10,),
                            Text(interview.IBStudentName,style: TextStyle(fontSize: getSize(context, 2))),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            HugeIcon(icon: HugeIcons.strokeRoundedCalendar01, color: muColor),
                            const SizedBox(width: 10,),
                            Text(DateFormat('dd-MM-yyyy').format(DateFormat('yyyy-MM-dd').parse(interview.IBDate))),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30,child: Divider(color: muGrey2,),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlClickableText(htmlData: interview.IBData,),
                ),
              ],
            ),
          ),
        )

    );
  }
}
