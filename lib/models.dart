import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Jobs extends Equatable {
  final List<GitHubJob> jobsGitHub;
  final List<SearchGovJob> jobsSearchGov;

  Jobs({@required this.jobsGitHub, @required this.jobsSearchGov});
}

class GitHubJob extends Jobs {
  String id;
  String type; //Full/Part Time
  String url;
  String createdAt;
  String company;
  String companyUrl;
  String location;
  String title;
  String description;
  String howToApply; //Emails to send cv to
  String companyLogoUrl;

  GitHubJob(
      {this.id,
      this.type,
      this.url,
      this.createdAt,
      this.company,
      this.companyUrl,
      this.location,
      this.title,
      this.description,
      this.howToApply,
      this.companyLogoUrl});

  static GitHubJob fromJson(dynamic json) {
    var jobGitHub = GitHubJob(
      id: json['id'].toString(),
      type: json['type'],
      url: json['url'].toString(),
      createdAt: json['created_at'].toString(),
      company: json['company'],
      companyUrl: json['company_url'].toString(),
      location: json['location'],
      title: json['title'],
      description: json['description'],
      howToApply: json['how_to_apply'],
      companyLogoUrl: json['company_logo'],
    );

    return jobGitHub;
  }
}

class SearchGovJob extends Jobs {
  String positionID;
  String positionTitle;
  String positionURI;
  List<String> applyURI;
  String organizationName;
  String departmentName;
  String location;
  String createdDate;

  SearchGovJob(
      {this.positionID,
      this.positionTitle,
      this.positionURI,
      this.applyURI,
      this.organizationName,
      this.departmentName,
      this.location,
      this.createdDate});

  static SearchGovJob fromJson(Map<String, dynamic> json) {
    var jobSearchGov = SearchGovJob(
        positionID: json['PositionID'].toString(),
        positionTitle: json['PositionTitle'],
        positionURI: json['PositionURI'].toString(),
        applyURI: List<String>.from(json['ApplyURI']),
        organizationName: json['OrganizationName'],
        departmentName: json['DepartmentName'],
        location: json['PositionLocation'][0]['LocationName'],
        createdDate: json['PositionStartDate'].toString());

    return jobSearchGov;
  }
}
