  class CompanyModel {
    int companyId;
    String companyName;
    String companyType;
    String companyWebsite;
    String companyLinkedin;

    CompanyModel({
      required this.companyId,
      required this.companyName,
      required this.companyType,
      required this.companyWebsite,
      required this.companyLinkedin,
    });

    factory CompanyModel.fromJson(Map<String, dynamic> json) {
      return CompanyModel(
        companyId: json['id'] ?? 0,
        companyName: json['company_name'] ?? "",
        companyType: json['company_type'] ?? "",
        companyWebsite: json['company_website'] ?? "",
        companyLinkedin: json['company_linkedin'] ?? "",
      );
    }

    Map<String, dynamic> toJson() {
      return {
        'id': companyId,
        'company_name': companyName,
        'company_type': companyType,
        'company_website': companyWebsite,
        'company_linkedin': companyLinkedin,
      };
    }
  }