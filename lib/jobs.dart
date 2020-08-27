import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_helper_flutter_app/bloc.dart';
import 'package:job_helper_flutter_app/jobs_events.dart';
import 'package:job_helper_flutter_app/jobs_states.dart';
import 'package:url_launcher/url_launcher.dart';

class Jobs extends StatefulWidget {
  final jobRepository;

  Jobs({@required this.jobRepository})
      : assert(jobRepository != null),
        super();

  @override
  _JobsState createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  JobsBloc _jobsBloc;
  TextEditingController _jobTextController, _locationTextController;
  FocusNode _searchFocus;

  Map<String, dynamic> filterVars;

  @override
  void initState() {
    _jobsBloc = JobsBloc(widget.jobRepository);
    _jobTextController = TextEditingController();
    _locationTextController = TextEditingController();
    _searchFocus = FocusNode();

    filterVars = {'jobsGitHub': true, 'jobsSearchGov': true, 'location': null};

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: Center(
          child: Text('Jobs Finder', textAlign: TextAlign.center),
        ),
        title: TextField(
          controller: _jobTextController,
          focusNode: _searchFocus,
          style: TextStyle(color: Colors.amber, fontSize: 17.5),
          cursorColor: Colors.white,
          decoration: InputDecoration(
              hintText: 'search for a job...',
              hintStyle: TextStyle(fontSize: 17.5)),
          onSubmitted: (_) => _startJobBlocEvent(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search), onPressed: () => _startJobBlocEvent()),
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                        title: Text('Filter',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 30)),
                        content: Container(
                          height: 250,
                          child: ListView(
                            children: [
                              Text('By Provider'),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(children: [
                                      Text('GitHub',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Checkbox(
                                          value:
                                              filterVars['jobsGitHub'] as bool,
                                          onChanged: (value) {
                                            setState(() =>
                                                filterVars['jobsGitHub'] =
                                                    value);
                                          })
                                    ]),
                                    Row(children: [
                                      Text('Serach.Gov',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Checkbox(
                                          value: filterVars['jobsSearchGov']
                                              as bool,
                                          onChanged: (value) {
                                            setState(() =>
                                                filterVars['jobsSearchGov'] =
                                                    value);
                                          })
                                    ])
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Center(
                                  child: Container(
                                    color: Colors.grey[700],
                                    height: 1,
                                    width: 175,
                                  ),
                                ),
                              ),
                              Text('By Location'),
                              TextField(
                                controller: _locationTextController,
                                decoration: InputDecoration(
                                    hintText: 'enter location here..'),
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Center(
                                    child: FlatButton(
                                        color: Colors.amber,
                                        onPressed: () {
                                          filterVars['location'] =
                                              _locationTextController.text;
                                          _startJobBlocEvent();
                                          Navigator.pop(context);
                                        },
                                        child: Text("Apply"))),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }))
        ],
      ),
      body: Center(
        child: BlocBuilder(
          bloc: _jobsBloc,
          builder: (context, JobsState state) {
            if (state is JobsEmpty)
              return Text('Please search for a job..');
            else if (state is JobsLoading)
              return CircularProgressIndicator(semanticsLabel: 'Loading..');
            else if (state is JobsLoaded) {
              final jobs = state.jobs;

              return ListView.separated(
                  itemCount: jobs.jobsGitHub.length + jobs.jobsSearchGov.length,
                  //GitHub Jobs
                  itemBuilder: (context, position) {
                    if (!filterVars['jobsGitHub'] ||
                        position >= jobs.jobsGitHub.length) return Container();
                    return ListTile(
                        dense: true,
                        isThreeLine: true,
                        leading: Container(
                          width: 75,
                          height: 75,
                          child: Image.network(jobs
                                      .jobsGitHub[position].companyLogoUrl !=
                                  null
                              ? jobs.jobsGitHub[position].companyLogoUrl
                              : 'https://i.pinimg.com/originals/2d/6d/78/2d6d78cb202b3771de194b3a68be706c.jpg'),
                        ),
                        title: Text(
                          jobs.jobsGitHub[position].title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        subtitle: Text(jobs.jobsGitHub[position].company +
                            '\n' +
                            jobs.jobsGitHub[position].createdAt +
                            ' | ' +
                            jobs.jobsGitHub[position].location),
                        trailing: Container(
                            width: 20,
                            height: 20,
                            child: Image.asset('images/github_logo.png')),
                        onTap: () async =>
                            await launch(jobs.jobsGitHub[position].url));
                  },
                  //Search.Gov Jobs
                  separatorBuilder: (context, position) {
                    if (!filterVars['jobsSearchGov'] ||
                        position >= jobs.jobsSearchGov.length)
                      return Container();
                    return ListTile(
                        dense: true,
                        isThreeLine: true,
                        leading: Container(
                          width: 75,
                          height: 75,
                          child: Image.network(
                              'https://i.pinimg.com/originals/2d/6d/78/2d6d78cb202b3771de194b3a68be706c.jpg'),
                        ),
                        title: Text(
                          jobs.jobsSearchGov[position].positionTitle,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 2,
                        ),
                        subtitle: Text(
                            jobs.jobsSearchGov[position].organizationName +
                                '\n' +
                                jobs.jobsSearchGov[position].createdDate +
                                ' | ' +
                                jobs.jobsSearchGov[position].location),
                        trailing: Container(
                            width: 20,
                            height: 20,
                            child: Image.asset('images/search_gov_logo.png')),
                        onTap: () async => await launch(
                            jobs.jobsSearchGov[position].positionURI));
                  });
            }

            return Text('Something went wrong :(',
                style: TextStyle(color: Colors.red));
          },
        ),
      ),
    );
  }

  void _startJobBlocEvent() {
    String targetJob = _jobTextController.text;
    if (targetJob.isNotEmpty)
      _jobsBloc.add(FetchJobs(targetJob: targetJob, filterVars: filterVars));
    else
      FocusScope.of(context).requestFocus(_searchFocus);
  }
}
