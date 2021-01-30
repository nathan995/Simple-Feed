import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial(LoadingStatus.loading, ErrorStatus.noError));

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is SetError) {
      yield ErrorState(ErrorStatus.error);
    } else if (event is SetNoError) {
      yield ErrorState(ErrorStatus.noError);
    } else if (event is SetLoading) {
      yield LoadingState(LoadingStatus.loading);
    } else if (event is SetNotLoading) {
      yield LoadingState(LoadingStatus.notLoading);
    }
  }
}
