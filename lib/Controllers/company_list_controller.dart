import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:ict_mu_students/Model/company_model.dart';
import '../Helper/Utils.dart';
import '../Network/API.dart';
import 'internet_connectivity.dart';

class CompanyListController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<CompanyModel> companyList = <CompanyModel>[].obs;
  RxList<CompanyModel> filteredCompanyList = <CompanyModel>[].obs; // Added for filtered list
  RxBool isLoadingCompanyList = true.obs;
  final TextEditingController searchController = TextEditingController(); // Added for search input

  @override
  void onInit() {
    super.onInit();
    fetchCompanyList();
    searchController.addListener(() {
      filterCompanies(searchController.text);
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future<void> fetchCompanyList() async {
    isLoadingCompanyList.value = true;
    await internetController.checkConnection();
    if (!internetController.isConnected.value) {
      isLoadingCompanyList.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchCompanyList(),
      );
      return;
    }
    try {
      final response = await http.get(
        Uri.parse(companyListAPI),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': validApiKey,
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as List<dynamic>;
        companyList.assignAll(
          responseData.map((data) => CompanyModel.fromJson(data)).toList(),
        );
        // Initialize filtered list with full list
        filteredCompanyList.assignAll(companyList);
      } else {
        final message =
            json.decode(response.body)['message'] ?? 'An error occurred';
        Get.snackbar(
          "No data available",
          message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get data",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingCompanyList.value = false;
    }
  }

  void filterCompanies(String query) {
    if (query.isEmpty) {
      filteredCompanyList.assignAll(companyList);
    } else {
      filteredCompanyList.assignAll(
        companyList
            .where((company) =>
            company.companyName.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }
}