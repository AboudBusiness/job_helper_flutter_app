import 'package:flutter_bloc/flutter_bloc.dart';
import 'jobs_states.dart';
import 'repositories.dart';
import 'jobs_events.dart';

class JobsBloc extends Bloc<JobsEvent, JobsState> {
  final JobsRepository jobsRepository;

  JobsBloc(this.jobsRepository) : assert(jobsRepository != null);

  @override
  JobsState get initialState => JobsEmpty();

  @override
  Stream<JobsState> mapEventToState(JobsEvent event) async* {
    if (event is FetchJobs) {
      yield JobsLoading();
      try {
        final jobs =
            await jobsRepository.getJobs(event.targetJob, event.filterVars);
        yield JobsLoaded(jobs);
      } catch (_) {
        yield JobsError(error: _.toString());
      }
    }
  }
}
