import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Helper/Utils.dart';
import '../Model/job_market_model.dart';
import 'internet_connectivity.dart';

class JobMarketController extends GetxController {
  final internetController = Get.find<InternetConnectivityController>();
  RxList<JobMarketModel> jobMarketDataList = <JobMarketModel>[].obs;
  RxList<JobMarketInsight> insightsList = <JobMarketInsight>[].obs;
  RxBool isLoadingJobMarket = true.obs;
  RxString selectedCategory = 'All'.obs;

  // Sample data for demonstration - in real app, this would come from API
  final List<JobMarketModel> _sampleJobMarketData = [
    JobMarketModel(
      domain: "Web Development",
      category: "Software",
      marketShare: 25.5,
      growthRate: 12.3,
      totalJobs: 45000,
      averageSalary: 650000,
      description:
      "Full-stack web development including frontend and backend technologies",
      skills: ["React", "Node.js", "JavaScript", "Python", "HTML/CSS"],
      futureOutlook: "High demand expected with 15% growth in next 2 years",
      demandLevel: 5,
    ),
    JobMarketModel(
      domain: "Mobile App Development",
      category: "Software",
      marketShare: 18.2,
      growthRate: 18.7,
      totalJobs: 32000,
      averageSalary: 720000,
      description: "Native and cross-platform mobile application development",
      skills: ["Flutter", "React Native", "Swift", "Kotlin", "Dart"],
      futureOutlook: "Explosive growth expected with 25% increase in demand",
      demandLevel: 5,
    ),
    JobMarketModel(
      domain: "Cloud Engineering",
      category: "Software",
      marketShare: 15.8,
      growthRate: 22.1,
      totalJobs: 28000,
      averageSalary: 850000,
      description:
      "Cloud infrastructure, DevOps, and cloud-native application development",
      skills: ["AWS", "Azure", "Docker", "Kubernetes", "Terraform"],
      futureOutlook: "Critical skill with 30% growth projected",
      demandLevel: 5,
    ),
    JobMarketModel(
      domain: "VLSI Design",
      category: "Hardware",
      marketShare: 8.5,
      growthRate: 8.9,
      totalJobs: 12000,
      averageSalary: 950000,
      description:
      "Very Large Scale Integration design and semiconductor development",
      skills: ["Verilog", "VHDL", "Cadence", "Synopsys", "SystemVerilog"],
      futureOutlook: "Steady growth with increasing semiconductor demand",
      demandLevel: 4,
    ),
    JobMarketModel(
      domain: "Embedded Systems",
      category: "Hardware",
      marketShare: 12.3,
      growthRate: 14.2,
      totalJobs: 18000,
      averageSalary: 680000,
      description: "Embedded software development for IoT and hardware systems",
      skills: ["C/C++", "ARM", "RTOS", "Microcontrollers", "IoT"],
      futureOutlook: "Growing with IoT and smart device adoption",
      demandLevel: 4,
    ),
    JobMarketModel(
      domain: "Data Science",
      category: "Software",
      marketShare: 14.7,
      growthRate: 19.5,
      totalJobs: 26000,
      averageSalary: 780000,
      description: "Data analysis, machine learning, and AI implementation",
      skills: ["Python", "R", "TensorFlow", "SQL", "Statistics"],
      futureOutlook: "High growth with AI and ML adoption",
      demandLevel: 5,
    ),
    JobMarketModel(
      domain: "Cybersecurity",
      category: "Software",
      marketShare: 9.2,
      growthRate: 16.8,
      totalJobs: 16000,
      averageSalary: 820000,
      description:
      "Information security, network security, and threat analysis",
      skills: [
        "Ethical Hacking",
        "Network Security",
        "Cryptography",
        "SIEM",
        "Penetration Testing"
      ],
      futureOutlook: "Critical need with increasing cyber threats",
      demandLevel: 5,
    ),
    JobMarketModel(
      domain: "Game Development",
      category: "Software",
      marketShare: 6.8,
      growthRate: 11.4,
      totalJobs: 12000,
      averageSalary: 580000,
      description: "Game design, development, and programming",
      skills: ["Unity", "Unreal Engine", "C#", "C++", "Game Design"],
      futureOutlook: "Growing with mobile and VR gaming markets",
      demandLevel: 3,
    ),
  ];

  final List<JobMarketInsight> _sampleInsights = [
    JobMarketInsight(
      title: "Cloud Engineering is the Future",
      description:
      "Cloud engineering shows the highest growth rate at 22.1% with increasing demand for cloud-native applications.",
      type: "trend",
      confidence: 0.95,
    ),
    JobMarketInsight(
      title: "Mobile Development Surge",
      description:
      "Mobile app development is experiencing explosive growth with 18.7% increase, driven by digital transformation.",
      type: "opportunity",
      confidence: 0.88,
    ),
    JobMarketInsight(
      title: "Cybersecurity Critical Need",
      description:
      "With increasing cyber threats, cybersecurity professionals are in high demand with 16.8% growth rate.",
      type: "warning",
      confidence: 0.92,
    ),
    JobMarketInsight(
      title: "VLSI Steady Growth",
      description:
      "VLSI design maintains steady growth with semiconductor industry expansion and IoT device proliferation.",
      type: "trend",
      confidence: 0.85,
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    fetchJobMarketData();
  }

  Future<void> fetchJobMarketData() async {
    isLoadingJobMarket.value = true;
    await internetController.checkConnection();

    if (!internetController.isConnected.value) {
      isLoadingJobMarket.value = false;
      Utils().showInternetAlert(
        context: Get.context!,
        onConfirm: () => fetchJobMarketData(),
      );
      return;
    }

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, you would make an API call here
      // For now, we'll use sample data
      jobMarketDataList.assignAll(_sampleJobMarketData);
      insightsList.assignAll(_sampleInsights);
    } catch (e) {
      print('Error fetching job market data: $e');
      Get.snackbar(
        "Error",
        "Failed to get job market data: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoadingJobMarket.value = false;
    }
  }

  void filterByCategory(String category) {
    selectedCategory.value = category;
    if (category == 'All') {
      jobMarketDataList.assignAll(_sampleJobMarketData);
    } else {
      jobMarketDataList.assignAll(
        _sampleJobMarketData.where((job) => job.category == category).toList(),
      );
    }
  }

  List<JobMarketModel> getTopGrowingDomains() {
    return jobMarketDataList.where((job) => job.growthRate != null).toList()
      ..sort((a, b) => b.growthRate!.compareTo(a.growthRate!));
  }

  List<JobMarketModel> getHighestPayingDomains() {
    return jobMarketDataList.where((job) => job.averageSalary != null).toList()
      ..sort((a, b) => b.averageSalary!.compareTo(a.averageSalary!));
  }

  List<JobMarketModel> getMostInDemandDomains() {
    return jobMarketDataList.where((job) => job.demandLevel != null).toList()
      ..sort((a, b) => b.demandLevel!.compareTo(a.demandLevel!));
  }

  double getTotalMarketShare() {
    return jobMarketDataList.fold(
        0.0, (sum, job) => sum + (job.marketShare ?? 0));
  }

  int getTotalJobs() {
    return jobMarketDataList.fold(0, (sum, job) => sum + (job.totalJobs ?? 0));
  }
}