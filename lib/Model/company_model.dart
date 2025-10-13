class CompanyModel {
  int companyId;
  String companyName;
  String companyType;
  List<String> companyDomain; // now a list
  String companyWebsite;
  String companyLinkedin;
  String aboutCompany;

  CompanyModel({
    required this.companyId,
    required this.companyName,
    required this.companyType,  
    required this.companyDomain,
    required this.companyWebsite,
    required this.companyLinkedin,
    required this.aboutCompany,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      companyId: json['id'] ?? 0,
      companyName: json['company_name'] ?? "",
      companyType: json['company_type'] ?? "",
      companyDomain: (json['company_domain'] as String?)?.split(",").map((e) => e.trim()).toList() ?? [],
      companyWebsite: json['company_website'] ?? "",
      companyLinkedin: json['company_linkedin'] ?? "",
      aboutCompany: json['about_company'] ?? ""
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': companyId,
      'company_name': companyName,
      'company_type': companyType,
      'company_domain': companyDomain.join(", "),
      'company_website': companyWebsite,
      'company_linkedin': companyLinkedin,
      'about_company': aboutCompany,
    };
  }
}
