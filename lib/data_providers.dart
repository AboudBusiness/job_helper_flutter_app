import 'package:flutter/material.dart';
import 'package:http/http.dart';

class JobsApiClient {
  static const String _baseGitHubUrl = 'https://jobs.github.com/positions.json';
  static const String _baseSearchGovUrl = 'https://data.usajobs.gov/api/search';

  Client _httpClient;

  JobsApiClient(this._httpClient) : assert(_httpClient != null);

  Future<String> getGitHubJobs(
      {@required Map<String, dynamic> paramsGitHub}) async {
    String location = paramsGitHub['location'] != null
        ? '&location=' + paramsGitHub['location']
        : '';

    String url =
        '$_baseGitHubUrl?search=${paramsGitHub['targetJob']}&full_time=${paramsGitHub['isFullTime']}$location&page=${paramsGitHub['paginate']}';
    final result = await _httpClient.get(url);

    if (result.statusCode != 200)
      throw Exception('Error getting jobs from GitHub');

    return result.body;
  }

  Future<String> getSearchGovJobs(
      {@required Map<String, dynamic> paramsSearchGov}) async {
    String location = paramsSearchGov['LocationName'] != null
        ? '&LocationName=' + paramsSearchGov['LocationName']
        : '';

    String url =
        '$_baseSearchGovUrl?PositionTitle=${paramsSearchGov['targetJob']}$location';
    final result = await _httpClient.get(url, headers: {
      "Host": 'data.usajobs.gov',
      "User-Agent": 'aboudshbusiness@gmail.com',
      "Authorization-Key": 'FA1wTqCfzRc2EznUciOHaKibqM/DRop8gspMQfvu/UA='
    });

    if (result.statusCode != 200)
      throw Exception('Error getting jobs from SearchGov');

    return result.body;
  }
}
