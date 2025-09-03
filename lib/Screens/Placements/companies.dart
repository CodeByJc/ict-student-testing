import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_mu_students/Animations/slide_zoom_in_animation.dart';
import 'package:ict_mu_students/Controllers/company_list_controller.dart';
import 'package:ict_mu_students/Helper/Style.dart';
import 'package:ict_mu_students/Screens/Loading/adaptive_loading_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Helper/Components.dart';
import '../../Helper/colors.dart';
import '../../Helper/size.dart';

class CompanyScreen extends GetView<CompanyListController> {
  const CompanyScreen({super.key});

  Future<void> _launchUrl(String? url, {bool isLinkedIn = false}) async {
    if (url == null || url.isEmpty) return;

    final Uri uri = Uri.parse(url);
    if (isLinkedIn) {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } else {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      } else {
        Get.snackbar("Error", "Could not launch $url");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define FocusNode for TextField focus tracking
    final FocusNode focusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Companies",
          style: appbarStyle(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(
            () => RefreshIndicator(
          onRefresh: () => controller.fetchCompanyList(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: TextField(
                  controller: controller.searchController,
                  cursorColor: muColor,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Search Companies',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(
                      fontFamily: "mu_reg",
                      color: muGrey2,
                    ),
                    prefixIcon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSearch01,
                      color:focusNode.hasPrimaryFocus ? muColor : muGrey2
                    ),
                    suffixIcon: controller.searchController.text.isNotEmpty
                        ? IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedCancel01,
                        color: focusNode.hasFocus ? muColor : muGrey2,
                      ),
                      onPressed: () {
                        controller.searchController.clear();
                        controller.filterCompanies('');
                      },
                    )
                        : null,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: muColor),
                      borderRadius: BorderRadius.circular(borderRad),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: muGrey2),
                      borderRadius: BorderRadius.circular(borderRad),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: getSize(context, 2.5),
                    fontFamily: "mu_reg",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: controller.isLoadingCompanyList.value
                    ? const AdaptiveLoadingScreen()
                    : controller.filteredCompanyList.isEmpty
                    ? Center(
                  child: Text(
                    "No companies found",
                    style: TextStyle(
                      fontSize: getSize(context, 2),
                      color: muGrey2,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: controller.filteredCompanyList.length,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  itemBuilder: (context, index) {
                    final company = controller.filteredCompanyList[index];
                    return SlideZoomInAnimation(
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: muGrey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedHouse01,
                                            color: muColor),
                                        const SizedBox(width: 7),
                                        Flexible(
                                          child: Text(
                                            company.companyName,
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              fontSize:
                                              getSize(context, 2),
                                            ),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        HugeIcon(
                                            icon: HugeIcons
                                                .strokeRoundedBriefcase01,
                                            color: muColor),
                                        const SizedBox(width: 7),
                                        Flexible(
                                          child: Text(
                                            company.companyType,
                                            style: TextStyle(
                                              fontSize: getSize(
                                                  context, 1.8),
                                            ),
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: company.companyWebsite
                                        .isEmpty
                                        ? null
                                        : () => _launchUrl(
                                        company.companyWebsite),
                                    icon: HugeIcon(
                                      icon: HugeIcons
                                          .strokeRoundedLink02,
                                      color: company.companyWebsite
                                          .isEmpty
                                          ? Colors.grey
                                          : Colors.white,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: company
                                          .companyWebsite.isEmpty
                                          ? Colors.grey
                                          : Colors.lightGreen,
                                      disabledBackgroundColor:
                                      Colors.grey,
                                    ),
                                    tooltip: "Website",
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    onPressed: company.companyLinkedin
                                        .isEmpty
                                        ? null
                                        : () => _launchUrl(
                                        company.companyLinkedin,
                                        isLinkedIn: true),
                                    icon: HugeIcon(
                                      icon: HugeIcons
                                          .strokeRoundedLinkedin01,
                                      color: company.companyLinkedin
                                          .isEmpty
                                          ? Colors.white54
                                          : Colors.white,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: company
                                          .companyLinkedin.isEmpty
                                          ? Colors.grey
                                          : LinkedinColor,
                                      disabledBackgroundColor:
                                      Colors.grey,
                                    ),
                                    tooltip: "LinkedIn",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}