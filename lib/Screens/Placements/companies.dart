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

//for url validation
bool isValidUrl(String? url) {
  if (url == null || url.isEmpty) return false;
  final Uri? uri = Uri.tryParse(url);
  return uri != null && (uri.isScheme("http") || uri.isScheme("https"));
}

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _CompanyScreenState();
}

class _CompanyScreenState extends State<CompanyScreen> {
  final CompanyListController controller = Get.put(CompanyListController());
  String? selectedDomain; // dropdown filter
  final FocusNode focusNode = FocusNode();

  Future<void> _launchUrl(String? url, {bool isLinkedIn = false}) async {
    if (url == null || url.isEmpty) return;

    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: isLinkedIn
            ? LaunchMode.externalApplication
            : LaunchMode.platformDefault,
      );
    } else {
      Get.snackbar("Error", "Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Companies", style: appbarStyle(context)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingCompanyList.value) {
          return const AdaptiveLoadingScreen();
        }

        // Get all unique domains
        List<String> allDomains = controller.companyList
            .expand((c) => c.companyDomain)
            .toSet()
            .toList();

        // Filter based on search + domain
        final query = controller.searchController.text.toLowerCase();
        final filteredCompanies = controller.companyList.where((company) {
          final matchesSearch =
          company.companyName.toLowerCase().contains(query);
          final matchesDomain = selectedDomain == null
              ? true
              : company.companyDomain.contains(selectedDomain);
          return matchesSearch && matchesDomain;
        }).toList();

        return RefreshIndicator(
          onRefresh: () => controller.fetchCompanyList(),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: TextField(
                  controller: controller.searchController,
                  cursorColor: muColor,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Search Companies',
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    labelStyle: TextStyle(fontFamily: "mu_reg", color: muGrey2),
                    prefixIcon: HugeIcon(
                        icon: HugeIcons.strokeRoundedSearch01,
                        color: focusNode.hasPrimaryFocus ? muColor : muGrey2),
                    suffixIcon: controller.searchController.text.isNotEmpty
                        ? IconButton(
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedCancel01,
                        color:
                        focusNode.hasFocus ? muColor : muGrey2,
                      ),
                      onPressed: () {
                        controller.searchController.clear();
                        setState(() => selectedDomain = null);
                      },
                    )
                        : null,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: muColor),
                      borderRadius: BorderRadius.circular(borderRad),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: muGrey2),
                      borderRadius: BorderRadius.circular(borderRad),
                    ),
                  ),
                  style: TextStyle(
                    fontSize: getSize(context, 2.5),
                    fontFamily: "mu_reg",
                    fontWeight: FontWeight.w500,
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),

              const SizedBox(height: 10),

              // Domain filter dropdown
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DropdownButtonFormField<String>(
                  value: selectedDomain,
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRad),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10),
                  ),
                  hint: const Text("Filter by Domain"),
                  items: [
                    const DropdownMenuItem(
                        value: null, child: Text("All Domains")),
                    ...allDomains.map((d) =>
                        DropdownMenuItem(value: d, child: Text(d))),
                  ],
                  onChanged: (value) {
                    setState(() => selectedDomain = value);
                  },
                ),
              ),

              const SizedBox(height: 10),

              // Companies list
              Expanded(
                child: filteredCompanies.isEmpty
                    ? Center(
                  child: Text(
                    "No companies found",
                    style: TextStyle(
                        fontSize: getSize(context, 2),
                        color: muGrey),
                  ),
                )
                    : ListView.builder(
                  itemCount: filteredCompanies.length,
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                  itemBuilder: (context, index) {
                    final company = filteredCompanies[index];
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
                                                    context, 1.8)),
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
                                                .strokeRoundedLayers01,
                                            color: muColor),
                                        const SizedBox(width: 7),
                                        Flexible(
                                          child: Text(
                                            company.companyDomain
                                                .join(", "),
                                            style: TextStyle(
                                              fontSize: getSize(
                                                  context, 1.7),
                                              color: muGrey2,
                                            ),
                                            overflow:
                                            TextOverflow.ellipsis,
                                            maxLines: 2,
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
                                    onPressed: !isValidUrl(
                                        company.companyWebsite)
                                        ? null
                                        : () =>
                                        _launchUrl(company.companyWebsite),
                                    icon: HugeIcon(
                                      icon: HugeIcons
                                          .strokeRoundedLink02,
                                      color: !isValidUrl(
                                          company.companyWebsite)
                                          ? Colors.white54
                                          : Colors.white,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: !isValidUrl(
                                          company.companyWebsite)
                                          ? Colors.grey
                                          : Colors.lightGreen,
                                      disabledBackgroundColor:
                                      Colors.grey,
                                    ),
                                    tooltip: "Website",
                                  ),
                                  const SizedBox(width: 5),
                                  IconButton(
                                    onPressed: !isValidUrl(
                                        company.companyLinkedin)
                                        ? null
                                        : () => _launchUrl(
                                        company.companyLinkedin,
                                        isLinkedIn: true),
                                    icon: HugeIcon(
                                      icon: HugeIcons
                                          .strokeRoundedLinkedin01,
                                      color: !isValidUrl(
                                          company.companyLinkedin)
                                          ? Colors.white54
                                          : Colors.white,
                                    ),
                                    style: IconButton.styleFrom(
                                      backgroundColor: !isValidUrl(
                                          company.companyLinkedin)
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
        );
      }),
    );
  }
}
