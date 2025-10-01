import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/Style.dart';
import 'package:ict_mu_students/Helper/colors.dart';
import 'package:ict_mu_students/Helper/size.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Helper/Components.dart';
import '../../Model/company_model.dart';

class CompanyDetailScreen extends StatelessWidget {
  final CompanyModel company; // Pass company object here

  const CompanyDetailScreen({super.key, required this.company});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(company.companyName, style: appbarStyle(context)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: backgroundColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            // Company Icon + Name
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: muColor,
                  child: const HugeIcon(
                    icon: HugeIcons.strokeRoundedHouse01,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Text(
                    company.companyName,
                    style: TextStyle(
                      fontSize: getSize(context, 3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Company Type
            ListTile(
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedBriefcase01,
                color: muColor,
              ),
              title: Text("Type"),
              subtitle: Text(company.companyType),
            ),

            // Website
            ListTile(
              leading: const HugeIcon(
                icon: HugeIcons.strokeRoundedLink02,
                color: Colors.green,
              ),
              title: Text("Website"),
              subtitle: Text(
                company.companyWebsite.isNotEmpty
                    ? company.companyWebsite
                    : "Not Available",
              ),
              onTap: company.companyWebsite.isNotEmpty
                  ? () => _launchUrl(company.companyWebsite)
                  : null,
            ),

            // LinkedIn
            ListTile(
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedLinkedin01,
                color: LinkedinColor,
              ),
              title: Text("LinkedIn"),
              subtitle: Text(
                company.companyLinkedin.isNotEmpty
                    ? company.companyLinkedin
                    : "Not Available",
              ),
              onTap: company.companyLinkedin.isNotEmpty
                  ? () => _launchUrl(company.companyLinkedin)
                  : null,
            ),

            // Add more details if available
            const SizedBox(height: 20),
            Text(
              "About Company",
              style: TextStyle(
                fontSize: getSize(context, 2.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              (company.aboutCompany !=null &&
                  company.aboutCompany.trim().isNotEmpty &&
                  company.aboutCompany.toLowerCase() != "not available")
                  ? company.aboutCompany
                  : "No description provided.",
              style: TextStyle(fontSize: getSize(context, 2)),
            ),
          ],
        ),
      ),
    );
  }
}
