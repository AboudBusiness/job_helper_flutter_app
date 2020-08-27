import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'data_providers.dart';
import 'jobs.dart';
import 'jobs_states.dart';
import 'repositories.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final jobsRepository = JobsRepository(JobsApiClient(Client()));

  runApp(JobsApp(jobsRepository));
}

class JobsApp extends StatelessWidget {
  final _jobsRepository;

  JobsApp(this._jobsRepository)
      : assert(_jobsRepository != null),
        super();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Jobs App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Jobs(
          jobRepository: _jobsRepository,
        ));
  }
}
