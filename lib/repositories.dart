import 'dart:convert';
import 'data_providers.dart';
import 'models.dart';

class JobsRepository {
  JobsApiClient _jobsApiClient;

  JobsRepository(this._jobsApiClient) : assert(_jobsApiClient != null);

  Future<Jobs> getJobs(String targetJob, Map<String, dynamic> filterVars,
      {int page = 0, bool limitToFullTime = false}) async {
    //GitHub Section
    var jobsGitHub = List<GitHubJob>();
    if (filterVars['jobsGitHub'] as bool) {
      var resultedJobs =
          jsonDecode(await _jobsApiClient.getGitHubJobs(paramsGitHub: {
        'targetJob': targetJob,
        'paginate': page,
        'location': filterVars['location'] as String,
        'isFullTime': limitToFullTime
      })) as List;

      for (var job in resultedJobs) jobsGitHub.add(GitHubJob.fromJson(job));
    }

    //Search.Gov Section
    var jobsSearchGov = List<SearchGovJob>();
    if (filterVars['jobsSearchGov'] as bool) {
      final resultedJobs2 = jsonDecode(await _jobsApiClient.getSearchGovJobs(
          paramsSearchGov: {
            'targetJob': targetJob,
            'LocationName': filterVars['location'] as String
          }));
      final specificContent =
          resultedJobs2['SearchResult']['SearchResultItems'] as List;

      for (var job in specificContent)
        jobsSearchGov
            .add(SearchGovJob.fromJson(job['MatchedObjectDescriptor']));
    }

    return Jobs(jobsSearchGov: jobsSearchGov, jobsGitHub: jobsGitHub);
  }
}
