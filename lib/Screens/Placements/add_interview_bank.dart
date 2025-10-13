// lib/Screens/InterviewBank/add_interview_bank.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Controllers/interview_bank_controller.dart';
import '../../Controllers/company_list_controller.dart';
import '../../Helper/Components.dart';
import '../../Helper/Style.dart';
import '../../Helper/colors.dart';
import '../../Helper/size.dart';
import '../../Model/interview_bank_model.dart';
import '../../Model/company_model.dart';

class AddInterviewBankScreen extends StatefulWidget {
  const AddInterviewBankScreen({Key? key}) : super(key: key);

  @override
  State<AddInterviewBankScreen> createState() => _AddInterviewBankScreenState();
}

class _AddInterviewBankScreenState extends State<AddInterviewBankScreen> {
  // Controllers (ensure these are registered in your bindings or created here)
  final InterviewBankController interviewController = Get.find<InterviewBankController>();
  late CompanyListController companyController;

  final _formKey = GlobalKey<FormState>();
  late String mode; // 'add' or 'edit'
  InterviewBankModel? editing;

  // Student info (for add)
  int? passedStudentId;
  String? passedStudentName;
  int? passedBatchId;

  // Form controllers
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();

  // Selected company
  int? selectedCompanyId;

  // Local submit loading flag
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();

    // Get or put CompanyListController
    try {
      companyController = Get.find<CompanyListController>();
    } catch (e) {
      companyController = Get.put(CompanyListController());
    }

    final args = Get.arguments ?? {};
    mode = (args['mode'] ?? 'add').toString();

    // If editing, we expect 'interview' model
    if (mode == 'edit' && args['interview'] != null && args['interview'] is InterviewBankModel) {
      editing = args['interview'] as InterviewBankModel;
    }

    // Student info may be passed for add:
    if (args['student_id'] != null) {
      passedStudentId = int.tryParse(args['student_id'].toString());
    } else if (args['student'] != null && args['student'] is Map && args['student']['id'] != null) {
      passedStudentId = int.tryParse(args['student']['id'].toString());
    }

    if (args['student_name'] != null) {
      passedStudentName = args['student_name'].toString();
    } else if (args['student'] != null && args['student'] is Map && args['student']['name'] != null) {
      passedStudentName = args['student']['name'].toString();
    }

    if (args['batch_id'] != null) {
      passedBatchId = int.tryParse(args['batch_id'].toString());
    }

    // Prefill edit data when available
    if (editing != null) {
      // editing.IBDate expected in 'yyyy-MM-dd' from backend
      _dateController.text = editing!.IBDate;
      _dataController.text = editing!.IBData;
      selectedCompanyId = editing!.IBCompanyId;
      passedStudentId = editing!.IBStudentId;
      passedStudentName = editing!.IBStudentName;
    }

    // Fetch companies if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (companyController.companyList.isEmpty && !companyController.isLoadingCompanyList.value) {
        companyController.fetchCompanyList();
      }
    });
  }

  @override
  void dispose() {
    _dateController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime initial = DateTime.now();
    if (_dateController.text.isNotEmpty) {
      try {
        initial = DateTime.parse(_dateController.text);
      } catch (_) {}
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      setState(() {});
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Student must be present (passed from parent or editing)
    final int? studentId = passedStudentId;
    if (studentId == null || studentId == 0) {
      Get.snackbar('Missing Student', 'Open add screen from a student context or pass student_id',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (selectedCompanyId == null) {
      Get.snackbar('Select Company', 'Please select a company', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final String date = _dateController.text.trim();
    final String dataHtml = _dataController.text.trim();

    setState(() => isSubmitting = true);

    bool ok = false;
    try {
      if (mode == 'add') {
        ok = await interviewController.createInterview(
          studentId: studentId,
          companyId: selectedCompanyId!,
          date: date,
          dataHtml: dataHtml,
        );
      } else {
        // editing
        final id = editing!.IBId;
        ok = await interviewController.updateInterview(
          id: id,
          studentId: studentId,
          companyId: selectedCompanyId!,
          date: date,
          dataHtml: dataHtml,
        );
      }

      if (ok) {
        Get.back(result: true); // signal caller to refresh
      } else {
        Get.snackbar('Failed', 'Operation failed. Try again.', backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Error', '$e', backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  Widget _companyPicker(BuildContext context) {
    return Obx(() {
      if (companyController.isLoadingCompanyList.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final List<CompanyModel> comps = companyController.filteredCompanyList;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search box to filter companies (uses controller.searchController)
          TextField(
            controller: companyController.searchController,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Search company',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onChanged: companyController.filterCompanies,
          ),
          const SizedBox(height: 8),
          comps.isEmpty
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('No companies available.'),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => companyController.fetchCompanyList(),
                child: const Text('Reload Companies'),
              ),
            ],
          )
              : DropdownButtonFormField<int>(value: selectedCompanyId,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Select Company',
            ),
            items: comps.map((c) {
              return DropdownMenuItem<int>(
                value: c.companyId,
                child: Text(c.companyName),
              );
            }).toList(),
            onChanged: (v) => setState(() => selectedCompanyId = v),
            validator: (v) => v == null ? 'Please select a company' : null,
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = mode == 'add' ? 'Add Interview' : 'Edit Interview';
    final displayedStudentLabel = (passedStudentName != null && passedStudentName!.isNotEmpty)
        ? passedStudentName
        : (passedStudentId != null ? 'Student ID: ${passedStudentId}' : 'No student provided');

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: appbarStyle(context)),
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_rounded, color: backgroundColor), onPressed: () => Get.back()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Student display (read-only)
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Student', style: TextStyle(fontSize: getSize(context, 1.8), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: Text(
                  displayedStudentLabel!,
                  style: TextStyle(fontSize: getSize(context, 1.8)),
                ),
              ),
              const SizedBox(height: 16),

              // Company dropdown + search
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Company', style: TextStyle(fontSize: getSize(context, 1.8), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              _companyPicker(context),
              const SizedBox(height: 16),

              // Date
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Date', style: TextStyle(fontSize: getSize(context, 1.8), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'yyyy-MM-dd',
                ),
                onTap: () => _pickDate(context),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Pick a date' : null,
              ),
              const SizedBox(height: 16),

              // Data HTML / Notes
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Interview Data / Notes', style: TextStyle(fontSize: getSize(context, 1.8), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _dataController,
                minLines: 5,
                maxLines: 12,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter interview notes / HTML',
                ),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter interview data' : null,
              ),
              const SizedBox(height: 24),

              // Submit button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(backgroundColor: muColor),
                  child: isSubmitting
                      ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.red))
                      : Text(mode == 'add' ? 'Create' : 'Update', style: TextStyle(fontSize: getSize(context, 2))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
