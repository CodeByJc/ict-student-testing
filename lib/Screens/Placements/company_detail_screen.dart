import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Helper/Style.dart';
import 'package:ict_mu_students/Helper/colors.dart';
import 'package:ict_mu_students/Helper/size.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Helper/Components.dart';
import '../../Model/company_model.dart';

/// ✅ URL validation helper
bool isValidUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  final Uri? uri = Uri.tryParse(url);
  return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
}

class CompanyDetailScreen extends StatelessWidget {
  final CompanyModel company;

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
    // ✅ Validate URLs
    final bool validWebsite = isValidUrl(company.companyWebsite);
    final bool validLinkedin = isValidUrl(company.companyLinkedin);
    print(company.aboutCompany);
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
            // ✅ Company Icon + Name
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

            // ✅ Company Type
            ListTile(
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedBriefcase01,
                color: muColor,
              ),
              title: const Text("Type"),
              subtitle: Text(company.companyType),
            ),

            // ✅ Website (no gray background)
            ListTile(
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedLink02,
                color: validWebsite ? Colors.green : Colors.grey,
              ),
              title: const Text("Website"),
              subtitle: Text(
                validWebsite ? company.companyWebsite : "Not Available",
                style: TextStyle(
                  color: validWebsite ? Colors.blue : muGrey2,
                  decoration:
                  validWebsite ? TextDecoration.underline : null,
                ),
              ),
              onTap: validWebsite
                  ? () => _launchUrl(company.companyWebsite)
                  : null,
            ),

            // ✅ LinkedIn (no gray background)
            ListTile(
              leading: HugeIcon(
                icon: HugeIcons.strokeRoundedLinkedin01,
                color: validLinkedin ? LinkedinColor : Colors.grey,
              ),
              title: const Text("LinkedIn"),
              subtitle: Text(
                validLinkedin ? company.companyLinkedin : "Not Available",
                style: TextStyle(
                  color: validLinkedin ? Colors.blue : muGrey2,
                  decoration:
                  validLinkedin ? TextDecoration.underline : null,
                ),
              ),
              onTap: validLinkedin
                  ? () => _launchUrl(company.companyLinkedin)
                  : null,
            ),

            const SizedBox(height: 20),

            // ✅ About Section
            Text(
              "About Company",
              style: TextStyle(
                fontSize: getSize(context, 2.5),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              (company.aboutCompany != null &&
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
