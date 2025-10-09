import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../Controllers/job_market_controller.dart';
import '../../Helper/colors.dart';
import '../../Model/job_market_model.dart';

class LiveJobMarketScreen extends StatefulWidget {
  const LiveJobMarketScreen({super.key});

  @override
  State<LiveJobMarketScreen> createState() => _LiveJobMarketScreenState();
}

class _LiveJobMarketScreenState extends State<LiveJobMarketScreen> {
  final JobMarketController controller = Get.find<JobMarketController>();
  static const String _jobMarketApiKey =
      "ak_40wwiabbaod23azznz64370wrdg6uq19bsld6vyq5gs114w";
  // Replace with your live API endpoint if different
  static const String _jobMarketApiUrl =
      "https://market.ict-connect.example/api/job-market/live";

  @override
  void initState() {
    super.initState();
    // Trigger initial load using inline API configuration
    controller.fetchJobMarketData(
      apiKey: _jobMarketApiKey,
      apiUrl: _jobMarketApiUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Live Job Market",
          style: TextStyle(
            fontFamily: "mu_reg",
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: muColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (controller.isLoadingJobMarket.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(muColor),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(),
              const SizedBox(height: 20),
              _buildCategoryFilter(),
              const SizedBox(height: 20),
              _buildMarketOverview(),
              const SizedBox(height: 20),
              _buildGrowthChart(),
              const SizedBox(height: 20),
              _buildSalaryChart(),
              const SizedBox(height: 20),
              _buildJobDomainsList(),
              const SizedBox(height: 20),
              _buildInsightsSection(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [muColor, Color(0xFF0098B5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedRanking,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                const Text(
                  "Live Job Market Insights",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: "mu_reg",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Real-time data on India's tech job market across software and hardware domains",
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
                fontFamily: "mu_reg",
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatCard(
                    "Total Jobs", "${controller.getTotalJobs()}", Icons.work),
                const SizedBox(width: 16),
                _buildStatCard("Domains",
                    "${controller.jobMarketDataList.length}", Icons.category),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "mu_reg",
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontFamily: "mu_reg",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Filter by Category",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: "mu_reg",
              ),
            ),
            const SizedBox(height: 12),
            Obx(() => Row(
                  children: [
                    _buildFilterChip(
                        "All", controller.selectedCategory.value == "All"),
                    const SizedBox(width: 8),
                    _buildFilterChip("Software",
                        controller.selectedCategory.value == "Software"),
                    const SizedBox(width: 8),
                    _buildFilterChip("Hardware",
                        controller.selectedCategory.value == "Hardware"),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.filterByCategory(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? muColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontFamily: "mu_reg",
          ),
        ),
      ),
    );
  }

  Widget _buildMarketOverview() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Market Overview",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "mu_reg",
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => SfCircularChart(
                  series: <CircularSeries>[
                    DoughnutSeries<JobMarketModel, String>(
                      dataSource: controller.jobMarketDataList,
                      xValueMapper: (JobMarketModel data, _) => data.domain,
                      yValueMapper: (JobMarketModel data, _) =>
                          data.marketShare,
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.outside,
                      ),
                      enableTooltip: true,
                    ),
                  ],
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Growth Rate by Domain",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "mu_reg",
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    primaryYAxis: const NumericAxis(
                      title: AxisTitle(text: 'Growth Rate (%)'),
                    ),
                    series: <CartesianSeries>[
                      ColumnSeries<JobMarketModel, String>(
                        dataSource: controller.jobMarketDataList,
                        xValueMapper: (JobMarketModel data, _) => data.domain,
                        yValueMapper: (JobMarketModel data, _) =>
                            data.growthRate,
                        color: muColor,
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildSalaryChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Average Salary by Domain",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "mu_reg",
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => SizedBox(
                  height: 300,
                  child: SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(text: 'Salary (₹)'),
                      numberFormat: NumberFormat.compact(),
                    ),
                    series: <CartesianSeries>[
                      BarSeries<JobMarketModel, String>(
                        dataSource: controller.jobMarketDataList,
                        xValueMapper: (JobMarketModel data, _) => data.domain,
                        yValueMapper: (JobMarketModel data, _) =>
                            data.averageSalary,
                        color: const Color(0xFF4CAF50),
                        dataLabelSettings:
                            const DataLabelSettings(isVisible: true),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDomainsList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Job Domains",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "mu_reg",
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.jobMarketDataList.length,
                  itemBuilder: (context, index) {
                    final job = controller.jobMarketDataList[index];
                    return _buildJobDomainCard(job);
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildJobDomainCard(JobMarketModel job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  job.domain ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "mu_reg",
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: job.category == "Software"
                      ? Colors.blue[100]
                      : Colors.orange[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  job.category ?? "",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: job.category == "Software"
                        ? Colors.blue[800]
                        : Colors.orange[800],
                    fontFamily: "mu_reg",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            job.description ?? "",
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: "mu_reg",
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip("${job.marketShare?.toStringAsFixed(1)}% Market",
                  Icons.pie_chart),
              const SizedBox(width: 8),
              _buildInfoChip("${job.growthRate?.toStringAsFixed(1)}% Growth",
                  Icons.trending_up),
              const SizedBox(width: 8),
              _buildInfoChip(
                  "₹${(job.averageSalary! / 1000).toStringAsFixed(0)}K",
                  Icons.attach_money),
            ],
          ),
          const SizedBox(height: 8),
          if (job.skills != null && job.skills!.isNotEmpty)
            Wrap(
              children: job.skills!
                  .take(3)
                  .map((skill) => Container(
                        margin: const EdgeInsets.only(right: 4, bottom: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: muColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          skill,
                          style: TextStyle(
                            fontSize: 12,
                            color: muColor,
                            fontFamily: "mu_reg",
                          ),
                        ),
                      ))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: Colors.grey[600]),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontFamily: "mu_reg",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Market Insights",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "mu_reg",
              ),
            ),
            const SizedBox(height: 16),
            Obx(() => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.insightsList.length,
                  itemBuilder: (context, index) {
                    final insight = controller.insightsList[index];
                    return _buildInsightCard(insight);
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightCard(JobMarketInsight insight) {
    Color cardColor;
    IconData iconData;

    switch (insight.type) {
      case 'trend':
        cardColor = Colors.blue[50]!;
        iconData = Icons.trending_up;
        break;
      case 'opportunity':
        cardColor = Colors.green[50]!;
        iconData = Icons.lightbulb;
        break;
      case 'warning':
        cardColor = Colors.orange[50]!;
        iconData = Icons.warning;
        break;
      default:
        cardColor = Colors.grey[50]!;
        iconData = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(iconData, color: muColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "mu_reg",
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description ?? "",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: "mu_reg",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
