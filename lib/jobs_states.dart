import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'models.dart';

abstract class JobsState extends Equatable {
  JobsState([List props = const []]) : super([props]);
}

class JobsEmpty extends JobsState {}

class JobsLoading extends JobsState {}

class JobsLoaded extends JobsState {
  final Jobs jobs;

  JobsLoaded(this.jobs)
      : assert(jobs != null),
        super([jobs]);
}

class JobsError extends JobsState {
  final String error;

  JobsError({@required this.error})
      : assert(error != null),
        super([error]);
}

//States Delegate
class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onTransition(Bloc bloc, Transition transition) {
    print('The transaction is: $transition');
    super.onTransition(bloc, transition);
  }
}
