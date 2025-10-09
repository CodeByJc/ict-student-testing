class JobMarketModel {
  String? domain;
  String? category;
  double? marketShare;
  double? growthRate;
  int? totalJobs;
  double? averageSalary;
  String? description;
  List<String>? skills;
  String? futureOutlook;
  int? demandLevel; // 1-5 scale

  JobMarketModel({
    this.domain,
    this.category,
    this.marketShare,
    this.growthRate,
    this.totalJobs,
    this.averageSalary,
    this.description,
    this.skills,
    this.futureOutlook,
    this.demandLevel,
  });

  factory JobMarketModel.fromJson(Map<String, dynamic> json) {
    return JobMarketModel(
      domain: json['domain'],
      category: json['category'],
      marketShare: json['market_share']?.toDouble(),
      growthRate: json['growth_rate']?.toDouble(),
      totalJobs: json['total_jobs'],
      averageSalary: json['average_salary']?.toDouble(),
      description: json['description'],
      skills: json['skills'] != null ? List<String>.from(json['skills']) : [],
      futureOutlook: json['future_outlook'],
      demandLevel: json['demand_level'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'domain': domain,
      'category': category,
      'market_share': marketShare,
      'growth_rate': growthRate,
      'total_jobs': totalJobs,
      'average_salary': averageSalary,
      'description': description,
      'skills': skills,
      'future_outlook': futureOutlook,
      'demand_level': demandLevel,
    };
  }
}

class JobMarketInsight {
  String? title;
  String? description;
  String? type; // 'trend', 'opportunity', 'warning'
  double? confidence;

  JobMarketInsight({
    this.title,
    this.description,
    this.type,
    this.confidence,
  });

  factory JobMarketInsight.fromJson(Map<String, dynamic> json) {
    return JobMarketInsight(
      title: json['title'],
      description: json['description'],
      type: json['type'],
      confidence: json['confidence']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type,
      'confidence': confidence,
    };
  }
}

