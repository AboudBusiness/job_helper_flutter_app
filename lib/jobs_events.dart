import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class JobsEvent extends Equatable {
  JobsEvent([List props = const []]) : super(props);
}

class FetchJobs extends JobsEvent {
  String targetJob;
  Map<String, dynamic> filterVars; //Providers, Location..

  FetchJobs({@required this.targetJob, @required this.filterVars})
      : assert(targetJob != null),
        super([targetJob, filterVars]);
}
